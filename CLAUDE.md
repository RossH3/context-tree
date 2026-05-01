# Context Tree Plugin - Development Repository

**Claude Code plugin development repository for brownfield codebase documentation**

---

## What This Repository Is

This is the **plugin development repository** for Context Tree — a Claude Code plugin that helps document brownfield codebases through automated discovery, domain expert interviews, multi-source ingestion, and promotion of auto-memory entries into committed team knowledge.

**Users install this plugin from a marketplace (this repo, or a downstream copy).** This repo is for developing and maintaining the plugin itself.

## Defining Frame (post-auto-memory)

Anthropic's Claude Code now ships auto-memory (`~/.claude/projects/<proj>/memory/`). That's a personal, machine-local, unverified scratchpad. **Context Tree is the committed, verified, team-shared layer.** They are complementary:

- Auto-memory captures what Claude observes about *you and your work*. Personal scope.
- Context Tree captures what is true about *the codebase*. Repo scope, committed to git, verified against code, reviewed in PRs.

When designing plugin features, the test is: *does auto-memory already do this?* If yes and Anthropic does it well, don't reimplement — read from it instead. The plugin's value is everything auto-memory structurally cannot do: code verification, team sharing via git, quality gates that reject bad context, and the domain expert interview.

See `RELATIONSHIP_TO_MEMORY.md` for the full mapping.

---

## Key Documentation Files

### For Understanding the Plugin

**Start here:**
- `RELATIONSHIP_TO_MEMORY.md` — How Context Tree relates to Anthropic auto-memory ⭐ START HERE
- `AI_DOCUMENTATION_FIELD_GUIDE.md` — Practical lessons, real examples from production use
- `README.md` — Plugin overview, installation, usage
- `CONTEXT_TREE_PRINCIPLES.md` — Core theory: signal-to-noise, verification discipline

### Plugin Architecture (v4.0.0)

**Commands (3) — explicit human-invoked workflows:**
- `plugins/context-tree/commands/build-context-tree.md` — Main 3-phase orchestrator (build)
- `plugins/context-tree/commands/maintain-context-tree.md` — Thin orchestrator that invokes maintenance skills
- `plugins/context-tree/commands/ingest-context.md` — Multi-source ingestion with code verification

**Workflow Prompts (4) — subagent prompts for build/ingest phases:**
- `plugins/context-tree/docs/workflow-prompts/codebase-discovery.md` — Phase 1
- `plugins/context-tree/docs/workflow-prompts/domain-interview.md` — Phase 2
- `plugins/context-tree/docs/workflow-prompts/doc-generator.md` — Phase 3 (emits frontmatter, optional knowledge.yaml)
- `plugins/context-tree/docs/workflow-prompts/source-ingestion.md` — External source insight extraction

**Skills (5 composable) — context-dependent behaviors:**
- `rule-of-two-detector` — Detects repeated patterns in git history (was Mode 1)
- `drift-detector` — Validates doc claims against code, prunes stale content (was Mode 2)
- `tree-health` — Link/structure/size validation (was Mode 3)
- `learning-capture` — Harvests undocumented learnings + proactive capture during work (was Mode 4 + nudge)
- `memory-promoter` — **NEW v4** — Reads auto-memory, verifies against code, promotes signal to committed tree

**Utilities:**
- `plugins/context-tree/git-learning-detector.sh` — Shell script for Rule of Two detection

### Historical Context

**Evolution docs:**
- `historical/` - Preserved approaches that didn't scale (learning context only)

---

## Plugin Structure (v4.0.0)

```
.claude-plugin/
└── marketplace.json                # Repo-level marketplace manifest (for sharing)

plugins/context-tree/
├── .claude-plugin/
│   └── plugin.json                # Plugin metadata (v4.0.1)
├── commands/
│   ├── build-context-tree.md      # Main 3-phase orchestrator
│   ├── maintain-context-tree.md   # Thin orchestrator -> maintenance skills
│   └── ingest-context.md          # Multi-source ingestion
├── docs/
│   └── workflow-prompts/          # Subagent prompts (4 total)
├── skills/
│   ├── rule-of-two-detector/      # Git pattern detection
│   ├── drift-detector/            # Doc claims vs code validation
│   ├── tree-health/               # Structure/link/size checks
│   ├── learning-capture/          # Recent learnings + proactive nudge
│   └── memory-promoter/           # Auto-memory -> committed tree (NEW v4)
└── git-learning-detector.sh       # Utility script
```

---

## Core Principles (V4)

From 9+ months of production experimentation:

1. **Verify against code, not docs** — Documentation lies, code doesn't
2. **Signal-to-noise ratio** — Every line must justify token cost
3. **Incremental capture (Rule of Two)** — Can't predict what matters upfront
4. **Quality over quantity** — Better no doc than bad doc
5. **Domain expert interview = unique value** — AI can't extract institutional knowledge
6. **Knowledge compounds** — Everyday work insights should flow back into docs, not evaporate
7. **Read from auto-memory, never write** (V4) — Anthropic owns the personal layer; we promote signal up into the committed tree

---

## Development Notes

**V4 (current):**
- Reframed around Anthropic's auto-memory: Context Tree = committed/verified/team-shared layer
- New `memory-promoter` skill: scans `~/.claude/projects/<proj>/memory/` (read-only) for promotion candidates
- Refactored unified maintenance skill into 5 composable skills
- Frontmatter convention on generated docs (aligned with auto-memory shape)
- Optional `knowledge.yaml` (KCP) routing manifest for larger trees
- Marketplace.json at repo root for team sharing

**V3:**
- Added `/ingest-context` for multi-source ingestion with code verification
- Added Learning Review maintenance mode + proactive capture during normal work
- 3 commands, 1 skill, 4 workflow prompts
- Inspired by Karpathy's LLM Wiki concept

**V2 Simplification:**
- Consolidated 8 commands -> 2 commands
- Unified 3 skills -> 1 skill
- Markdown working files (no JSON artifacts)

**Philosophy:**
"The elaborate methodology taught these lessons. You don't need the methodology anymore — just the lessons. And the lessons should compound. Auto-memory captures friction; Context Tree compounds it into shared knowledge."

---

**For plugin development questions, start with the key documentation files above.**
