---
name: learning-capture
description: Capture undocumented learnings into the Context Tree - either by reviewing recent git commits (Learning Review mode) or by offering proactive capture during normal work when a non-obvious synthesis is produced. Use when reviewing recent development for missed insights, or naturally during a session when a debugging discovery, architectural realization, or non-obvious cross-file synthesis happens. Also activates as part of /maintain-context-tree.
---

# Learning Capture

## Purpose

Knowledge compounds when captured. Two modes:

1. **Learning Review** (batch) — Harvest learnings from recent git history that didn't get documented in real time
2. **Proactive Capture** (in-flow) — During normal work, offer a gentle nudge to file non-obvious synthesis before it evaporates into chat history

This skill does both. The user invokes it via `/maintain-context-tree` for batch mode; it activates implicitly during work for proactive mode.

---

## Mode 1: Learning Review (Batch)

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
   - **Assess value** — Would this prevent confusion for future devs/AI?
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

## Mode 2: Proactive Capture (In-Flow)

### When to offer

During normal work, offer to capture when:
- Your answer required reading 3+ files to synthesize
- The user expressed surprise ("oh, THAT's how it works")
- You corrected your own initial assumption ("actually, it's not X, it's Y")
- Your answer contradicts existing docs (fix the doc!)
- A debugging session revealed non-obvious system behavior

### When NOT to offer

- Single-file, obvious patterns
- Already-documented insights
- Too task-specific to be reusable
- User is clearly focused/in a hurry (read the room)
- You've already offered once this session and they declined

### Format — keep it to one sentence

```
I traced this through 4 files — this interaction isn't documented.
Want me to file it into ARCHITECTURE.md? (y/n)
```

### If they say yes

1. Verify the insight against code (same discipline)
2. Draft 2-5 lines for appropriate doc and section
3. Show draft and target location
4. Apply only after approval
5. Commit: `docs: capture [insight] from development session`

### If they say no

Move on immediately. Don't explain why you offered.

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
- **Read the room** for proactive mode — easy to dismiss, never insistent

---

**Run when:** `/maintain-context-tree` (option 4 / Learning Review), or implicitly during normal work when a capture-worthy moment occurs.
