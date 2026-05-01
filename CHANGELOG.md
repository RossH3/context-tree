# Changelog

All notable changes to the Context Tree project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.1] - 2026-05-01

### Shakedown fixes — five real issues from first install

First real-world install of v4.0.0 was into a mature v3-era tree (~14k lines across 30 docs in a production multi-tenant application). All five skills loaded; all three skills tested (`tree-health`, `memory-promoter`, `/ingest-context`) ran cleanly and the verification discipline caught three independent contradictions in one session — the v4 thesis working. These five fixes address rough edges surfaced by actually using it.

### Fixed

- **`tree-health` is now chunking-aware.** Previously warned on oversized docs (DATA_FLOWS.md at 2407 lines, TROUBLESHOOTING.md at 1827) without recognizing they are chunked into multiple `knowledge.yaml` routing entries — chunking is the v3+ mitigation strategy and these docs are working as designed. The skill now reads `knowledge.yaml` and reports chunked docs as `✓ chunked (N units)` instead of `⚠ oversized`.

- **`/ingest-context` no longer wastes a subagent re-read on small/already-loaded sources.** New decision branch: if the source is already in context, small (<500 lines), or pre-parsed, do extraction inline using the same logic from `source-ingestion.md`. Subagent path remains for large/external sources where context-window isolation matters.

- **`memory-promoter` now classifies skip reasons.** Previously lumped all skips as "skipped (correctly typed as memory)." Now distinguishes: `personal-preference`, `meta-feedback` (commentary on past Claude sessions), `local-machine-context`, `index-pointer`, `already-productized`, `user-declined`, `already-documented`. Watch the `meta-feedback` count over time — high counts mean auto-memory is accumulating self-reflection cruft and probably needs human pruning.

- **`memory-promoter` mapping now considers hot-load cost.** Root `CLAUDE.md` is eager-loaded into every session — anything filed there pays its token cost forever. The skill now explicitly biases toward lazy-loaded `docs/*.md` for historical/lineage/contextual facts, reserving root `CLAUDE.md` for facts that shape nearly every change (e.g., security-critical patterns, build commands). New guidance table in `memory-promoter/SKILL.md` covers the trade-offs.

- **README install instructions** now warn about the `/plugin list` cache miss after install (first invocation can return empty; second works) and clarify the `/reload-plugins` step after `/plugin update`.

### Why these matter

The shakedown caught:

- A **stale auto-memory entry** (a database transport limit memory said "removed"; docker config showed it had been raised to a high value, not removed)
- A **stale source description** in an investigation doc (the rendering flow it described had been reversed since the doc was written)
- A **never-applied recommendation** in the same investigation doc (promoting it as a tree-level principle would have actively misdirected future agents)

All three were caught by code verification *before* anything landed in the tree. Net result: 14 candidates evaluated across two skill runs, 1 small promotion landed, 0 false signals leaked through. That's the right shape for a mature tree, and v4.0.1 sharpens the tooling to keep that ratio.

---

## [4.0.0] - 2026-05-01

### The post-auto-memory rewrite

Anthropic shipped auto-memory in Claude Code. We're not going to compete with it. We're going to be the layer that auto-memory structurally cannot be.

**The frame.** Auto-memory is a personal, machine-local, unverified scratchpad — Claude observes corrections during your sessions and writes typed notes to `~/.claude/projects/<proj>/memory/`. It is excellent at what it does. **Context Tree is the committed, verified, team-shared knowledge layer for the codebase.** Auto-memory captures what Claude learned about *you*. Context Tree captures what is true about *the repo*. They are complementary, and the boundary is now load-bearing.

**The new marquee skill: `memory-promoter`.** Reads your auto-memory directory. Identifies entries whose content describes the codebase (not the user). Verifies each candidate against actual code. Offers to promote them into the committed Context Tree with the same discipline as `/ingest-context`. Read-only of memory — Anthropic owns that surface; we promote signal up. The Rule of Two now has a dedicated bridge: auto-memory captures friction; Context Tree compounds it into shared knowledge.

**The architecture shift: composable skills, not modes.** The unified `context-tree-maintenance` skill (5 modes bundled) is gone. In its place: five focused skills, each one job, each invocable on its own or by `/maintain-context-tree`:

- `rule-of-two-detector` — git-history pattern analysis (was Mode 1)
- `drift-detector` — doc-vs-code validation (was Mode 2)
- `tree-health` — structural checks (was Mode 3)
- `learning-capture` — recent learnings + proactive in-flow nudge (was Mode 4 + the gentle-nudge mechanic)
- `memory-promoter` — auto-memory → committed tree (NEW)

