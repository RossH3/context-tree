# Context Tree Builder

**The committed, verified, team-shared knowledge layer for a brownfield codebase**

## What Context Tree Is

Context Tree is documentation-as-code for AI assistants working in brownfield repositories. It's a hierarchy of CLAUDE.md files that mirrors your source tree, plus a small set of conditionally-generated reference docs (GLOSSARY, ARCHITECTURE, BUSINESS_CONTEXT). Every claim is verified against actual code. Everything is committed to git, reviewed in PRs, and shared with the team.

- **Primary audience:** Claude Code (the AI). Senior developers can read it; Claude is the primary reader.
- **Scope:** The repo. Committed, team-shared, version-controlled.
- **Discipline:** Verified against code, not docs. Bad context is worse than bad code.
- **Origin:** Domain expert interviews + code verification + Rule-of-Two capture during everyday work.

## Relationship to Claude Code's Memory

Claude Code's **auto-memory** writes typed notes to `~/.claude/projects/<proj>/memory/` as you work. Anthropic also ships **dreaming**, an offline pass that reorganizes a memory store, checks it against session transcripts, and surfaces patterns across sessions ([Components of agent memory](https://www.anthropic.com/research/components-of-agent-memory)). As of 2026-11-06, dreaming runs only in the Managed Agents API ([research preview](https://platform.claude.com/docs/en/managed-agents/dreams)); Claude Code documents no background consolidation. Curating personal memory is Anthropic's work either way, so Context Tree stays out of it.

**Context Tree is the committed, code-verified, team-shared layer.** They are complementary:

| | Anthropic memory | Context Tree |
|---|---|---|
| Author | Claude, in session (dreaming: offline job) | Human + Claude, approval per change |
| Verified against | Session transcripts (dreaming) | The code |
| Scope | Your machine, per project | Repo (committed, team-shared) |
| Content | What Claude learned working with *you* | What's true about *this codebase* |
| Lives in | `~/.claude/projects/<proj>/memory/` | `CLAUDE.md` + `docs/` in your repo |

Context Tree treats auto-memory as a **read-only signal source** and never writes to it. The `memory-promoter` skill (v4.0.0+) scans your local memory directory for rules and traps that belong in the committed tree, verifies them against code, and offers to promote them.

See [RELATIONSHIP_TO_MEMORY.md](RELATIONSHIP_TO_MEMORY.md) for the full mapping, decision flow, and skill status.

### What Context Tree Is Not

