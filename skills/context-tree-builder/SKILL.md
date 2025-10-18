---
name: Context Tree Builder
description: Build initial context tree for brownfield codebases through structured discovery, domain expert interview, and documentation generation. Use when starting a new context tree from scratch (2-4 hour initial session).
---

# Context Tree Builder

## Overview

Build a **context tree** for a brownfield codebase through a structured 2-4 hour session. A context tree is hierarchical CLAUDE.md files and focused reference documents that maximize AI assistant effectiveness.

**This skill is for INITIAL BUILD only.** For ongoing maintenance, use the Context Tree Maintenance skill.

**The hard part is not generating documentation - it's curating high-value context and maintaining signal-to-noise ratio.**

## Critical Principles (Guardrails)

### Keep the Meat, Throw Away the Bones

**Signal-to-noise ratio is the primary quality metric.**

- ✅ **Keep**: Essential patterns, gotchas, business context, architectural decisions, terminology mappings
- ❌ **Remove**: Generic information, verbose explanations, repetitive examples, anything derivable from code structure alone
- **Rule**: Every line must justify its token cost
- **Test**: If you can derive it from code structure (LSP, grep, file names), don't document it

### Verify Architectural Claims Against Code

**NEVER document architecture based on other documentation - always verify against actual code.**

- Documentation can propagate incorrect architectural descriptions across multiple files
- When documenting architecture, cross-check claims against actual implementation
- Look for inconsistencies between documentation claims and actual API calls in code
- **Commitment Device**: Before documenting any architectural claim, announce: "I'm verifying [claim] against code at [file:line]"

### Bad Context is Worse Than Bad Code

**Outdated or incorrect documentation actively misleads and compounds errors.**

- Bad code: Can be debugged, identified through testing, fixed incrementally
- Bad context: Silently trains AI assistants incorrectly, compounds errors, erodes trust
- **Rule**: Fix inconsistencies immediately when discovered

### Single Source of Truth for Architectural Facts

**Architectural facts must have ONE authoritative location to prevent documentation drift.**

- Core architecture → `docs/ARCHITECTURE.md`
- Technology stack versions → `docs/ARCHITECTURE.md`
- Business workflows → `docs/BUSINESS_CONTEXT.md`
- Configuration patterns → `docs/CONFIGURATION.md`
- **Rule**: Other documents reference the source of truth, NEVER duplicate it

## Common Rationalizations (STOP THESE IMMEDIATELY)

**These are excuses for violating the principles above. NEVER fall into these traps:**

❌ **"I'll verify this architectural claim later"**
→ NO. Verify NOW against code. Bad context is worse than bad code.
→ **Correct action**: Open the code file, verify the claim, then document.

❌ **"This JSON example is detailed but might be useful someday"**
→ NO. If it doesn't justify its token cost NOW, remove it.
→ **Correct action**: Ask "Does this teach something not obvious from the code?" If no, delete.

❌ **"I'll document this even though it's derivable from code structure"**
→ STOP. Can you grep for it? Can LSP show it? Then don't document it.
→ **Correct action**: Test if `grep` or file navigation would find it. If yes, don't document.

❌ **"This might be outdated but I'll leave it for now"**
→ NEVER. Incorrect documentation is worse than no documentation.
→ **Correct action**: Verify against code NOW or delete the content.

❌ **"I don't have time to find the single source of truth"**
→ STOP. Making a duplicate is worse than not documenting.
→ **Correct action**: Spend 30 seconds grepping docs/ for existing content first.

## Phase 1: Automated Discovery (15-20 minutes)

**Run systematic analysis to understand codebase structure. DO NOT PROCEED without running these commands.**

See the **[discovery-commands.md](discovery-commands.md)** file for complete bash command reference covering:
- Tech stack detection
- Database detection
- Directory structure analysis
- Entry points & routes
- Pattern detection (multi-tenancy, auth, architecture)
- Existing documentation audit
- Build & test setup

**STOP after discovery. Review findings with domain expert before proceeding.**

**Commitment Device**: Before proceeding to Phase 2, announce: "I've completed discovery. Here are my findings: [summary]. Ready for interview?"

