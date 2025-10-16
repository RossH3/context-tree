# Context Tree

AI-optimized documentation structure for brownfield codebases. Build structured context trees that help Claude Code (and developers) understand your legacy projects.

**What you'll create:** Root `CLAUDE.md` with decision trees, reference docs (GLOSSARY.md, ARCHITECTURE.md, BUSINESS_CONTEXT.md), and hierarchical subdirectory navigation - all maintained in git alongside your code.

**Best for:** Existing production codebases (50-5000+ files) with limited documentation, active development teams using AI assistants.

---

## Installation

### Basic Installation (Documentation Guides)

**Best for:** First-time users, small teams, single project

```bash
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install.sh | bash
```

**What you get:**
- ✓ CONTEXT_TREE_BUILDER.md - Interview guide and templates
- ✓ CONTEXT_TREE_PRINCIPLES.md - Underlying principles and patterns
- ✓ CONTEXT_TREE_DISCOVERY.md - Automated analysis commands
- ✓ CONTEXT_TREE_QUICK_START.md - Getting started guide
- ✓ Installed in your project root directory

**Usage:**
```bash
claude
# Then tell Claude:
# "Help me build a context tree using CONTEXT_TREE_BUILDER.md"
```

**Time investment:** 2-4 hours for initial context tree, refinement over 1-2 weeks

---

### Advanced Installation (Skills + Automation)

**Best for:** Experienced users, multiple projects, teams building many context trees

**Installation:**
```bash
cd ~/your-project
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```

**Local testing** (before pushing to GitHub):
```bash
cd ~/your-project
bash /path/to/context-tree/install-advanced.sh --local
```

**What you get:**
- ✓ **Context Tree Maintenance skill** → `.claude/skills/context-tree-maintenance/`
  - Uses official Claude Skills format (SKILL.md with YAML frontmatter)
  - Automatic discovery - Claude loads it when relevant
  - Systematic methodology for building and maintaining context trees
  - Validation checklists and quality controls
  - Integrated automated discovery commands
- ✓ **Slash commands** → `.claude/commands/`
  - `/audit-context` - Full validation workflow
  - `/discover-codebase` - Automated discovery
  - `/capture-insight` - Quick insight capture
- ✓ **Session hooks** → `.claude/hooks/`
  - Announces available skills at session start

**Usage:**
```bash
cd ~/your-project
claude
# Use slash commands:
/audit-context
/discover-codebase
/capture-insight

# Or invoke the skill directly:
"Use the Context Tree Maintenance skill"

# Claude will also automatically use the skill when relevant!
```

**Learn more:** See [skills/README.md](skills/README.md) for details on how skills work

---

## Comparison: Basic vs Advanced

| Feature | Basic | Advanced |
|---------|-------|----------|
| **Documentation guides** | ✅ Installed per-project | ✅ Skill per-project |
| **Context tree builder** | ✅ Manual workflow | ✅ Skill-guided workflow |
| **Reusable across projects** | ❌ Copy files manually | ✅ Simple curl install |
| **Slash commands** | ❌ Not available | ✅ Included |
| **Session hooks** | ❌ Not available | ✅ Included |
| **Validation checklists** | ❌ Manual | ✅ Built into skill |
| **Quality enforcement** | ❌ Self-discipline | ✅ Guardrails + commitment devices |
| **Automated discovery** | ✅ Commands in DISCOVERY.md | ✅ Integrated in skill |
| **Best for** | Single project, learning | Systematic quality, multiple projects |

**Recommendation:**
- Start with **Basic** if this is your first context tree
- Upgrade to **Advanced** when building context trees for multiple projects
- Use **Advanced** if you want systematic quality enforcement

---

## Quick Start

### With Basic Installation

1. **Install in your project:**
   ```bash
   cd ~/your-project
   curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install.sh | bash
   ```

2. **Start Claude:**
   ```bash
   claude
   ```

3. **Build your context tree:**
   ```
   Help me build a context tree using CONTEXT_TREE_BUILDER.md
   ```

