# Context Tree

AI-optimized documentation structure for brownfield codebases. Build structured context trees that help Claude Code (and developers) understand your legacy projects.

## Quick Start

**1. Install** (from your project root):
```bash
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install.sh | bash
```

**2. Build your context tree:**
```bash
claude
# Then tell Claude:
# "Help me build a context tree using CONTEXT_TREE_BUILDER.md"
```

**3. Read** [CONTEXT_TREE_QUICK_START.md](CONTEXT_TREE_QUICK_START.md) for detailed guidance.

---

**What you'll create:** Root `CLAUDE.md` with decision trees, reference docs (GLOSSARY.md, ARCHITECTURE.md, BUSINESS_CONTEXT.md), and hierarchical subdirectory navigation - all maintained in git alongside your code.

**Best for:** Existing production codebases (50-5000+ files) with limited documentation, active development teams using AI assistants.