## Phase 2: Domain Expert Interview (30-60 minutes)

**Ask focused questions to capture institutional knowledge. Quality over quantity.**

Critical questions (adapt based on codebase):

**Business Context:**
1. What does this codebase do in one sentence?
2. Who are the users? (Roles, not just "users")
3. What's the core business workflow? (3-5 steps)
4. What's the most complex business domain area?

**Terminology Traps:**
5. What terms differ between UI, code, and database? (This is critical - capture all mappings)
6. Any legacy names still in code but not in UI?
7. Industry-specific terms that developers must know?

**Architectural Gotchas:**
8. What must every developer know about data storage? (Primary database, query patterns, caching)
9. Multi-tenant? If yes, how is tenant isolation enforced?
10. Authentication/authorization pattern?
11. What framework version? Any version-specific gotchas?

**Pain Points:**
12. What takes longest to explain to new developers?
13. What do new developers always get wrong?
14. What architectural decision causes the most confusion?
15. Any terminology that causes recurring mistakes?

**STOP generating generic answers. Push for specific examples and actual pain points.**

**Commitment Device**: After each answer, verify: "Let me check the code to confirm [claim]..."

## Phase 3: Generate Core Files (45-60 minutes)

**Create foundational documentation with ruthless focus on signal-to-noise.**

**Priority order:**
1. **Root CLAUDE.md** - Navigation hub, critical patterns, decision trees
2. **docs/GLOSSARY.md** - Terminology mappings (UI ↔ code ↔ database)
3. **docs/ARCHITECTURE.md** - Tech stack, data storage, multi-tenancy, version-specific patterns
4. **docs/BUSINESS_CONTEXT.md** - Core workflow, domain entities, business rules

**For each file:**
- ✅ Start with concrete facts and examples
- ✅ Focus on what can't be derived from code structure
- ❌ Don't write generic explanations of MVC, REST, etc.
- ❌ Don't list every file or API endpoint
- **VERIFY**: Cross-check architectural claims against actual code before writing

**Commitment Device**: Before writing each doc, announce:
"I'm creating [filename]. I will verify all architectural claims against code at [file:line]."

**Commit files as they're created - don't batch.**

### Root CLAUDE.md Template

```markdown
# [Project Name] - Context Tree Navigation

**What is [Project Name]?** [One sentence from Q1]

**Architecture**: [Tech stack from discovery]

## Critical Concepts to Understand First
[Top 5 things from Q3, Q8, Q9]

## What are you trying to do? (Quick Decision Tree)

**Debugging something broken?**
├─ [Common issue 1]? → [Relevant doc]
├─ [Common issue 2]? → [Relevant doc]
└─ General debugging? → [TROUBLESHOOTING.md or ARCHITECTURE.md]

**Building a feature?**
├─ New API endpoint? → [KEY_CONTROLLERS.md or API_REFERENCE.md]
├─ Database operation? → [ARCHITECTURE doc]
└─ UI changes? → [VIEW_PATTERNS.md]

**Understanding the system?**
└─ Start: [BUSINESS_CONTEXT.md] → [ARCHITECTURE.md]

## Documentation Map

### Core Documentation
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - [When to read]
- [BUSINESS_CONTEXT.md](docs/BUSINESS_CONTEXT.md) - [When to read]
- [GLOSSARY.md](docs/GLOSSARY.md) - [When to read]

## Critical Architecture Pattern

[From Q8 - the #1 thing to understand]

[Code example or pattern]

## Common Pitfalls

### ❌ DON'T
[From Q9, Q14]

### ✅ DO
[Corrections]
```

### GLOSSARY.md Template

```markdown
# Glossary: Business and Technical Terms

## UI → Code → Database Mappings

| User Sees | Code Uses | Database | Notes |
|-----------|-----------|----------|-------|
| [UI term] | [Code term] | [DB name] | [Search guidance] |
```

### ARCHITECTURE.md Template

```markdown
# Architecture Overview

## Technology Stack
[From discovery - be specific about versions]

## Data Architecture
[From Q10, Q18 - storage strategy, data flow]

## Multi-tenancy (if applicable)
[From Q9 - isolation enforcement]

## Key Architectural Decisions
[From Q8, Q11 - why this pattern?]
```

