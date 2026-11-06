# Context Tree and Claude Code Memory

**How Context Tree relates to Anthropic's auto-memory and dreaming**

---

## TL;DR

Anthropic now covers the whole personal memory stack. Auto-memory writes notes during sessions. Dreaming, an offline pass, reorganizes them, checks them against session transcripts, and finds patterns across sessions ([Components of agent memory](https://www.anthropic.com/research/components-of-agent-memory)). That is the curation work Context Tree used to do by hand, and Anthropic does it better.

Context Tree keeps the one layer dreaming does not reach: docs **committed to the repo, verified against code, and reviewed by the team**.

| | Auto-memory + dreaming (Anthropic) | Context Tree (this plugin) |
|---|---|---|
| Author | Claude, in session and in offline passes | Human + Claude, with approval per change |
| Ground truth for verification | Session transcripts | The code |
| Scope | One user's machine, per project | The repo: committed, team-shared |
| Content | What Claude learned while working with *you* | What is true about *this codebase* |
| Curation | Dreaming: reorganize, correct, dedupe | Drift checks and PR review |
| Quality gate | Claude's judgment of salience | "Better no doc than bad doc" |
| Lives in | `~/.claude/projects/<proj>/memory/` | `CLAUDE.md` + `docs/` (in repo) |

---

## What changed

Before dreaming, auto-memory only wrote notes. Nothing kept them current, so Context Tree took on curation work: catching stale notes, contradictions, and repeated friction, and deciding what deserved a permanent home.

The article describes dreaming as doing that work:

- Moving information between layers: transcripts → notes → wikis → injected context.
- Checking notes against transcripts and correcting wrong ones.
- Searching across sessions for shared patterns and repeated mistakes.
- Keeping the injected layer small, with detail moved down and links left behind.

**Consequence for this plugin:** don't build memory curation. Anything that dedupes, prunes, or reorganizes `~/.claude/projects/<proj>/memory/` duplicates dreaming. That was always off-limits (Context Tree never writes to auto-memory), and now there's no gap to fill either.

---

## What dreaming does not cover

Context Tree is worth keeping for three structural reasons:

1. **Code is a different ground truth from transcripts.** A transcript records what happened in a session. It can confirm that a command failed or that a file was read. It cannot confirm that the code still behaves the way a note says after someone else's commit. Context Tree verifies claims with grep and file reads against the current tree. A memory-promoter run caught a memory claiming a config value was removed when the Dockerfile set it to 300 MB. A transcript check would not have caught that.
2. **Team scope.** The article covers agents sharing a log, not people sharing knowledge through a repo. Memory stays on one machine. Context Tree goes through git, gets reviewed in PRs, and reaches every teammate's sessions, including a team that inherits the repo.
3. **Institutional knowledge.** The domain expert interview captures what no session ever saw: why a decision was made, what the business rule really is, which tenant is the exception. Dreaming can only reorganize what was already written down.

---

## Lessons the article confirms

These were Context Tree principles before the article. The research backs them, and they now shape what gets promoted:

| Article finding | Context Tree principle |
|---|---|
| Salience matters more than volume. One run wrote 413 files and earned one badge; another wrote 9 files and earned four. | Signal-to-noise. Every line earns its token cost. |
| Don't store what the environment already shows. Store strategy and tested rules. | Don't document what the code says. Document what it doesn't. |
| Wikis bloat (one reached 1.77× its source corpus) and need compute to avoid accumulated errors. | Better no doc than bad doc. Drift detection is mandatory, not optional. |
| Injected context is loaded every session, and a wrong note gets carried into every session. | Root `CLAUDE.md` stays short; detail lives in lazily loaded `docs/*.md`. |
| Concentrate re-verification on volatile information. | Promote rules and traps; leave status in work files. |
| Give each shared page a single writer. | Git + PR review. |

**Status rots; rules age well.** A hand-run prune of a 162-file project memory (down to 123) found almost nothing worth dropping. What had gone bad was status: notes that contradicted later notes, and one large note that had become a stale copy of the repo, with an obsolete instruction a few paragraphs from the rule it violated. Short rule-shaped notes ("never do X", "this looks like Y but is Z") were still correct months later. Promote that kind of note. Leave status where it is.

---

## How they interact

Context Tree treats auto-memory as a **read-only signal source**. Dreaming keeps memory consistent; Context Tree promotes what has stabilized up into the repo after checking it against code.

**Promotion mapping** (auto-memory type → likely Context Tree home):

| Auto-memory type | Promote to | Notes |
|---|---|---|
| `user` | **Stay in memory** | About the human, never about the codebase |
| `feedback` | Root `CLAUDE.md` (working preferences) | Only if correct for any teammate |
| `project` | `TROUBLESHOOTING.md` / `BUSINESS_CONTEXT.md` | Traps and decisions, not status |
| `reference` | `GLOSSARY.md` / `ARCHITECTURE.md` / `AI_STRATEGIES.md` | Pointers, terminology, patterns |

**Critical rule: Context Tree never writes to auto-memory.** When a promotion run finds a memory that the code contradicts, it reports it to the user. Fixing it is the user's call, or dreaming's.

---

## Skill status after dreaming

| Skill | Overlap with dreaming | Status |
|---|---|---|
| `drift-detector` | None. Verifies docs against code. | **Core.** This is the differentiator. |
| `memory-promoter` | Partial. Dreaming curates memory; it doesn't verify against code or write to the repo. | **Keep, narrowed** to verify-and-promote. No memory hygiene. |
| `tree-health` | Low. Dreaming repairs links in memory wikis, not repo docs. | Keep. Cheap structural check. |
| `rule-of-two-detector` | Partial. Dreaming finds repeated mistakes across *your sessions*; this reads *the team's git history*. | Keep for team signal. |
| `learning-capture` | High for Proactive Capture: in-session note writing plus dreaming covers it. Learning Review (from git) is distinct. | Retire the in-flow nudge; keep Learning Review, or fold it into `rule-of-two-detector`. |

---

## Decision flow: where does this fact go?

```
You learn something new during work.

├─ Is it about you (your preferences, your machine)?
│  └─ Auto-memory handles it; dreaming keeps it current. Done.
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

Before adding a feature, ask: *do auto-memory or dreaming already do this?*

- If yes → don't build it. Read from memory instead.
- If yes, but without code verification or team scope → that's the Context Tree opportunity.
- If no → that's the Context Tree opportunity.

The plugin's value is what Anthropic's memory structurally cannot do: **verify against code, share through git, reject bad context at review, and capture institutional knowledge through the domain expert interview.**

---

*Established 2026-05-01 (v4.0.0). Revised 2026-11-06 for dreaming, per Anthropic's "Components of agent memory."*