The `/maintain-context-tree` command is now a thin orchestrator that routes to skills. Skills can also activate during normal work — proactive capture finally lives where it belongs.

**Frontmatter on generated docs.** Aligned with auto-memory's typed shape. Every generated doc (CLAUDE.md and each conditional doc in `docs/`) now starts with:

```yaml
---
name: <doc name>
description: <one-line purpose>
type: reference
scope: repo
source: build|interview|ingest|promoted-from-memory|manual
verified: YYYY-MM-DD
---
```

Borrowed from Anthropic's auto-memory format (familiar shape, easy to read). `scope: repo` is our addition — distinguishes Context Tree's repo-scope from auto-memory's user-scope. `source` provides provenance: critical for `memory-promoter` and `/ingest-context`. `drift-detector` refreshes `verified:` after audits.

**Knowledge.yaml folded back in.** The KCP-style routing manifest, evolved through real production use on a large multi-tenant codebase, is now a (conditional) Phase 3 output. Triggered when the tree has ≥4 docs. Conceptual cousin to Anthropic's `MEMORY.md` index — both are routing layers — but `knowledge.yaml` is richer because Context Tree docs are bigger and need triggers and decision trees.

**Marketplace-ready.** `.claude-plugin/marketplace.json` at repo root, updated to v4.0.0. Teams can add this repo as a Claude Code marketplace and pick up the plugin from it, no surgery required.

### Added

- `RELATIONSHIP_TO_MEMORY.md` at repo root — the definitive frame for how Context Tree relates to Anthropic auto-memory, including promotion mapping table and decision flow
- `memory-promoter` skill — scan auto-memory, verify, promote with user approval
- `rule-of-two-detector`, `drift-detector`, `tree-health`, `learning-capture` — focused skills extracted from the unified maintenance skill
- Frontmatter convention on all generated docs (`name`, `description`, `type`, `scope`, `source`, `verified`)
- `knowledge.yaml` (KCP v0.9) generation in Phase 3 (conditional, ≥4 docs)
- Promotion log at `docs/context-tree-build/promotion-log.md`
- Promotion-skips list at `docs/context-tree-build/promotion-skips.md` (so memory-promoter doesn't re-suggest dismissed entries)

### Changed

- `/maintain-context-tree` is now a thin orchestrator. The 5 menu options route to the 5 skills (option 6 = run all)
- `/ingest-context` is now frontmatter-aware: refreshes `verified:` date when adding to v4 docs
- Plugin metadata: version 4.0.0, description rewritten, new keywords (`memory-promotion`, `claude-code-memory`)
- Marketplace manifest: v4.0.0 with refreshed description and category metadata
- Root `CLAUDE.md` and `README.md`: reframed around the post-auto-memory worldview

### Removed

- `skills/context-tree-maintenance/` — replaced by 5 focused skills. The unified skill's logic survives, redistributed across the new skills.

### Migration from v3

If you have a v3 Context Tree in a repo:

1. **No file migration required** — existing `CLAUDE.md` and `docs/*.md` work as-is
2. **Add frontmatter when you next touch a doc** — manual step, not automated. `drift-detector` will start tracking `verified:` dates once frontmatter exists
3. **Generate `knowledge.yaml` if you want routing** — re-run Phase 3 generator (it can output just the manifest now), or hand-author following the format in `doc-generator.md` Step 6.5
4. **Run `memory-promoter` on first use** — surfaces what your auto-memory has accumulated since v2.1.59

### Why v4 is a major bump

V3 was an additive release — `/ingest-context` and Learning Review on top of v2's foundation. V4 is a worldview change. The shape of the plugin (composable skills, frontmatter alignment, memory-promoter as a first-class capability) is structured around a different question: *not "how do we document a codebase," but "given Anthropic now ships auto-memory, where does the committed/verified/team-shared layer fit?"* The answer: right here. Verified, code-anchored, team-shared, with a bridge that promotes auto-memory's signal up.

### Design influences

- Anthropic's auto-memory format (typed frontmatter, MEMORY.md as index, on-demand topic loading)
- KCP v0.9 routing manifest (evolved through real production use, now folded back into the plugin)
- Karpathy's LLM Wiki concept (still relevant; Context Tree's verification discipline remains the differentiator)

---

## [3.0.0] - 2026-04-07

### Added - Multi-Source Ingestion

