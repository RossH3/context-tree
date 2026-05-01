# Ingest Context (External Source Processing)

**Purpose:** Extract and verify insights from external sources into existing Context Tree docs

**Overview:** This command processes external knowledge sources -- post-mortems, incident reports, meeting notes, Slack exports, wiki pages, or any text document -- and integrates verified insights into your existing Context Tree.

---

## Supported Source Types

| Source | How to Provide |
|---|---|
| File on disk | Provide path to .md, .txt, .har, .json, .html file |
| Pasted text | Paste content directly into the conversation |

**Tip:** For Slack threads, use your Slack workspace's export or copy-paste the thread. For web pages, save as markdown or HTML first. Keep it simple -- the value is in the verification, not the acquisition.

---

## Workflow

### Step 1: Source Acquisition

Ask the user:
```
What source would you like to ingest?

- Provide a file path (e.g., ~/docs/incident-report-2026-03.md)
- Or paste the text directly

What kind of source is this? (helps me extract the right signals)
- Post-mortem / incident report
- Meeting notes / transcript
- Slack thread export
- Wiki / documentation page
- HAR file (HTTP archive)
- Other
```

**Read the source content.** For files, use the Read tool. For pasted text, capture inline.

**For HAR files specifically:** Parse the JSON and focus on: endpoint URLs, HTTP methods, status codes, auth headers, and error response bodies. Ignore request/response bodies unless they contain error messages or configuration.

---

### Step 2: Insight Extraction

**Decide: subagent or inline?**

- **Inline extraction** if any of these hold:
  - The source is already loaded in the current context (e.g., the user pasted it, or you read it earlier in this session)
  - The source is small (<500 lines / <~5K tokens)
  - The source has already been parsed structurally (e.g., HAR file already filtered down to relevant fields)

  Apply the extraction logic from `${CLAUDE_PLUGIN_ROOT}/docs/workflow-prompts/source-ingestion.md` directly. **Do not re-read the source via subagent** — that's wasteful and burns tokens for no gain.

