# Context Tree Builder: Quick Start

**Build AI-optimized documentation for your brownfield codebase in 2-4 hours**

---

## What You'll Create

A **context tree** - structured documentation that lives in your codebase:
- Root `CLAUDE.md` with critical patterns and decision trees
- Reference docs (ARCHITECTURE.md, BUSINESS_CONTEXT.md, GLOSSARY.md, etc.)
- Subdirectory CLAUDE.md files for scoped context
- All maintained alongside code in git

**Result:** AI assistants (Claude Code) and developers have the context they need to work effectively.

---

## Prerequisites

- **Brownfield codebase** that needs documentation (existing production code with limited documentation, typically 50-5000+ files)
- Claude Code or similar AI assistant
- 2-4 hours for initial creation
- Senior developer who knows the codebase

---

## Quick Start: Three Commands

### Option 1: Guided Session (Recommended)

Open Claude Code in your project directory:

```bash
cd /path/to/your/project
claude code
```

Then say:
```
Help me build a context tree using docs/CONTEXT_TREE_BUILDER.md
```

Claude will:
1. Run automated discovery
2. Ask interview questions
3. Generate context tree files
4. Help you refine based on real usage

### Option 2: Step-by-Step

If you want more control, work through phases:

```
Phase 1: Let's do automated discovery from CONTEXT_TREE_BUILDER.md
[Review findings]

Phase 2: Let's do the business context interview (section 2.1 and 2.2)
[Answer questions]

Phase 3: Generate initial context tree files
[Review and refine]
```

### Option 3: Self-Guided

If you prefer to write answers first:

1. Read CONTEXT_TREE_BUILDER.md interview questions
2. Write answers in a scratch file
3. Ask Claude: "Generate context tree from my answers in [file]"

---

## What Happens During the Session

### Phase 1: Automated Discovery (10-15 min)
Claude analyzes:
- Tech stack (languages, frameworks, versions)
- Directory structure
- Entry points (controllers, routes, etc.)
- Database patterns
- Existing documentation

**You review and confirm findings.**

### Phase 2: Developer Interview (30-60 min)
Claude asks ~15-18 questions about:
- **Business domain** - What does this do? Who uses it?
- **Terminology traps** - UI vs code vs database terms
- **Architectural gotchas** - What must everyone know?
- **Pain points** - What takes longest to explain?

**You answer from experience. Don't overthink it.**

### Phase 3: Generate Files (30-45 min)
Claude creates:
- Root `CLAUDE.md` (navigation hub)
- `docs/GLOSSARY.md` (terminology mappings)
- `docs/ARCHITECTURE.md` (tech stack, patterns)
- `docs/BUSINESS_CONTEXT.md` (workflows, domain)
- Other priority docs based on your answers

**You review for accuracy.**

### Phase 4: Validation (1-2 weeks)
- Test with real tasks
- Identify gaps
- Refine and iterate
- Add subdirectory CLAUDE.md files as needed

---

## Tips for Success

### Before You Start
- **Choose the right codebase** - Active development, 2-4 developers, real brownfield pain
- **Block time** - Initial session needs focused 2-4 hours
- **Have examples ready** - Code snippets, common gotchas, terminology conflicts

### During the Interview
- **Be specific** - "Registrations represent attendee signups" not "we have a registration system"
- **Share gotchas** - What do new developers always get wrong?
- **Don't be exhaustive** - Signal over noise, token efficiency matters
- **Verify architecture** - If Claude generates something, check against actual code

### After Generation
- **Test it** - Give Claude a real task using only the context tree
- **Iterate quickly** - Found a gap? Add it immediately
- **Commit frequently** - Context tree lives in git like code
- **Get team input** - Other developers will spot gaps

---

## Example Session Transcript

