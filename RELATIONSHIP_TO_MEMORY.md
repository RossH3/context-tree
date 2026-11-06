# Context Tree and Claude Code Memory

**How Context Tree relates to Anthropic's auto-memory and dreaming**

---

## TL;DR

Anthropic is building the personal memory stack. **Claude Code auto-memory** writes notes as you work. **Dreaming** is an offline pass that reorganizes a memory store, checks it against session transcripts, and surfaces patterns across sessions ([Components of agent memory](https://www.anthropic.com/research/components-of-agent-memory)). Curating memory is Anthropic's work, and Context Tree doesn't attempt it.

**Where dreaming runs today (2026-11-06):** only in the Managed Agents API, as a research preview ([Dreams](https://platform.claude.com/docs/en/managed-agents/dreams)). Claude Code documents no background consolidation pass. Its memory files "stay until you or Claude edits or deletes them" ([Claude Code memory docs](https://code.claude.com/docs/en/memory)). Context Tree still leaves memory alone. Anthropic is plainly moving in this direction, and a plugin that curates memory would be redoing their work, less well.

Context Tree keeps the layer dreaming doesn't reach: docs **committed to the repo, verified against code, and reviewed by the team**.

| | Anthropic memory (auto-memory; dreaming in Managed Agents) | Context Tree (this plugin) |
|---|---|---|
| Author | Claude, in session (dreaming: offline job) | Human + Claude, with approval per change |
| Ground truth for verification | Session transcripts (dreaming) | The code |
| Scope | One user's machine, per project | The repo: committed, team-shared |
| Content | What Claude learned while working with *you* | What is true about *this codebase* |
| Curation | In-session edits by Claude; dreaming where available | Drift checks and PR review |
| Quality gate | Claude's judgment of salience | "Better no doc than bad doc" |
| Lives in | `~/.claude/projects/<proj>/memory/` | `CLAUDE.md` + `docs/` (in repo) |

---

## What dreaming is

From the [Dreams docs](https://platform.claude.com/docs/en/managed-agents/dreams): agents write to memory stores as they work, but "over many sessions a memory store accumulates duplicates, contradictions, and stale entries." A dream is an asynchronous job that reads a memory store and 1 to 100 past session transcripts, then writes a **new** store with duplicates merged, stale or contradicted entries replaced, and new insights surfaced. The input store is never modified.

The research article adds what dreaming is for:

- Moving information between layers: transcripts → notes → wikis → injected context.
- Checking notes against transcripts and correcting wrong ones.
- Searching across sessions for shared patterns and repeated mistakes.
- Keeping the injected layer small, with detail moved down and links left behind.

**Consequence for this plugin:** don't build memory curation. Anything that dedupes, prunes, or reorganizes `~/.claude/projects/<proj>/memory/` duplicates what Anthropic is building. Context Tree never writes to auto-memory.

---

## What dreaming does not cover

Context Tree is worth keeping for three structural reasons:

1. **Code is a different ground truth from transcripts.** A transcript records what happened in a session. It can confirm that a command failed or that a file was read. It cannot confirm that the code still behaves the way a note says after someone else's commit. Context Tree verifies claims with grep and file reads against the current tree. A memory-promoter run caught a memory claiming a config value was removed when the Dockerfile set it to 300 MB. A transcript check would not have caught that.
2. **Team scope.** Dreaming covers agents sharing a memory store, not people sharing knowledge through a repo. Memory stays on one machine. Context Tree goes through git, gets reviewed in PRs, and reaches every teammate's sessions, including a team that inherits the repo.
3. **Institutional knowledge.** The domain expert interview captures what no session ever saw: why a decision was made, what the business rule really is, which tenant is the exception. Dreaming can only reorganize what was already written down.

---

## Lessons the article confirms

These were Context Tree principles before the article. The research backs them, and they now shape the plugin:

| Article finding | Context Tree principle |
|---|---|
| Salience matters more than volume. One run wrote 413 files and earned one badge; another wrote 9 files and earned four. | Signal-to-noise. Every line earns its token cost. |
| Don't store what the environment already shows. Store strategy and tested rules. | Don't document what the code says. Document what it doesn't. |
| Wikis bloat (one reached 1.77× its source corpus) and need compute to avoid accumulated errors. | Better no doc than bad doc. Drift detection is mandatory, not optional. |
| Injected context is loaded every session, and a wrong note gets carried into every session. | Root `CLAUDE.md` stays short and is always in drift scope; detail lives in lazily loaded `docs/*.md`. |
| Concentrate re-verification on volatile information. | `drift-detector` audits docs whose code changed since they were last checked. |
| Tell the model what memory is for; fixed capture rules can hurt (a "record only failures" rule cut one model's gain by 0.234). | Learning Review gives the model signals to look for, not a regex script to score. |
| Give each shared page a single writer. | Git + PR review. |

**Status rots; rules age well.** A hand-run prune of a 162-file project memory (down to 123) found almost nothing worth dropping. What had gone bad was status: notes that contradicted later notes, and one large note that had become a stale copy of the repo, with an obsolete instruction a few paragraphs from the rule it violated. Short rule-shaped notes ("never do X", "this looks like Y but is Z") were still correct months later. Promote that kind of note. Leave status where it is.

---

## How they interact

Context Tree treats auto-memory as a **read-only signal source** and promotes what has stabilized up into the repo after checking it against code.

**Promotion mapping** (auto-memory type → likely Context Tree home):

| Auto-memory type | Promote to | Notes |
|---|---|---|
| `user` | **Stay in memory** | About the human, never about the codebase |
| `feedback` | Root `CLAUDE.md` (working preferences) | Only if correct for any teammate |
| `project` | `TROUBLESHOOTING.md` / `BUSINESS_CONTEXT.md` | Traps and decisions, not status |
| `reference` | `GLOSSARY.md` / `ARCHITECTURE.md` / `AI_STRATEGIES.md` | Pointers, terminology, patterns |

**Critical rule: Context Tree never writes to auto-memory.** When a promotion run finds a memory that the code contradicts, it reports it. Fixing memory is the user's call.

---

## Skill status

| Skill | Overlap with Anthropic memory | Status |
|---|---|---|
| `drift-detector` | None. Verifies docs against code. | **Core.** Scoped by default to docs whose referenced code changed (v4.2.0). |
| `memory-promoter` | Partial. Anthropic curates memory; it doesn't verify against code or write to the repo. | **Keep, narrowed** to verify-and-promote. Reports contradictions; no memory upkeep. |
| `learning-capture` | Low for Learning Review: git history is the team's record, which memory never reads. | Keep. Absorbed `rule-of-two-detector` (v4.2.0); in-flow nudge retired (v4.1.0); still flags docs that work shows are wrong. |
| `tree-health` | Low. Structural checks on repo docs. | Keep. Cheap. |
| ~~`rule-of-two-detector`~~ | — | **Retired in v4.2.0.** Its regex script was mostly noise in production; signals moved into `learning-capture`. See `historical/RULE_OF_TWO_DETECTOR.md`. |

---

## Decision flow: where does this fact go?

```
You learn something new during work.

├─ Is it about you (your preferences, your machine)?
│  └─ Auto-memory handles it. Done.
│
├─ Is it status (blocked on X, next step is Y)?
│  └─ Work file in the repo (NEXT-SESSION, README). Not memory, not the tree.
│
├─ Is it true about the codebase?
│  ├─ Verified against code?
│  │  ├─ Yes, and it's a rule or trap that will matter again?
│  │  │  └─ Context Tree. Add 2-3 lines to the right doc.
│  │  ├─ Yes, but only seen once?
│  │  │  └─ Let auto-memory hold it. Promote later if it recurs.
│  │  └─ No, can't verify?
│  │     └─ Don't commit it. Bad context is worse than bad code.
│  └─ Unsure if it's still true?
│     └─ Verify against code first. If stale, fix the source (code or doc).
│
└─ Is it about an external system or process?
   └─ Context Tree if the team needs it (AI_STRATEGIES.md or similar).
      Auto-memory if just for you.
```

---

## For maintainers of this plugin

Before adding a feature, ask: *is Anthropic doing this, or clearly heading there?*

- If yes → don't build it. Read from memory instead.
- If yes, but without code verification or team scope → that's the Context Tree opportunity.
- If no → that's the Context Tree opportunity.

The plugin's value is what Anthropic's memory structurally cannot do: **verify against code, share through git, reject bad context at review, and capture institutional knowledge through the domain expert interview.**

---

*Established 2026-05-01 (v4.0.0). Revised 2026-11-06 for dreaming (v4.1.0) and corrected the same day (v4.2.0): dreaming is a Managed Agents API feature, not part of Claude Code.*