- **Subagent extraction** if the source is large (>500 lines), needs to be loaded fresh, or you want context-window isolation:

  Spawn subagent with `${CLAUDE_PLUGIN_ROOT}/docs/workflow-prompts/source-ingestion.md`. Pass:
  - The raw source content (or path)
  - The source type (from Step 1)
  - Paths to existing Context Tree docs (CLAUDE.md, docs/*.md) for deduplication context

In both cases, the output is structured candidate insights with categories, verification targets, and confidence levels.

---

### Step 3: Verification Against Code

**This is what separates Context Tree from raw wiki ingestion.**

For each candidate insight returned by the subagent:

1. **Execute the verification target** (grep for terms, read implementation files, check patterns)
2. **Rate the insight:**
   - **Confirmed** -- Code evidence supports the claim
   - **Partial** -- Some evidence, but incomplete or ambiguous
   - **Source-attested** -- Cannot verify against code (historical context, business decisions), but source is attributed
   - **Contradicted** -- Code evidence contradicts the claim

3. **Decision:**
   - Confirmed / Partial: Proceed to deduplication
   - Source-attested: Proceed only if from attributed source (named author, official document)
   - Contradicted: **Reject immediately.** Log the contradiction.

---

### Step 4: Deduplication

For each verified insight:

1. **Search existing docs** for the key terms (grep CLAUDE.md, docs/*.md)
2. **Classify:**
   - **NEW** -- Not documented anywhere. Candidate for addition.
   - **EXTENDS** -- Existing doc has related content that could be enriched. Candidate for update.
   - **EXISTING** -- Already documented adequately. Log as confirmation, don't duplicate.

---

### Step 5: User Review

Present verified, non-duplicate insights one at a time:

```
Insight 1 of 3: [Short Title]

Source: [source description]
Claim: "[extracted claim in 1-2 sentences]"
Verified: [Confirmed / Partial / Source-attested] -- [evidence summary]
Status: [NEW / EXTENDS existing doc]
Target: [target doc] -> [section]

Draft:
  [2-5 lines of proposed documentation text]

Add this? (y/n)
```

**For each accepted insight:**
- Read the target file
- Identify the appropriate section
- Use Edit tool to add the content
- Follow existing formatting conventions in the target file
- **If the target has v4 frontmatter:**
  - Update `verified: YYYY-MM-DD` to today's date for the affected section
  - If the doc's `source` is `build`, leave it (the doc origin is unchanged); the section being added carries its own provenance via the ingest log

**After all insights reviewed:**
- Commit accepted changes: `docs: ingest context from [source description]`

---

### Step 6: Ingest Log

Append to `docs/context-tree-build/ingest-log.md` (create if it doesn't exist):

```markdown
## Ingest: [Source Description] ([Date])

**Source:** [type + identifier/filename]
**Insights extracted:** N
**Verified:** N confirmed, N partial, N contradicted
**New (added):** N
**Already documented:** N
**Rejected:** N (reasons)

### Added:
1. [Insight title] -> [target doc + section]

### Confirmed existing:
1. [Insight] -> already in [doc]:L[line]

### Rejected:
1. [Insight] -> [reason: contradicted by code / unverifiable / user declined]
```

---

## Quality Gates

### Stricter Than Interview

External sources have no interactive verification loop (you can't ask a Slack thread follow-up questions). Apply these gates:

1. **Code verification required** for all factual claims about code behavior. No exceptions.

2. **Unverifiable claims** (historical context, business decisions, future plans) are only included if:
   - Source is attributed (named author, official document, not anonymous)
   - Claim is tagged as "source-attested, not code-verified" in the doc
   - Attribution is included: `*(Source: [author/document], [date])*`

3. **Contradicted claims are rejected and logged.** If a source says "we use X" but code shows "we use Y", the claim is rejected. This protects against stale information contaminating docs.

4. **The >= 3 quality gate for new doc creation still applies.** Ingesting one source doesn't create a new ARCHITECTURE.md. Insights go into existing docs if they exist, or into CLAUDE.md inline. A new doc is only created when cumulative insights push a category past the 3-item threshold.

5. **Deduplication is mandatory.** Every insight is checked against existing docs. "Confirms existing" is logged but doesn't create duplicate content.

6. **User approval on every addition.** Nothing gets added without explicit user approval.

---

## Verification Protocol by Claim Type

### Code Behavior
*"Webhooks use HMAC auth, not bearer tokens"*
- Grep for HMAC, read webhook handler files, find signature check
- Must find code evidence. If found: confirmed. If not: contradicted or unverifiable.

### Architecture Pattern
*"Redis is write-through cache for Postgres"*
- Read data access layer, find write paths, confirm dual-write pattern
- Structural evidence must be visible in code.

### Terminology Mapping
*"Users call it 'Submission' but code says 'Order'"*
- Grep for both terms, find UI strings with one and model classes with the other
- Both terms must exist in codebase in the claimed contexts.

### Business Rule
*"Nightly batch job runs at midnight on the deadline date"*
- Find scheduler/cron config, find batch execution code, check timing
- Code should implement or enforce the rule.

### Historical Context
*"We kept the legacy framework version because upgrading breaks the plugin"*
- Verify current state (check actual framework version in build files)
- Tag unverifiable parts as "source-attested" with attribution.

### Operational Knowledge
*"Deploy triggers cache flush"*
- Look for deploy scripts, CI/CD config, cache management code
- If not in the repo: mark as "ops-attested, not in codebase."

---

## Core Principles (Same as All Context Tree)

1. **Verify against code, not docs** -- External sources can be stale or wrong
2. **Signal-to-noise ratio** -- Only ingest what justifies token cost
3. **Bad context is worse than bad code** -- Reject anything contradicted by code
4. **Single source of truth** -- Enrich existing docs, don't create parallel versions

---

## After Completion

1. **Commit changes** with message: `docs: ingest context from [source description]`
2. **Report summary** to user (N extracted, N added, N rejected)
3. **Suggest next steps** if applicable:
   - "Several insights were about [topic] -- consider running a focused interview on that area"
   - "Rejection rate was high -- this source may be outdated"

---

## Important Notes

- This command requires an existing Context Tree (for initial build, use `/build-context-tree`)
- The ingest log provides an audit trail of what was processed and what decisions were made
- Contradicted claims in the log can reveal documentation that needs updating (source says old truth, code has new truth)
- Multiple sources can be ingested sequentially -- the log tracks cumulative coverage

---

**Begin source acquisition now.**
