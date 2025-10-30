# Context Tree Builder

**AI onboarding tool for brownfield codebases with domain expert interview**

This tool helps AI assistants (Claude, GitHub Copilot, etc.) understand legacy codebases by combining automated discovery with structured interviews of domain experts. The result is high-signal documentation that captures institutional knowledge AI can't infer from code alone.

---

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

From your project directory, run:

```bash
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```

This installs:
- 3-phase orchestrated workflow → `.claude/orchestrators/context-tree-builder/`
- Maintenance tools → `.claude/skills/context-tree-maintenance/`
- Slash commands → `.claude/commands/`
- Session hooks → `.claude/hooks/`

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
- Output: `docs/context-tree-build/discovery_summary.json`

**Phase 2: Domain Expert Interview (30-60 min) ⭐ THE KEY DIFFERENTIATOR**
- Interactive Q&A with someone who knows the codebase
- One question at a time, adaptive based on answers
- Verifies answers against actual code immediately
- Captures institutional knowledge that code can't show
- Resumable across multiple sessions
- Output: `docs/context-tree-build/interview_notes.json`

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

**Orchestrated Workflow (Use This):**
- `.claude/commands/build-context-tree.md` - Main orchestrator command
- `.claude/orchestrators/context-tree-builder/codebase-discovery.md` - Phase 1 subagent
- `.claude/orchestrators/context-tree-builder/domain-interview.md` - Phase 2 subagent
- `.claude/orchestrators/context-tree-builder/doc-generator.md` - Phase 3 subagent

**Reference Documentation:**
- `AI_DOCUMENTATION_FIELD_GUIDE.md` - Practical lessons and examples ⭐ START HERE
- `CONTEXT_TREE_PRINCIPLES.md` - Deep dive on signal-to-noise, verification discipline
- `ORCHESTRATION_CONVERSION_GUIDE.md` - How this orchestrated workflow was designed
- `elements-of-style.md` - Classic writing guide (reference)

**Historical (Preserved for Learning):**
- `skills/context-tree-maintenance/` - Ongoing maintenance workflow
- `CONTEXT_TREE_BUILDER.md` - Original monolithic approach (deprecated)
- `CONTEXT_TREE_DISCOVERY.md` - Original discovery commands (deprecated)
- `CONTEXT_TREE_QUICK_START.md` - Legacy quick start (deprecated)

---

## Maintenance After Initial Build

After generating docs with `/build-context-tree`:

**Incremental updates (recommended):**
Follow the [Rule of Two](AI_DOCUMENTATION_FIELD_GUIDE.md#when-to-document):
- First time AI makes mistake: Just correct it
- Second time: Add 2-3 lines to CLAUDE.md
- Prevents third time

**Structured maintenance (optional):**
Use the `context-tree-maintenance` skill for:
- Capturing insights during development
- Auditing docs for signal-to-noise
- Pruning outdated content
- Validating architectural claims

See `skills/context-tree-maintenance/SKILL.md`

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
