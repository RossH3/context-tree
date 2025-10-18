# Context Tree

You build a hierarchy of `CLAUDE.md` files for your codebase. Claude Code uses these files to understand your architecture, terminology, and business rules. You work with Claude Code to build them; no script auto-generates them. Expect to invest 2-4 hours initially, plus refinement over 1-2 weeks.

**Best for:** Production codebases (50-5000+ files) with limited documentation, teams using AI assistants.

---

## What This Is NOT

- **Not auto-generated.** You and Claude Code build these files together through interview and validation. No script generates documentation from your code.
- **Not automatic.** Plan to spend 2-4 hours on initial build, plus ongoing maintenance.
- **Not for new projects.** Use this on brownfield codebases where AI assistants lack context.

---

## What You Build

- **Root CLAUDE.md** - Navigation hub with decision trees ("What are you trying to do?"), critical patterns, gotchas
- **Reference docs** (docs/)
  - GLOSSARY.md - UI ↔ code ↔ database terminology mappings
  - ARCHITECTURE.md - Tech stack, data patterns, design decisions
  - BUSINESS_CONTEXT.md - Workflows, entities, business rules
- **Subdirectory CLAUDE.md files** - Scoped context (app/controllers/CLAUDE.md, app/views/CLAUDE.md)
- **All in git** - Maintained alongside your code

---

## Installation

### Basic (Guides Only)

Best for: First-time users, single project

```bash
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install.sh | bash
```

Downloads four guide files to project root:
- CONTEXT_TREE_BUILDER.md
- CONTEXT_TREE_PRINCIPLES.md
- CONTEXT_TREE_DISCOVERY.md
- CONTEXT_TREE_QUICK_START.md

**Usage:**
```bash
claude
# Tell Claude: "Help me build a context tree using CONTEXT_TREE_BUILDER.md"
```

### Advanced (Skills + Commands)

Best for: Multiple projects, systematic quality enforcement

```bash
cd ~/your-project
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```

Installs to `.claude/`:
- Context Tree Builder skill (initial build workflow)
- Context Tree Maintenance skill (ongoing curation)
- Slash commands (`/build-context-tree`, `/audit-context`, `/discover-codebase`, `/capture-insight`)
- Session hooks

**Usage:**
```bash
cd ~/your-project
claude
/build-context-tree
# Or: "Use the Context Tree Builder skill"
# After initial build, use Maintenance skill for ongoing work
```

### Upgrade Path

Start with Basic. Upgrade anytime:
```bash
cd ~/your-project
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```
Your context tree files remain unchanged.

---

## Comparison

| Feature | Basic | Advanced |
|---------|-------|----------|
| **Guides** | ✅ | ✅ |
| **Builder workflow** | Manual | Skill-guided (5 phases) |
| **Maintenance workflow** | Manual | Skill-guided (monthly audit) |
| **Reusable across projects** | Copy files | Simple curl install |
| **Slash commands** | ❌ | ✅ (4 commands) |
| **Validation checklists** | Manual | Built-in (both skills) |
| **Quality enforcement** | Self-discipline | Guardrails & commitment devices |

---

## Key Principles

**Signal over Noise:**
- Document what code structure cannot reveal
- Capture terminology mismatches (UI vs code vs database)
- Focus on gotchas, business rules, architectural decisions
- Remove generic framework explanations

**Verify Against Code:**
- Check architectural claims against actual implementation
- Never document from other documentation
- Test effectiveness with real tasks

**Single Source of Truth:**
- Each architectural fact has one authoritative location
- Other documents reference, never duplicate

See [CONTEXT_TREE_PRINCIPLES.md](CONTEXT_TREE_PRINCIPLES.md) for complete principles.

---

## Documentation

- [CONTEXT_TREE_QUICK_START.md](CONTEXT_TREE_QUICK_START.md) - Getting started
- [CONTEXT_TREE_BUILDER.md](CONTEXT_TREE_BUILDER.md) - Interview guide and templates
- [CONTEXT_TREE_PRINCIPLES.md](CONTEXT_TREE_PRINCIPLES.md) - Design principles
- [CONTEXT_TREE_DISCOVERY.md](CONTEXT_TREE_DISCOVERY.md) - Automated analysis commands
- [skills/README.md](skills/README.md) - How skills work (Advanced)

---

## FAQ

**How long does this take?**
2-4 hours for initial context tree, then refinement over 1-2 weeks of real usage.

**Do I document everything?**
No. Focus on signal-to-noise ratio. Document only what code structure cannot reveal.

**Can I do this in multiple sessions?**
Yes. Commit after each session. Next session: "Continue building the context tree."

**Basic or Advanced?**
- Basic: First context tree, learning the methodology
- Advanced: Multiple projects, systematic quality enforcement

---

## Support

- **Issues**: [GitHub Issues](https://github.com/RossH3/context-tree/issues)
- **Discussions**: [GitHub Discussions](https://github.com/RossH3/context-tree/discussions)

---

## License

MIT License - See LICENSE file

---

## Credits

- **Concept**: Ross Hanahan
- **Inspired by**: Jesse Vincent's [Superpowers](https://github.com/obra/superpowers) skills system
- **Persuasion principles**: Robert Cialdini's research on commitment and authority

---

*Build context trees. Make Claude Code effective. Ship faster.*
