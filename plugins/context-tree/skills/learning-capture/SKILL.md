---
name: learning-capture
description: Review git history for learnings and repeated friction that never made it into the Context Tree (Learning Review, including Rule of Two patterns). Use when the user asks to find documentation gaps, review recent development for missed insights, or detect repeated patterns in history, or as part of /maintain-context-tree. Also use when a session shows that an existing Context Tree doc is wrong.
---

# Learning Capture

## Purpose

Knowledge compounds when captured. This skill reads git history for two things the Context Tree is missing:

- **Recent learnings** (days to weeks): what did we just figure out?
- **Repeated friction** (months): what does the team keep getting wrong? This is the Rule of Two: if the team hit the same problem twice, document it before the third time.

Git history is the team's record. Auto-memory only sees your own sessions, so this is where repeated team friction shows up.

**Retired:**
- The in-session "want me to file this?" nudge (v4.1.0). Auto-memory already captures session insights; stable ones reach the tree through `memory-promoter`.
- The `rule-of-two-detector` skill and its regex script (v4.2.0), folded in here. See "Why judgment, not a script" below.

---

## Learning Review

### 1. Pick the window

- Default: `--since=2.weeks` for recent learnings, `--since=3.months` for repeated friction. Run both unless the user asks for one.
- Get the raw material:
  ```bash
  git log --since=<window> --format='%h %ad %s' --date=short
  git log --since=<window> --stat --format='%h %s'
  git log --since=<window> --format= --name-only | sort | uniq -c | sort -rn | head -20
  ```
- Read diffs only for commits that look worth it. Don't read every diff.

### 2. Look for these, using judgment

These are things worth noticing, not a checklist to score. Decide what is salient for *this* codebase.

- **Repeated fixes**: the same kind of fix in different places or at different times.
- **Defensive comments added**: `IMPORTANT`, `DON'T`, `NEVER`, `WARNING` written into source by a person. Skip generated files, vendored code, diagrams, lockfiles, and pasted tool output.
- **High-churn files**: a file changed many times in the window is often a confusion zone. Ask why before documenting it.
- **Terminology drift**: several names for one concept (`orgId`, `org_id`, `organizationId`). These are GLOSSARY candidates.
- **Learning words in commits**: TIL, turns out, figured out, gotcha, the real issue was, actually.
- **Revert-then-fix pairs and multi-step debugging**: something was misunderstood and then corrected.
- **First use of a pattern or library** in the codebase.

Prefer **rules and traps** ("never do X", "looks like Y but is Z") over status. Status rots; leave it in work files.

### 3. For each candidate

- **Summarize** what was learned or what keeps going wrong.
- **Check docs.** Search CLAUDE.md and docs/. Don't duplicate; extend or skip.
- **Verify against current code.** The pattern may have been refactored away.
- **Assess value.** Would this prevent confusion for a future developer or agent? Is it worth its token cost?

### 4. Present one at a time

```
LEARNING: Webhook retry behavior (recent)

Source: commits abc123, def456 (3 days ago)
What happened: Debugging showed webhooks retry 3x with exponential backoff,
not the 5x linear retry assumed.
Verified: Confirmed — src/webhooks/retry_config.js:12 (max_retries=3, backoff=exponential)

Target: ARCHITECTURE.md → System Interactions

Draft:
### Webhook Retry Behavior
- Max retries: 3 (not 5)
- Backoff: exponential (1s, 2s, 4s)
- File: src/webhooks/retry_config.js:12

Add now? (y/n)
```

```
PATTERN: tenant filter missing from queries (repeated, 3 fixes in 3 months)

Source: commits 1a2b3c, 4d5e6f, 7g8h9i; 2 defensive comments added
Verified: Confirmed — filter required in 47 controller methods; 3 recent fixes

Target: CLAUDE.md → Common Pitfalls

Draft:
❌ DON'T write queries without the tenant filter
✅ DO always include the tenant id from the request host
   Security-critical: a missing filter leaks data across tenants

Add now? (y/n)
```

Root `CLAUDE.md` is loaded into every session. Put a pattern there only if it shapes most changes; otherwise use a `docs/*.md` file.

### 5. Apply approved changes

- Read the target file, find the section, Edit to add content.
- Commit: `docs: capture [learning] from git history`

---

## Doc Contradictions During Work

The one in-session behavior that stays. Auto-memory never touches committed docs, so nothing else catches a Context Tree doc that the code now contradicts.

When work shows that a Context Tree doc is wrong, say so in one sentence and offer a fix:

```
docs/ARCHITECTURE.md says sessions live in Redis; config/session.js:8 uses cookies.
Want me to fix the doc? (y/n)
```

On yes: verify, draft the correction, show it, apply only after approval. On no: move on. For a broader audit, use `drift-detector`.

---

## Why judgment, not a script

Through v4.1.0, `rule-of-two-detector` ran a regex script over git history and scored five signal types. On a real production repo it reported 207 "defensive comments" in three months, and the examples were SSH warnings and SVG diagram text committed to the repo, not warnings a person wrote. The signals were right; the fixed rules for spotting them weren't.

Anthropic's memory research found the same thing: stronger models do better when told what memory is *for* and left to judge salience, and fixed capture rules can cut the benefit. So the signals above are kept as guidance, and the model decides what matters. The old script and the full finding are in `historical/RULE_OF_TWO_DETECTOR.md`.

---

## Core Principles

- **Verify against code** — every captured learning is verified before it lands
- **Signal-to-noise** — 2-5 lines max per learning; expand only if cross-cutting
- **Single source of truth** — consolidate; don't fragment a topic across docs
- **Rules and traps, not status** — status rots; leave it in work files

---

**Run when:** `/maintain-context-tree` (option 1), when the user asks for a git history review or documentation gaps, or when a session shows a Context Tree doc is wrong.