- **`/ingest-context` command:** Process external sources (files, pasted text) and integrate verified insights into existing Context Tree docs
- **Source ingestion workflow prompt:** `docs/workflow-prompts/source-ingestion.md` -- subagent prompt for extracting insights from post-mortems, Slack exports, meeting notes, HAR files, wiki pages
- **Ingest pipeline:** 6-step process (acquire -> extract -> verify against code -> deduplicate -> user review -> log)
- **Ingest log:** Append-only audit trail at `docs/context-tree-build/ingest-log.md` tracking what was ingested, accepted, and rejected
- **Stricter quality gates for external sources:** Code verification required, contradicted claims rejected, unverifiable claims require attribution
- **Verification protocol by claim type:** Different verification standards for code behavior, architecture patterns, terminology mappings, business rules, historical context, and operational knowledge

### Added - Query-as-Documentation (Learning Capture)

- **Learning Review maintenance mode (option 4):** Systematic review of recent git commits (last 2 weeks) to harvest undocumented learnings -- debugging breakthroughs, architectural discoveries, new patterns
- **Proactive Capture (gentle nudge):** During normal work, the maintenance skill now offers to capture non-obvious synthesis when: answer required 3+ files, user expressed surprise, AI corrected its own assumption, or debugging revealed non-obvious behavior
- **Two complementary mechanisms:** Proactive capture catches insights in real time during work; Learning Review catches what was missed by reviewing git history

### Changed

- **Maintenance menu:** Now 5 options (was 4) -- Learning Review added as option 4, All shifted to option 5
- **Full maintenance run:** Now includes Learning Review as step 4/4
- **Plugin manifest:** Version bumped to 3.0.0, description updated, new keywords added

### Architecture

- **2 new files:** `commands/ingest-context.md`, `docs/workflow-prompts/source-ingestion.md`
- **3 modified files:** `plugin.json`, `commands/maintain-context-tree.md`, `skills/context-tree-maintenance/SKILL.md`
- **5 untouched files:** Build command, all 3 existing workflow prompts, git-learning-detector.sh
- **Zero new artifact formats:** All new features use markdown, same as V2

### Design Influences

- Inspired by Karpathy's LLM Wiki concept (April 2026): persistent knowledge compounding, ingest-and-integrate pattern
- Context Tree's differentiator: verification against code (not docs), quality gates, domain expert interview -- addressing the top community criticism of LLM wikis (error accumulation, no validation mechanism)

---

## [2.0.0] - 2026-03-28

### Changed - V2 Simplification

- Consolidated 8 commands to 2 (`/build-context-tree`, `/maintain-context-tree`)
- Unified 3 skills to 1 (`context-tree-maintenance`)
- Markdown working files replace JSON artifacts
- Natural interaction for ongoing maintenance

---

## [1.0.0] - 2025-12-14

### Added - Claude Code Plugin Distribution

- **Plugin system support**: Converted to Claude Code plugin format for easy installation via `/plugin install`
- Plugin manifest (`.claude-plugin/plugin.json`) with full metadata
- GitHub-based distribution (no Anthropic Marketplace dependency)
- Automatic skill discovery from `skills/` directory
- Organized plugin structure: root-level `commands/`, `skills/`, `orchestrators/`, `hooks/`

### Added - Friction Analysis Feature (Phase 3 Complete)

- **Friction logging**: `/log-friction` command for <2 min capture of where Claude struggles
- **Pattern analysis**: `/analyze-friction` command with git-aware correlation
- **Priority scoring**: Algorithm using (Frequency × Severity × Recency) + (Churn × 0.5)
- **Draft documentation generation**: Specific 2-5 line docs verified against actual code
- **Haiku/Sonnet handoff**: Token-efficient workflow (30-40% savings)
- **Interactive discussion**: Drill-down options, code verification, routing to maintenance
- New skill: `friction-analysis` with dual modes (logging + analysis)
- Test data: 5 sample entries demonstrating full workflow

### Added - Git Learning Signals Feature

- **Learning loop detection**: Analyzes git history for Rule of Two violations
- **Actionable recommendations**: Identifies what to document based on team behavior
- New skill: `git-learning-signals` for automated pattern detection
- Shell utility: `git-learning-detector.sh` for standalone usage

### Added - Core Context Tree Features

- **Orchestrated workflow**: 3-phase build process (discovery → interview → generation)
  - Phase 1: Codebase Discovery (15-20 min automated exploration)
  - Phase 2: Domain Expert Interview (30-60 min, THE KEY VALUE)
  - Phase 3: Doc Generation with quality gates (30-45 min)
