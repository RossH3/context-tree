# Maintain Context Tree

**Purpose:** Thin orchestrator that runs one or more maintenance skills against an existing Context Tree.

**Overview:** Each maintenance mode below is a focused skill. This command presents the menu and invokes the selected skill(s). For implementation logic, see each skill's `SKILL.md`.

---

## Maintenance Menu

Present this menu to the user:

```
Context Tree Maintenance (v4)

Choose an option:

1. Rule-of-Two Detector (~5 min)
   → Analyze git history for repeated patterns
   → Identifies what to document based on team behavior

2. Drift Detector (~10 min)
   → Validate doc claims against code
   → Fix or remove stale content

3. Tree Health (~2 min)
   → Quick structural check: links, sizes, frontmatter, knowledge.yaml

4. Learning Capture / Review (~5-10 min)
   → Harvest undocumented learnings from recent git activity

5. Memory Promoter (~3-5 min) [v4]
   → Scan ~/.claude/projects/<proj>/memory/ for entries to promote
   → Verify against code, offer to file into committed Context Tree

6. All (full maintenance run)
   → Runs 1, 2, 3, 4, 5 in sequence
   → Recommended monthly

What would you like to do? (1-6)
```

---

## Routing

| Option | Skill invoked |
|---|---|
| 1 | `rule-of-two-detector` |
| 2 | `drift-detector` |
| 3 | `tree-health` |
| 4 | `learning-capture` (Learning Review mode) |
| 5 | `memory-promoter` |
| 6 | All five, in order |

Each skill's SKILL.md contains its full execution logic. This command does **not** duplicate that logic — it routes.

---

## Option 6: Full Maintenance Run

Run skills in this order:

1. `tree-health` first (cheap structural check; surfaces issues that affect later skills)
2. `drift-detector` (fix incorrect claims before adding new ones)
3. `rule-of-two-detector` (long-horizon team patterns)
4. `learning-capture` (recent individual learnings)
5. `memory-promoter` (promote auto-memory signal that has stabilized)

After each skill completes, summarize what it changed before invoking the next.

Final summary template:

```
Full Maintenance Run Summary

Tree Health:
- [issues found / fixed]

Drift Detector:
- [claims fixed / pruned]

Rule-of-Two Detector:
- [patterns found / documented]

Learning Capture:
- [recent learnings filed]

Memory Promoter:
- [memory entries promoted to tree]

Total commits: N
```

---

## Natural Guidance (No Mode Required)

When the user says something like:

> "I just figured out webhooks use HMAC auth, not bearer tokens. Should we document this?"

Respond naturally — don't make them pick a menu option. Verify against code, draft 2-5 lines, show the target location, apply on approval. The `learning-capture` skill's proactive-capture mode covers this implicitly during normal work.

---

## Important Notes

- This command operates on **existing** Context Trees. For initial build, use `/build-context-tree`.
- For external source ingestion (post-mortems, Slack threads, wikis), use `/ingest-context`.
- For promoting personal auto-memory entries to the committed tree, use option 5 here, or invoke `memory-promoter` directly.
- Quality gates apply at every step. Every change verified against code. User approves every addition.

---

**Present the menu, route to the selected skill(s), report summary.**
