# Context Tree and Claude Code Memory

**How Context Tree relates to Anthropic's auto-memory feature**

---

## TL;DR

| | Auto-memory (Anthropic) | Context Tree (this plugin) |
|---|---|---|
| Author | Claude (passive observation) | Human + Claude (active discipline) |
| Verification | None | Required against code |
| Scope | User's machine, per project | Repo (committed, team-shared) |
| Content | What Claude learned about *me* | What's true about *this codebase* |
| Trigger | Implicit (corrections) | Explicit (Rule of Two, interview, ingest) |
| Quality gate | None | "Better no doc than bad doc" |
| Lives in | `~/.claude/projects/<proj>/memory/` | `CLAUDE.md` + `docs/` (in repo) |

**They are complementary, not competitive.** Auto-memory is your personal scratchpad. Context Tree is the committed institutional knowledge layer for the codebase.

---

## The boundary

Auto-memory captures what Claude observes about you and your work *as you go*. It survives sessions but stays on your machine. Anthropic designed it to be lightweight, automatic, and personal — there is no verification step, no quality gate, and nothing to commit.

Context Tree captures what is *true about the codebase*, verified against code, written down to be shared with the team. It is committed to git, reviewed in PRs, and read by every Claude Code session in the repo (yours and your teammates').

Stated as a rule:

> Auto-memory is for facts about the *human and their working style*. Context Tree is for facts about the *codebase and its institutional knowledge*.

When in doubt: if the fact would be wrong for a teammate, it belongs in auto-memory. If the fact would be wrong for *the codebase six months from now*, it doesn't belong anywhere — fix the underlying issue.

---

## How they interact

Context Tree treats auto-memory as a **read-only signal source**. The `memory-promoter` skill scans `~/.claude/projects/<proj>/memory/` for entries whose *content* belongs in the committed Context Tree (typically `feedback`, `project`, or `reference` typed memories that describe code rather than the user).

This is the natural answer to the Rule of Two problem. Auto-memory is already capturing things Claude found noteworthy — Context Tree's job is to **promote** the signal that has stabilized, after verifying it against code, into the team-shared layer.

**Promotion mapping** (auto-memory type → likely Context Tree home):

| Auto-memory type | Promote to | Notes |
|---|---|---|
| `user` | **Stay in memory** | About the human, never about the codebase |
| `feedback` | Root `CLAUDE.md` (working preferences) | Only if generalizable beyond one user |
| `project` | `BUSINESS_CONTEXT.md` / `TROUBLESHOOTING.md` | Project context, ongoing work |
| `reference` | `GLOSSARY.md` / `ARCHITECTURE.md` / `AI_STRATEGIES.md` | Pointers, terminology, patterns |

Critical rule: **Context Tree never writes to auto-memory.** Anthropic owns that surface. We read; we promote up; we leave it alone.

---

## What Context Tree borrows from auto-memory

Anthropic's design choices for auto-memory are good, and Context Tree adopts the ones that fit:

- **Frontmatter convention** — `name`, `description`, `type` fields on each doc make purpose explicit and machine-readable
- **Index file** — Auto-memory's `MEMORY.md` is the conceptual cousin of Context Tree's `knowledge.yaml` (KCP manifest). Both are routing layers; ours is richer because Context Tree docs are bigger and need triggers/decision trees
- **Topic files load on-demand** — Auto-memory keeps `MEMORY.md` short and lazy-loads topic files. Context Tree's CLAUDE.md (under 200 lines) plus separate `docs/*.md` follows the same shape

What Context Tree keeps separate:

- **Vocabulary** — Auto-memory's `user/feedback/project/reference` types and Context Tree's doc names (`GLOSSARY/ARCHITECTURE/BUSINESS_CONTEXT/...`) are orthogonal axes. Auto-memory's types describe *who/what the knowledge serves*; Context Tree's doc names describe *content domain*. Both vocabularies stay; we just map between them.
- **Verification discipline** — Anthropic doesn't require it; Context Tree does. This is the central differentiator.
- **Scope** — Auto-memory is local; Context Tree is committed. Don't blur this.

---

## Decision flow: where does this fact go?

```
You learn something new during work.

├─ Is it about you (your preferences, your machine)?
│  └─ Auto-memory handles it. Done.
│
├─ Is it true about the codebase?
│  ├─ Verified against code?
│  │  ├─ Yes, and you've hit it twice (Rule of Two)?
│  │  │  └─ Context Tree. Add 2-3 lines to the right doc.
│  │  ├─ Yes, but only seen once?
│  │  │  └─ Let auto-memory hold it. Promote later if it recurs.
│  │  └─ No, can't verify?
│  │     └─ Don't write it down. Bad context is worse than bad code.
│  └─ Unsure if it's still true?
│     └─ Verify first. If stale, fix the source (code or doc).
│
└─ Is it about an external system or process?
   └─ Context Tree if team needs it (reference type → AI_STRATEGIES.md or similar).
      Auto-memory if just for you.
```

---

## For maintainers of this plugin

When designing new Context Tree features, ask: *does auto-memory already do this?*

- If yes, and Anthropic does it well → don't reimplement. Read from it instead.
- If yes, but auto-memory's version lacks verification or team scope → that's the Context Tree opportunity.
- If no → that's the Context Tree opportunity.

The plugin's value is **everything auto-memory structurally cannot do**: verification against code, team sharing via git, quality gates that reject bad context, and the domain expert interview that captures institutional knowledge AI cannot infer.

---

*Document established: 2026-05-01 (v4.0.0). Reflects Claude Code memory feature as of v2.1.59+.*
