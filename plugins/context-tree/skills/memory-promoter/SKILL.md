---
name: memory-promoter
description: Scan Claude Code's auto-memory directory (~/.claude/projects/<proj>/memory/) for entries that should be promoted into the committed Context Tree. Read-only of memory; verifies each candidate against code; offers to file into the appropriate Context Tree doc with user approval. Use when reviewing what auto-memory has accumulated, or as part of /maintain-context-tree.
---

# Memory Promoter

## Purpose

Anthropic's auto-memory captures things Claude observes during your sessions and writes them to `~/.claude/projects/<proj>/memory/`. Personal scope, machine-local, no verification.

**This skill is the bridge.** It reads auto-memory, identifies entries whose *content* belongs in the committed team-shared Context Tree, verifies each candidate against code, and offers to promote them. The user approves every promotion.

**Read-only.** This skill never writes to or modifies auto-memory. Anthropic owns that surface. We promote signal up; we leave it alone.

---

## When to Run

- `/maintain-context-tree` (option 5)
- After accumulated session work — when several memory entries have been written that you suspect contain codebase-level truths
- Periodically (monthly, alongside other maintenance)

**Do not run frequently on a fresh memory dir** — there's no signal to promote yet. The Rule of Two applies here too: a memory entry written once may be ephemeral; one that has stabilized through use is a promotion candidate.

---

## Step 1: Locate the Memory Directory

The memory directory path encodes the project root. For a project at `/Users/<user>/projects/<repo>`:

```
~/.claude/projects/-Users-<user>-projects-<repo>/memory/
```

Slashes become dashes. Confirm the path exists before proceeding. If empty, report "no memory entries to promote" and exit.

---

## Step 2: Read MEMORY.md and Topic Files

```
Reading memory index...
~/.claude/projects/<proj>/memory/MEMORY.md (index)
~/.claude/projects/<proj>/memory/<topic>.md (each entry)
```

For each topic file, parse the frontmatter:

```yaml
---
name: <descriptive name>
description: <one-line purpose>
type: <user|feedback|project|reference>
---
```

The `type` field drives the promotion mapping below.

---

## Step 3: Classify Each Entry