### BUSINESS_CONTEXT.md Template

```markdown
# Business Context

## Overview
[From Q1 - what this system does]

## Users and Roles
[From Q2]

## Core Entities
[From Q3 - domain objects]

## Business Workflows
[From Q4 - step-by-step processes]
```

## Phase 4: Validation (During first week)

**Test context tree effectiveness with real tasks.**

1. Give AI assistant a real debugging task using only the context tree
2. Give AI assistant a feature implementation task
3. Identify what information was missing (add it)
4. Note what information was present but unused (candidate for removal)

**Iterate based on gaps discovered.**

**Commitment Device**: After testing, announce: "Context tree test revealed [gaps]. Adding [specific content] to [file]."

## Phase 5: Subdirectory CLAUDE.md Files (As needed)

**Create scoped context for frequently-worked directories.**

### Criteria for subdirectory CLAUDE.md:
- Directory has 5+ files with patterns/conventions
- Frequent developer work area (controllers, services, etc.)
- Domain-specific patterns not project-wide

### Standard subdirectories:
- `app/controllers/CLAUDE.md` - Controller patterns, key controllers
- `app/views/CLAUDE.md` - Template patterns, helpers
- `config/CLAUDE.md` - Configuration guide
- `spec/CLAUDE.md` - Testing patterns (if complex)

### Subdirectory CLAUDE.md Template

```markdown
# [Directory Name] - Patterns and Navigation

## Purpose
This directory contains [what's in here and why].

## Key Files
**[Category 1]:**
- `[file1.ext]` - [Purpose and when to use]

## Common Patterns
### [Pattern 1 Name]
[Description and example]

## Gotchas
**[Gotcha 1]:**
- **Problem:** [What goes wrong]
- **Solution:** [How to avoid/fix]

## Related Documentation
- [Link to relevant root docs]
```

**Create subdirectory files based on actual project structure discovered in Phase 1.**

## Session Management

**For multi-session builds:**

Since Claude Code doesn't maintain context between sessions:
1. Commit your work after each phase
2. Start next session with: "Continue building the context tree - review git log and recent commits to see where we left off"
3. Claude will read the files and pick up where you stopped

**Commit frequently throughout the build process.**

## Verification Checklist

**Before considering the initial build complete:**

✅ **Signal-to-noise**: Can you read any section and find unique, non-obvious insights? (Not generic framework info)

✅ **Accuracy**: Do architectural claims match actual code implementation? (Verified against code)

✅ **Terminology**: Are UI ↔ code ↔ database mappings complete and correct?

✅ **Decision trees**: Does root CLAUDE.md route common tasks to relevant docs?

✅ **Completeness**: Are all 4 core files created (root CLAUDE.md, GLOSSARY, ARCHITECTURE, BUSINESS_CONTEXT)?

✅ **Effectiveness test**: Can AI assistant complete a task using context tree without extensive additional explanation?

✅ **Git**: Are all files committed with clear messages?

## Handoff to Maintenance

**After initial build is complete:**

1. **Test with real tasks** during first 1-2 weeks
2. **Capture insights** as you discover them (use Context Tree Maintenance skill)
3. **Run monthly audits** to maintain quality (use Context Tree Maintenance skill)
4. **Update alongside code changes** (use Context Tree Maintenance skill)

**The initial build is just the starting point. The context tree evolves through use.**

## Summary: Core Workflow

**Phases:**
1. Automated discovery (15-20 min) → Review with domain expert
2. Focused interview (30-60 min) - quality over quantity
3. Generate core files (45-60 min) - verify against code
4. Test with real tasks (1-2 weeks) → Iterate
5. Create subdirectory CLAUDE.md files as needed

**Remember:**
- Signal-to-noise ratio is the primary quality metric
- Bad context is worse than bad code
- Verify architectural claims against actual code, always
- Every line must justify its token cost
- Commit context tree changes frequently
- Announce your actions (commitment device)

---

*This skill focuses on the initial build. For ongoing maintenance, use the Context Tree Maintenance skill.*
