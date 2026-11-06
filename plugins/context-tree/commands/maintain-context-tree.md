# Maintain Context Tree

**Purpose:** Thin orchestrator that runs one or more maintenance skills against an existing Context Tree.

**Overview:** Each maintenance mode below is a focused skill. This command presents the menu and invokes the selected skill(s). For implementation logic, see each skill's `SKILL.md`.

---

## Maintenance Menu

Present this menu to the user:

```
Context Tree Maintenance (v4)

Choose an option:

1. Learning Review (~5-10 min)
   → Read git history for recent learnings and repeated friction (Rule of Two)
   → Model judges what matters; verified against code

2. Drift Detector (~5-10 min)
   → Validate doc claims against code
   → Scoped to docs whose code changed since last check (full sweep on request)

3. Tree Health (~2 min)
   → Quick structural check: links, sizes, frontmatter, knowledge.yaml

4. Memory Promoter (~3-5 min)
   → Scan ~/.claude/projects/<proj>/memory/ for rules and traps to promote
   → Verify against code, offer to file into committed Context Tree

5. All (full maintenance run)
   → Runs 1, 2, 3, 4 in sequence
   → Recommended monthly

What would you like to do? (1-5)
```

---

## Routing

| Option | Skill invoked |
|---|---|
| 1 | `learning-capture` (Learning Review) |
| 2 | `drift-detector` |
| 3 | `tree-health` |
| 4 | `memory-promoter` |
| 5 | All four, in order |

Each skill's SKILL.md contains its full execution logic. This command does **not** duplicate that logic — it routes.

---

## Option 5: Full Maintenance Run

Run skills in this order:

1. `tree-health` first (cheap structural check; surfaces issues that affect later skills)
2. `drift-detector` (fix incorrect claims before adding new ones)
3. `learning-capture` (recent learnings and repeated friction from git history)
4. `memory-promoter` (promote auto-memory signal that has stabilized)

After each skill completes, summarize what it changed before invoking the next.

Final summary template:

```
Full Maintenance Run Summary

Tree Health:
- [issues found / fixed]

Drift Detector:
- [claims fixed / pruned]

Learning Review:
- [learnings and repeated patterns filed]

Memory Promoter:
- [memory entries promoted to tree]

Total commits: N
```

---

## Natural Guidance (No Mode Required)

When the user says something like:

> "I just figured out webhooks use HMAC auth, not bearer tokens. Should we document this?"

Respond naturally — don't make them pick a menu option. Verify against code, draft 2-5 lines, show the target location, apply on approval. Don't offer unprompted capture during normal work; auto-memory already captures session insights, and `memory-promoter` brings the stable ones into the tree.

---

## Important Notes

- This command operates on **existing** Context Trees. For initial build, use `/build-context-tree`.
- For external source ingestion (post-mortems, Slack threads, wikis), use `/ingest-context`.
- For promoting personal auto-memory entries to the committed tree, use option 4 here, or invoke `memory-promoter` directly.
- Quality gates apply at every step. Every change verified against code. User approves every addition.

---

**Present the menu, route to the selected skill(s), report summary.**