- ❌ A replacement for auto-memory or dreaming (Anthropic's memory is good at what it does)
- ❌ A memory curator (that's Anthropic's work; Context Tree never writes to memory)
- ❌ Generic AI documentation methodology
- ❌ Tool-agnostic
- ❌ Greenfield project guidance

**We focus all energy on making Claude Code work better with YOUR brownfield codebase.**

---

This tool helps AI assistants understand legacy codebases by combining automated discovery with structured interviews of domain experts. The result is high-signal documentation that captures institutional knowledge AI can't infer from code alone.

## The Problem

AI assistants can explore code structure, but they can't know:
- Why architectural decisions were made
- What business terms mean (and how UI → code → DB terms map)
- What mistakes developers repeatedly make
- What takes longest to explain to new team members
- Institutional knowledge that exists only in people's heads

**Solution:** Automated discovery + domain expert interview + quality-gated documentation

---

## Quick Start

### Prerequisites
- Claude Code (or compatible AI assistant with slash command support)
- Access to someone who knows the codebase intimately (for interview phase)
- Brownfield codebase you want to document

### Installation

#### Claude Code Plugin

Install via Claude Code's plugin marketplace:

```bash
# In Claude Code
/plugin marketplace add RossH3/context-tree
/plugin install context-tree
/plugin list   # Verify install (see note below)
```

**Note on `/plugin list`:** Right after install, the first `/plugin list` may return empty output (Claude Code caching quirk, not plugin-specific). Run it a second time and the plugin appears. If you see "Run /reload-plugins to apply" after install, do that first.

**Update plugin:**
```bash
/plugin update context-tree
/reload-plugins   # Apply the update
```

**V4 Features:**
- **3 commands:** `/build-context-tree`, `/maintain-context-tree`, `/ingest-context`
- **4 composable skills:** `learning-capture`, `drift-detector`, `tree-health`, `memory-promoter`
- **Memory promotion:** Read auto-memory entries, verify against code, promote to committed tree (NEW in v4)
- **Multi-source ingestion:** Process post-mortems, Slack exports, meeting notes into verified docs
- **Frontmatter convention:** Generated docs carry typed frontmatter (aligned with auto-memory shape)
- **Knowledge.yaml routing:** Optional KCP-style manifest for trees with enough docs to need routing
- **Markdown working files** (no JSON artifacts)

This installs:
- Commands: Build workflow + maintenance orchestrator + multi-source ingestion
- Skills: Each maintenance mode is now its own skill, plus the new memory-promoter
- Workflow prompts: 3-phase build prompts + source ingestion prompt (markdown-based)

### Usage

Start Claude Code and run:
```bash
/build-context-tree
```

---

## How It Works

### Three-Phase Orchestrated Workflow

**Phase 1: Codebase Discovery (15-20 min)**
- Automated exploration of codebase using AI
- Identifies tech stack, architecture patterns, terminology traps
- Finds confusing areas to ask about in interview
- Output: `docs/context-tree-build/discovery.md` (human-readable markdown)

**Phase 2: Domain Expert Interview (30-60 min) ⭐ THE KEY DIFFERENTIATOR**
- Interactive Q&A with someone who knows the codebase
- One question at a time, adaptive based on answers
- Verifies answers against actual code immediately
- Captures institutional knowledge that code can't show
- Resumable across multiple sessions via summary section
- Output: `docs/context-tree-build/interview.md` (append-only markdown)

**Phase 3: Documentation Generation (30-45 min)**
- Generates docs from discovery + interview insights
- **Quality gates:** Only generates docs with ≥3 substantial insights
- **No generic slop:** If we don't have good content, we don't generate the doc
- Output: CLAUDE.md (always) + optional GLOSSARY.md, ARCHITECTURE.md, BUSINESS_CONTEXT.md

---

## What You Get

### Always Generated

**`CLAUDE.md`** - Navigation hub (~200 lines)
- Critical concepts (top 5 confusion points)
- Decision trees ("What are you trying to do?")
- Common pitfalls to avoid
- Quick reference for terminology and architecture

### Conditionally Generated (quality-gated)

**`docs/GLOSSARY.md`** - Only if ≥3 verified terminology mappings
- UI term → Code term → DB term mappings
- Why naming differences exist
- Search cheat sheet ("Looking for X? Grep for Y")

**`docs/ARCHITECTURE.md`** - Only if ≥3 non-obvious patterns
- Critical architectural patterns (multi-tenancy, dual databases, etc.)
- Why patterns exist (historical context, constraints)
- What breaks if violated
- Security-critical rules

**`docs/BUSINESS_CONTEXT.md`** - Only if ≥3 business insights
- What the system does and why
- Primary user workflows
- Business rules and domain concepts
- User roles and permissions

---

## Key Features

### Resumable Workflow
Each phase creates checkpoint files. If interrupted:
- Phase 1: Can skip or re-run if `discovery_summary.json` exists
- Phase 2: Continues from where you left off if `interview_notes.json` exists
- Phase 3: Can skip or regenerate if final docs exist

**Perfect for multi-session builds across days or weeks.**

### Quality Gates Prevent Generic Slop
Phase 3 only generates docs that have ≥3 substantial, verified insights.

**Better to have no GLOSSARY.md than one filled with obvious mappings.**

### Verification Built-In
- Phase 1: Checks actual code, not docs
- Phase 2: Verifies interview answers against code immediately
- Phase 3: Cross-checks all claims before writing docs

**Every architectural claim has file:line references.**

### Interactive Interview (The Unique Value)
Phase 2 asks domain experts focused questions one at a time:
- Adaptive: Follow-up questions based on answers
- Verified: Checks answers against code before accepting
- Resumable: Save progress after each Q&A
- Focused: Categories ensure comprehensive coverage

**This captures knowledge that would otherwise be lost.**

---

## Example Output

See [AI_DOCUMENTATION_FIELD_GUIDE.md](AI_DOCUMENTATION_FIELD_GUIDE.md) Part 5 for a real example from a production multi-tenant SaaS application.

**Notice:**
- Critical concepts up front (terminology traps, architecture gotchas)
- Decision trees for common tasks
- Minimal explanation, maximum navigation
- Under 200 lines total

---

## Usage Patterns

### For New Projects
1. Run `/build-context-tree` during onboarding
2. Complete all 3 phases in 1-2 sessions (90-120 minutes total)
3. Use docs during first week to validate effectiveness
4. Add incremental insights as needed

### For Existing Projects
1. Run Phase 1 & 2 to capture current state
2. Phase 3 generates baseline docs
3. Use [incremental capture pattern](AI_DOCUMENTATION_FIELD_GUIDE.md#part-2-incremental-capture-system) going forward
4. Update docs when you hit friction twice

### For Team Onboarding
1. Experienced developer runs interview (Phase 2 interviewee)
2. New developer reads generated docs
3. Track what's missing during first week
4. Update docs to fill gaps

---

## When NOT to Use This

**Don't use context-tree-builder if:**
- Codebase is small (< 1000 lines) - just read it
- Code is well-documented already - no need
- No domain expert available - Phase 2 is the key value
- Greenfield project - use conventional documentation

**Use this for:**
- Brownfield legacy codebases (5K+ lines)
- Complex domain logic not obvious from code
- Multi-tenant, multi-database, or unusual architectures
- Projects with terminology traps (UI ≠ code ≠ DB terms)
- When onboarding new developers repeatedly

---

## Core Principles

From 6 months of real-world usage:

1. **Verify against code, not docs** - Documentation lies, code doesn't
2. **Signal-to-noise ratio** - Every line must justify token cost
3. **No generic slop** - Only document what AI can't easily infer
4. **Quality over quantity** - Better no doc than bad doc
5. **Resumable** - Can stop and continue at checkpoint boundaries
6. **Focus on institutional knowledge** - The domain expert interview is the unique value

See [AI_DOCUMENTATION_FIELD_GUIDE.md](AI_DOCUMENTATION_FIELD_GUIDE.md) for deeper exploration.

---

## Files in This Repository

**Plugin (what gets installed):**
- `plugins/context-tree/commands/` — 3 commands: `build-context-tree`, `maintain-context-tree`, `ingest-context`
- `plugins/context-tree/skills/` — 4 skills: `learning-capture`, `drift-detector`, `tree-health`, `memory-promoter`
- `plugins/context-tree/docs/workflow-prompts/` — 4 subagent prompts (codebase-discovery, domain-interview, doc-generator, source-ingestion)

**Marketplace manifest (for sharing):**
- `.claude-plugin/marketplace.json` — Repo-level manifest so teams can add this repo as a Claude Code marketplace

**Reference Documentation:**
- `RELATIONSHIP_TO_MEMORY.md` — How Context Tree relates to Anthropic auto-memory and dreaming ⭐ START HERE
- `AI_DOCUMENTATION_FIELD_GUIDE.md` — Practical lessons and examples
- `CONTEXT_TREE_PRINCIPLES.md` — Deep dive on signal-to-noise, verification discipline
- `CHANGELOG.md` — Version history (v4 manifesto entry at top)

**Historical (Preserved for Learning):**
- `historical/` — Approaches that didn't scale, kept for context

---

## After Initial Build

After generating docs with `/build-context-tree`, three tools keep your Context Tree alive:

### Ingest External Sources

```bash
/ingest-context
```

Process post-mortems, Slack exports, meeting notes, or any document. Each insight is verified against code before being added. Contradicted claims are rejected. Nothing gets in without your approval.

### Structured Maintenance

```bash
/maintain-context-tree
```

**Five options:**
1. **Learning Review** - Read git history for recent learnings and repeated friction (Rule of Two)
2. **Drift Detector** - Validate claims against code; scoped to docs whose code changed since last check
3. **Health Check** - Quick validation of links, structure, file sizes
4. **Memory Promoter** - Verify auto-memory entries against code, promote stable ones to the tree
5. **All** - Run options 1-4 in sequence (monthly maintenance)

### Session Insights

Context Tree no longer offers to file insights mid-session; the Proactive Capture nudge was retired in v4.1.0. Auto-memory already captures session insights. Run `memory-promoter` (option 4 of `/maintain-context-tree`) to verify the stable ones against code and promote them into the tree.

One exception: if work shows a Context Tree doc is wrong, Claude flags it and offers a fix, since auto-memory never touches committed docs.

### Natural Capture

**Just talk to Claude naturally:**
```
You: "I just figured out webhooks use HMAC auth, not bearer tokens. Let's document this."

Claude: [Verifies code, suggests CLAUDE.md section, shows draft, applies if approved]
```

No special command needed - Rule of Two principles guide natural interaction.

### Rule of Two
- **First time:** Just correct the mistake
- **Second time:** Document it (2-3 lines in CLAUDE.md)
- **Third time:** Prevented

See [AI_DOCUMENTATION_FIELD_GUIDE.md](AI_DOCUMENTATION_FIELD_GUIDE.md) for deeper exploration

---

## Utilities

The `git-learning-detector.sh` regex script was retired in v4.2.0. On a real repo it mostly matched committed tool output and diagrams instead of warnings people wrote. `learning-capture` now reads git history with model judgment, using the same signals. The script and the finding are kept in [`historical/RULE_OF_TWO_DETECTOR.md`](historical/RULE_OF_TWO_DETECTOR.md).

---

## Contributing

This tool emerged from 6 months of experimentation on production codebases. The methodology evolved from comprehensive upfront documentation to this leaner orchestrated approach.

**Feedback welcome:**
- What worked for your codebase?
- What didn't work?
- What quality gates would you change?

Open an issue or PR.

---

## License

MIT License - See LICENSE file

---

## Credits

**Lessons learned from:** 6 months of production usage on multi-tenant SaaS applications

**Author:** Ross Hanahan

---

**Start here:** Read [AI_DOCUMENTATION_FIELD_GUIDE.md](AI_DOCUMENTATION_FIELD_GUIDE.md), then run `/build-context-tree`
