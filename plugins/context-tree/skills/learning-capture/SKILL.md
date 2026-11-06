---
name: learning-capture
description: Harvest undocumented learnings from recent git history into the Context Tree (Learning Review). Use when reviewing recent development for missed insights, or as part of /maintain-context-tree. Also use when a session shows that an existing Context Tree doc is wrong.
---

# Learning Capture

## Purpose

Knowledge compounds when captured. This skill reviews recent git history for learnings that never made it into the Context Tree, verifies them against code, and offers to file them.

**What this skill no longer does:** the in-session "want me to file this?" nudge (Proactive Capture) was retired in v4.1.0. Auto-memory captures session insights and dreaming curates them; offering to file each one competed with both. Insights that stabilize in memory reach the tree through `memory-promoter`, with code verification.

---

## Learning Review

### Execution

1. **Analyze recent activity:**
   ```bash
   git log --since=2.weeks --oneline
   git log --since=2.weeks --stat
   ```

2. **Detect learning signals:**
   - **Multi-step debugging** — Revert → investigation → fix patterns; commits close in time touching the same area, especially with messages like "revert", "actually", "try different approach"
   - **Complex commits** — Changes touching 3+ files across subsystems (a cross-cutting concern got figured out)
   - **Learning words** — TIL, figured out, turns out, actually, gotcha, misunderstood, the real issue was
   - **New patterns** — First use of a technique, library, or pattern in the codebase
   - **Revert-then-fix pairs** — Something was misunderstood, then corrected

3. **For each detected learning:**
   - **Summarize** what was learned (read the diff if needed)
   - **Check docs** — Already in Context Tree? Search CLAUDE.md and docs/
   - **Assess value** — Would this prevent confusion for future devs/AI? Prefer rules and traps over status
   - **If undocumented and valuable** — Draft, verify against current code, present

4. **Present recommendations one at a time:**
   ```
   LEARNING: Webhook retry behavior

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

5. **Apply approved changes:**
   - Read target file, identify section, Edit to add content
   - Commit: `docs: capture [learning] from recent development`

---

## Doc Contradictions During Work

The one in-session behavior that stays. Dreaming corrects memory, not committed docs, so nothing else catches a Context Tree doc that the code now contradicts.

When work shows that a Context Tree doc is wrong, say so in one sentence and offer a fix:

```
docs/ARCHITECTURE.md says sessions live in Redis; config/session.js:8 uses cookies.
Want me to fix the doc? (y/n)
```

On yes: verify, draft the correction, show it, apply only after approval. On no: move on. For a broad audit, use `drift-detector`.

---

## Distinction from `rule-of-two-detector`

- This skill: **individual learnings over days/weeks** ("what did we just figure out?")
- Rule-of-two: **team-wide patterns over months** ("what does the team keep getting wrong?")

Use both. They cover different time horizons and different signals.

---

## Core Principles

- **Verify against code** — every captured learning is verified before it lands
- **Signal-to-noise** — 2-5 lines max per learning; expand only if cross-cutting
- **Single source of truth** — consolidate; don't fragment a topic across docs
- **Rules and traps, not status** — status rots; leave it in work files

---

**Run when:** `/maintain-context-tree` (option 4 / Learning Review), or when a session shows a Context Tree doc is wrong.