```
Developer: Help me build a context tree using docs/CONTEXT_TREE_BUILDER.md

Claude: I'll help you build a context tree for this codebase. Let me start with
automated discovery.

[Runs commands from CONTEXT_TREE_DISCOVERY.md]

Claude: I've analyzed the codebase. Here's what I found:

Tech Stack:
- Ruby 2.5 with Rails 5.2
- MySQL 5.6 (primary storage)
- Elasticsearch 2.4 (query engine)

Structure:
- MVC pattern: app/controllers, app/models, app/views
- Configuration in config/
- No test/ directory detected

Patterns:
- Multi-tenant (orgid filtering in 52 files)
- Monolithic application
- Session-based authentication

Does this match your understanding? What did I miss?

Developer: Yes, that's right. We have tests but they're in a separate repo.

Claude: Got it. Now let's talk about the business domain. What does this codebase do?

Developer: It manages conference and event registrations for organizations.

Claude: Who are the users?

Developer: Attendees register for sessions, org administrators review registrations,
coordinators run allocation when sessions are oversubscribed.

[Continue interview...]

[30 minutes later]

Claude: Based on your answers, I've generated:
- CLAUDE.md (root navigation with decision trees)
- docs/GLOSSARY.md (Signup → Registration mapping, etc.)
- docs/ARCHITECTURE.md (dual database pattern, multi-tenancy)
- docs/BUSINESS_CONTEXT.md (event workflow, entities)

I've committed these files. Want to review them?

Developer: Let me check GLOSSARY.md... looks good!

Claude: Great! Let's test it. Give me a real task and I'll try to complete it
using only the context tree.

Developer: Debug why registrations aren't showing for one organization.

Claude: [Uses context tree to solve problem, identifies what information was
missing or unclear]

Claude: The context tree helped, but I couldn't find information about how
Elasticsearch indexing works. Should we add that to ARCHITECTURE.md?

Developer: Yes, add a section on ES indexing and the sync pattern.

[Iterate and refine...]
```

---

## FAQ

**Q: How long does this take?**
A: 2-4 hours for initial context tree, then refinement over 1-2 weeks of real usage.

**Q: Do I need to answer all interview questions?**
A: No, skip irrelevant questions. Claude adapts based on your project.

**Q: Can I do this in multiple sessions?**
A: Yes! Do Phase 1 one day, Phase 2 another day, etc. Since Claude Code doesn't maintain context between sessions:
1. Commit your work after each session
2. Start next session with: "Continue building the context tree - review git log and CONTEXT_TREE_BUILDER.md to see where we left off"
3. Claude will read the files and pick up where you stopped

**Q: What if I don't know the answer to something?**
A: Say so! Claude can help investigate the code, or mark it as "needs research."

**Q: Do I need to document everything?**
A: No! Signal-to-noise matters. Focus on what can't be derived from code structure.

**Q: Can other team members help?**
A: Yes! Different developers know different areas. Can be collaborative.

**Q: What if our codebase is huge?**
A: Start with one module/service. Context trees work well from 50 to 5000+ files - use hierarchical structure to expand incrementally.

---

## Next Steps After Initial Creation

1. **Share with team** - Get feedback, identify gaps
2. **Use it** - Real tasks reveal what's missing
3. **Refine** - Add subdirectory CLAUDE.md files as needed
4. **Maintain** - Update alongside code changes
5. **Expand** - Apply to other codebases

---

## Files You'll Work With

- **CONTEXT_TREE_BUILDER.md** - Interview guide (Claude follows this)
- **CONTEXT_TREE_DISCOVERY.md** - Automated analysis commands (Claude runs these)
- **CONTEXT_TREE_PRINCIPLES.md** - Underlying principles and patterns (reference)

---

## Getting Help

If you get stuck:
1. Ask Claude: "What's the next step in CONTEXT_TREE_BUILDER.md?"
2. Review CONTEXT_TREE_PRINCIPLES.md for principles and examples
3. Share your experiences with the community

---

**Ready to start? Open Claude Code and say:**
```
Help me build a context tree using docs/CONTEXT_TREE_BUILDER.md
```

---

*Part of the Context Tree Builder tool. See CONTEXT_TREE_BUILDER.md for detailed guide.*
