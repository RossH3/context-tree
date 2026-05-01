---
name: rule-of-two-detector
description: Analyze git history to detect Rule of Two violations - patterns that have happened twice and should be documented before the third occurrence. Use when the user asks to find documentation gaps, run a git learning analysis, or detect repeated patterns in the codebase. Also activates as part of /maintain-context-tree.
---

# Rule of Two Detector

## Purpose

Find patterns in git history that indicate documentation opportunities. The Rule of Two: if the team has hit the same friction twice, the third time should be prevented by documentation.

**Five signals analyzed:**
1. Repeated fix patterns (same issue, different files)
2. Defensive comments added (IMPORTANT, DON'T, NEVER)
3. High-churn files (≥5 changes — confusion zone)
4. Terminology inconsistencies (multiple names for same concept)
5. Explicit learning words in commits (TIL, gotcha, figured out)

---

## Execution

1. **Run git-learning-detector:**
   ```bash
   ${CLAUDE_PLUGIN_ROOT}/git-learning-detector.sh --since=3.months
   ```

2. **Parse output for the five signal types.**

3. **For each high-priority pattern:**
   - **Verify against code** — Read mentioned files; confirm pattern exists today
   - **Check existing docs** — Search the Context Tree for prior coverage (don't duplicate)
   - **Assess value** — Would documenting prevent a third occurrence?

4. **Present recommendations one at a time:**
   ```
   HIGH PRIORITY: clientid filtering (5 occurrences)

   Pattern: 5 defensive comments about multi-tenant filtering
   Files: app/controllers/*.java (3 controllers)
   Last: 4 days ago

   Recommendation: Add to CLAUDE.md Common Pitfalls

   Draft:
   ❌ DON'T write queries without clientid filter
   ✅ DO always include: String clientid = request().host()
      Security critical: Missing clientid causes tenant data leakage

   Verified:
   - ✅ Pattern in 47 controller methods
   - ✅ 3 recent fixes
   - ✅ Security-critical

   Add now? (y/n)
   ```

5. **Apply approved changes:**
   - Read target file, identify section, Edit to add content
   - Commit: `docs: capture [pattern] from git analysis`

---

## Distinction from `learning-capture`

- This skill looks at **team-wide patterns over months** (repeated mistakes, churn hotspots).
- `learning-capture` looks at **individual learnings over days** (recent breakthroughs).
- This skill asks "what does the team keep getting wrong?"
- `learning-capture` asks "what did we just figure out?"

Use both for full coverage.

---

## Core Principles

- **Verify against code, not docs** — patterns may have been refactored away
- **Signal-to-noise** — only document if it would justify token cost in CLAUDE.md
- **Single source of truth** — check before adding; reference, don't duplicate

---

**Run when:** `/maintain-context-tree` (option 1), or whenever the user asks for a git pattern analysis or wants to find documentation gaps from history.