4. **Follow the guided interview** - Claude will:
   - Run automated discovery
   - Ask targeted questions
   - Generate context tree files
   - Help you validate and refine

### With Advanced Installation

1. **Install in your project:**
   ```bash
   cd ~/your-project
   curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
   ```

2. **Start Claude:**
   ```bash
   claude
   ```

3. **Start building:**
   ```
   /discover-codebase
   ```
   Or:
   ```
   Use the Context Tree Maintenance skill to build a context tree
   ```

4. **Skill guides you through** systematic workflow with quality checks

---

## What You'll Create

A **context tree** with:

- **Root CLAUDE.md** - Navigation hub with decision trees
  - "What are you trying to do?" routing
  - Critical patterns and gotchas
  - Complete documentation map

- **Reference Documentation** (docs/)
  - GLOSSARY.md - UI ↔ code ↔ database terminology mappings
  - ARCHITECTURE.md - Tech stack, data patterns, design decisions
  - BUSINESS_CONTEXT.md - Workflows, entities, business rules
  - Additional docs based on your needs

- **Hierarchical Navigation** (subdirectory CLAUDE.md files)
  - app/controllers/CLAUDE.md - Controller patterns
  - app/views/CLAUDE.md - Template patterns
  - Additional as needed

- **All maintained in git** alongside your code

---

## Key Principles

**Signal over Noise:**
- Document what can't be derived from code structure
- Capture terminology mismatches (UI vs code vs database)
- Focus on gotchas, business rules, and architectural decisions
- Remove generic framework explanations

**Verify Against Code:**
- Never document architecture without checking actual code
- Cross-check claims against implementation
- Test context tree effectiveness with real tasks

**Single Source of Truth:**
- Each architectural fact has one authoritative location
- Other documents reference, never duplicate
- Prevents documentation drift

**For complete principles:** See [CONTEXT_TREE_PRINCIPLES.md](CONTEXT_TREE_PRINCIPLES.md)

---

## Documentation

- **[CONTEXT_TREE_QUICK_START.md](CONTEXT_TREE_QUICK_START.md)** - Getting started guide
- **[CONTEXT_TREE_BUILDER.md](CONTEXT_TREE_BUILDER.md)** - Interview guide and templates
- **[CONTEXT_TREE_PRINCIPLES.md](CONTEXT_TREE_PRINCIPLES.md)** - Design principles and patterns
- **[CONTEXT_TREE_DISCOVERY.md](CONTEXT_TREE_DISCOVERY.md)** - Automated analysis commands
- **[skills/README.md](skills/README.md)** - How skills work (Advanced installation)

---

## FAQ

**Q: How long does this take?**
A: 2-4 hours for initial context tree, then refinement over 1-2 weeks of real usage.

**Q: Do I need to document everything?**
A: No! Focus on signal-to-noise ratio. Document only what can't be derived from code structure.

**Q: What if I don't know the answer to something?**
A: Say so! Claude can help investigate, or mark it as "needs research."

**Q: Can I do this in multiple sessions?**
A: Yes! Commit after each session. Next session: "Continue building the context tree."

**Q: Basic or Advanced installation?**
A:
- **Basic**: First context tree, single project, learning the methodology
- **Advanced**: Multiple projects, want systematic quality enforcement, experienced with context trees

**Q: Can I upgrade from Basic to Advanced later?**
A: Yes! Just run the advanced installer. Your existing context tree files remain unchanged.
```bash
cd ~/your-project
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```

---

## Support

- **Issues**: [GitHub Issues](https://github.com/RossH3/context-tree/issues)
- **Discussions**: [GitHub Discussions](https://github.com/RossH3/context-tree/discussions)

---

## License

MIT License - See LICENSE file for details

---

## Credits

- **Concept**: Ross Hanahan
- **Inspired by**: Jesse Vincent's [Superpowers](https://github.com/obra/superpowers) skills system
- **Persuasion principles**: Robert Cialdini's research on commitment and authority

---

*Build context trees. Eliminate AI tech debt. Ship faster.*