| Memory type | Promotion verdict | Default target |
|---|---|---|
| `user` | **Skip — never promote** | Stays in memory (it's about the human) |
| `feedback` | Maybe (only if generalizable beyond one user) | Root `CLAUDE.md` (working preferences section) |
| `project` | Strong candidate | `BUSINESS_CONTEXT.md` or `TROUBLESHOOTING.md` |
| `reference` | Strong candidate | `GLOSSARY.md`, `ARCHITECTURE.md`, or `AI_STRATEGIES.md` (depending on content) |

**The rule on `feedback`:** Memory writes "this user prefers X" but the committed Context Tree must speak in collective voice. Only promote `feedback` entries when the preference would be correct for any teammate working in the repo (e.g., "use the Bun dev script, not npm run dev" — true for everyone). Personal preferences ("Ross likes terse responses") stay in memory.

**The rule on `user`:** Never promote. Even if the user explicitly asks. `user` type is reserved for facts about the human and has no committed-team analog.

### Hot-load cost: prefer lazy targets

Root `CLAUDE.md` is **eager-loaded into every Claude Code session** for this repo. Anything you put there pays its token cost on every interaction, forever. `docs/*.md` files are **lazy-loaded** via `knowledge.yaml` routing or explicit reference — they cost nothing until triggered.

When choosing a promotion target, weigh the cost:

| Fact type | Right target | Reasoning |
|---|---|---|
| Load-bearing for most tasks (e.g., "always filter by clientid") | Root `CLAUDE.md` | Cost is justified — it shapes nearly every change |
| Historical / lineage / context (e.g., "forked from upstream-project years ago") | `docs/ARCHITECTURE.md` § History, or `docs/HISTORY.md` | Lazy-loaded; surfaces only when relevant |
| Domain terminology | `docs/GLOSSARY.md` | Lazy-loaded |
| Architectural pattern with security/correctness implications | `docs/ARCHITECTURE.md` | Lazy-loaded but high-priority in routing |
| Ongoing-incident or recently-fixed issue | `docs/TROUBLESHOOTING.md` | Lazy-loaded |
| Working preference applicable to all teammates | Root `CLAUDE.md` (sparingly) | Eager load is necessary if it shapes behavior |

**Default bias: lazy.** When unsure between root `CLAUDE.md` and a `docs/*.md`, choose the doc. Root grows expensive fast.

### Skip-reason categories (be specific in summary)

When skipping a memory entry, classify the reason — don't lump everything as "skipped." Use these categories in the run summary so the user can spot patterns (e.g., "Claude is accumulating self-reflective memory cruft"):

| Skip category | What it means | Example |
|---|---|---|
| `personal-preference` | `user`/`feedback` about how Ross works | "User prefers terse responses" |
| `meta-feedback` | Feedback about Claude's past behavior in some report or session | "The friction analysis incorrectly framed planning as a problem" |
| `local-machine-context` | Paths or env specific to this user's laptop | "the related-project is at ~/projects/related-project" |
| `index-pointer` | A MEMORY.md section that just links to topic files; the topic files are the real candidates | "## Infrastructure: see project_X.md" |
| `already-productized` | The memory's content has been turned into a skill or tool | "Bitbucket→GitHub migration runbook" (now a skill) |
| `already-documented` | The fact is already in the Context Tree | (this is `EXISTING` from Step 5; report distinctly from above) |

Report counts per category in the summary table. Catching a growing `meta-feedback` count over time means auto-memory is collecting commentary on past sessions and probably needs human pruning.

---

## Step 4: Verify Each Candidate Against Code

Same verification discipline as `/ingest-context`. For each candidate:

1. Identify the verifiable claim (if any)
2. Grep for relevant patterns; read implementation files
3. Rate:
   - **Confirmed** — code evidence supports the claim
   - **Partial** — some evidence, ambiguous
   - **Source-attested** — cannot verify against code (e.g., business decision); promote only if the memory entry attributes a source
   - **Contradicted** — code disagrees. **Reject and surface for the user** (this means auto-memory captured something stale or wrong)

Contradicted is interesting: it may signal that the user's auto-memory has incorrect information that should be deleted. Surface this. The user can ask Claude to update the memory file (we don't do it for them — that's user-initiated maintenance of their own memory).

---

## Step 5: Deduplicate Against Existing Context Tree

For each verified candidate:

- Search CLAUDE.md and docs/*.md for related content
- Classify:
  - **NEW** — not in tree, candidate for addition
  - **EXTENDS** — related content exists; candidate for enrichment
  - **EXISTING** — already covered; log as "confirmed by memory" but don't duplicate

---

## Step 6: Present Promotions One at a Time

```
Memory entry 1 of 3: <name>

Source: ~/.claude/projects/<proj>/memory/<file>.md
Type: reference
Description: <from frontmatter>

Claim: "<extracted claim>"
Verified: Confirmed — src/foo.js:42 (matches the pattern described)
Status: NEW
Target: docs/ARCHITECTURE.md → System Interactions

Draft (will be appended to target):
  ### <Heading>
  <2-5 lines>

Promote to Context Tree? (y/n)
[y = file it; n = skip; s = skip and mark to never re-suggest]
```

If `s` (skip permanently): record the memory file path in `docs/context-tree-build/promotion-skips.md` so future runs of this skill don't re-suggest it.

---

## Step 7: Apply Approved Promotions

For each `y`:

- Read target file
- Identify section
- Edit to add content (with frontmatter `source: promoted-from-memory` if the target is a v4 doc with frontmatter)
- Commit: `docs: promote [topic] from auto-memory`

The auto-memory entry stays untouched. It will keep getting loaded into your sessions; the committed tree now also has it (with verification + team scope).

---

## Step 8: Promotion Log

Append to `docs/context-tree-build/promotion-log.md` (create if absent):

```markdown
## Promotion Run: <Date>

**Memory entries scanned:** N
**Candidates (after type filter):** N
**Verified:** N confirmed, N partial, N source-attested, N contradicted
**Promoted:** N
**Already documented:** N
**Skipped by category:**
- personal-preference: N
- meta-feedback: N (watch this — high counts mean memory is accumulating self-reflection cruft)
- local-machine-context: N
- index-pointer: N
- already-productized: N
- user-declined: N
**Contradicted (flagged for user review):** N

### Promoted:
1. [memory entry] → [target doc + section]

### Contradicted (memory disagrees with code):
1. [memory entry path] — [what memory says vs what code shows]
   → User may want to update the memory file
```

---

## Distinction from `/ingest-context`

| | `/ingest-context` | `memory-promoter` |
|---|---|---|
| Source | External (post-mortems, Slack, wikis) | Local auto-memory directory |
| Trigger | User runs explicitly with a source | User runs to promote accumulated memory |
| Scope | One source per invocation | All memory files in the project's memory dir |
| Author of source | External | Claude (during sessions) |

Both use the same verification + deduplication + user-approval discipline. The difference is just the source.

---

## Core Principles

- **Read-only of auto-memory.** Never write to it. Anthropic owns that surface.
- **`user` type never promotes.** Period.
- **Verify against code.** Same discipline as ingest.
- **Single source of truth.** If memory and Context Tree disagree, code wins; flag the contradiction.
- **User approves every promotion.** Nothing lands without explicit yes.

---

**Run when:** `/maintain-context-tree` (option 5), or whenever the user wants to review what auto-memory has accumulated and promote signal into the committed tree.