- **Context Tree Maintenance**: Ongoing curation and quality control skill
- **Quality gates**: Only generates docs with ≥3 substantial insights
- **Signal-to-noise focus**: Every line must justify its token cost
- **Verification discipline**: Always verify architectural claims against actual code

### Commands

- `/build-context-tree` - Orchestrated 3-phase workflow
- `/analyze-friction` - Git-aware friction pattern analysis
- `/log-friction` - Quick friction capture (<2 min)
- `/capture-insight` - Real-time insight logging during development
- `/audit-context` - Audit documentation quality and coverage

### Skills

- `context-tree-maintenance` - Ongoing curation and quality control
- `friction-analysis` - Systematic friction capture and priority analysis
- `git-learning-signals` - Team behavior pattern detection

### Documentation

- `CLAUDE.md` - Complete navigation hub for Context Tree methodology
- `AI_DOCUMENTATION_FIELD_GUIDE.md` - Practical lessons from 6 months of production use
- `CONTEXT_TREE_PRINCIPLES.md` - Deep theory on signal-to-noise and verification
- `ORCHESTRATION_CONVERSION_GUIDE.md` - Evolution story and design decisions
- `README.md` - Installation and feature overview

### Distribution

- Plugin installation via: `/plugin marketplace add RossH3/context-tree`
- Legacy shell script: `install-advanced.sh` for backward compatibility
- GitHub-based updates: Simple git tag versioning
- Version tracking: Added `version` field to plugin manifest

### Technical

- Organized repository structure for plugin compatibility
- Moved `orchestrators/` from `.claude/` to root level
- Skills auto-discovered from `skills/` directory
- Commands listed in plugin.json manifest
- Git history preservation during restructuring

---

## Version History Summary

**[1.0.0]** - Initial plugin release with full feature set (friction-analysis, git-learning-signals, context-tree-maintenance)

---

## Future Planned Features

(Not in v1.0.0 - potential future iterations)

- Friction type taxonomy refinement based on real usage
- Cross-project pattern aggregation
- Integration with additional git signals (blame, PR comments, complexity metrics)
- Enhanced automation for Context Tree updates
- Dashboard for friction trends over time

---

## Migration Guide

### From Shell Script to Plugin

**Old installation:**
```bash
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```

**New installation:**
```bash
/plugin marketplace add RossH3/context-tree
/plugin install context-tree@RossH3/context-tree
```

**Benefits:**
- Automatic updates via `/plugin update`
- Version management built-in
- No shell script execution needed
- Cross-platform compatibility
- User/project scope configuration

**Backward compatibility**: Shell script installation still works for projects not yet using Claude Code plugins.

---

## [Unreleased]

### Documentation Improvements

**Clarified dual architecture (Physical Tree + Semantic Knowledge Graph):**
- Added "Architecture" sections to all core documentation explaining the dual nature
- Physical structure: Hierarchical CLAUDE.md files matching source tree (predictable navigation)
- Semantic relationships: Cross-references and knowledge graph (conceptual richness)
- Explains why it's called "Context Tree" when relationships form a graph

**Established Claude Code-first positioning:**
- Explicit statements across all docs that this is built specifically for Claude Code
- Clear differentiation: Not generic, not tool-agnostic, not portable
- Emphasizes leveraging Claude Code's layered context loading
- Repository-specific methodology for brownfield codebases

**Clarified primary audience:**
- Added "Primary Audience" statements to README, CLAUDE.md, and AI_DOCUMENTATION_FIELD_GUIDE.md
- Documentation is written FOR Claude Code (the AI) to consume
- Senior developers can read it, but Claude is the primary reader
- Everything optimized for token efficiency and Claude's comprehension

**Rewrote Success Metrics:**
- Primary goal: Claude Code works better (debugging, refactoring, features, reasoning)
- Secondary goal: Efficiency (only if quality maintained)
- Explicit bar: Results must justify token cost
- Subjective human evaluation, no automated metrics

**Strategic framing added to AI Documentation Field Guide:**
- Added "What This Guide Is About" section explaining methodology foundations
- Connects physical structure to logical relationships
- Sets context before practical implementation details

**Repository cleanup:**
- Removed `elements-of-style.md` (71KB reference doc not needed)
- Removed `ORCHESTRATION_CONVERSION_GUIDE.md` (evolution context preserved elsewhere)
- Removed redundant `hooks/` directory (duplicated `.claude/hooks/`)
- Removed untracked working files

**Impact:** All core documentation now consistently articulates Context Tree's architecture, positioning, audience, and success criteria. Token-efficient additions (~150 lines total) with high signal-to-noise ratio.

---

**[1.0.0 and earlier]** - See above for release history
