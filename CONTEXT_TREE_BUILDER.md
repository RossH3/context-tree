# Context Tree Builder: Interview Guide

**For AI Assistants:** Use this guide to build a context tree for a brownfield codebase through structured conversation with developers.

**For Developers:** This guide shows what questions will be asked and what information is needed to build effective context trees.

---

## How This Works

1. **Automated Discovery** - AI analyzes codebase structure, tech stack, patterns
2. **Developer Interview** - AI asks targeted questions to capture soft context
3. **Incremental Generation** - AI creates CLAUDE.md and reference docs based on answers
4. **Iterative Refinement** - Review, test with real tasks, identify gaps, iterate

**Time estimate:** 2-4 hours for initial context tree, then refinement over 1-2 weeks of real usage.

---

## Phase 1: Automated Discovery

**AI should gather automatically using commands from CONTEXT_TREE_DISCOVERY.md:**

### Technical Analysis
- [ ] Primary languages (and versions if detectable)
- [ ] Framework(s) and versions (check package files, imports)
- [ ] Directory structure (top 2-3 levels)
- [ ] Entry points (main files, routes, controllers, etc.)
- [ ] Database/storage patterns (files, config, connection code)
- [ ] Build system (Maven, Gradle, npm, etc.)
- [ ] Testing setup (test framework, test locations)

### Existing Documentation Audit
- [ ] README content and quality
- [ ] Other markdown files in repo
- [ ] Comments in key files (architecture notes?)
- [ ] Wiki links or external doc references
- [ ] Inline code comments (patterns, TODOs)

### Pattern Detection
- [ ] Multi-tenant? (hostname-based routing, orgid filters)
- [ ] Microservices or monolith?
- [ ] API-only or full-stack?
- [ ] Authentication pattern (session, JWT, etc.)

**Output:** Present findings to developer, ask for corrections.

**Example automated discovery:**
```
I've analyzed the codebase. Here's what I found:

**Tech Stack:**
- Ruby 2.5 with Rails 5.2
- MySQL 5.6 (detected in Gemfile)
- Elasticsearch 2.4 (detected in dependencies)

**Structure:**
- MVC pattern: app/controllers, app/models, app/views
- Configuration in config/
- No test/ directory detected

**Patterns:**
- Multi-tenant (found orgid filtering in 18+ files)
- Monolithic application
- Session-based authentication (detected in application_controller.rb)

Does this match your understanding? What did I miss?
```

---

## Phase 2: Business Context Interview

**Goal:** Capture what can't be derived from code structure.

### 2.1 Business Domain (Core Understanding)

**Q1: "What does this codebase do?"**
- Expected: 1-2 sentence elevator pitch
- Capture: Primary business purpose
- Example: "Manages conference and event registrations for 80+ organizations"

**Q2: "Who are the users?"**
- Expected: User types and their roles
- Capture: Attendees, admins, org staff, coordinators, etc.
- Example: "Attendees register for sessions, org administrators review/process, coordinators run allocation"

**Q3: "What are the top 3-5 core business entities?"**
- Expected: Domain objects central to the system
- Capture: Names and brief descriptions
- Example: "Session (event + track + time slot), Registration (attendee signup), Attendee, Track"

**Q4: "What's the main business workflow?"**
- Expected: High-level process from start to finish
- Capture: Step-by-step user journey
- Example: "Organization setup → Attendee signup → Registration → Review → Allocation → Confirmation → Badge printing"

### 2.2 Terminology Traps (Critical for AI)

**Q5: "Are there terms that mean different things in UI vs code vs database?"**
- Expected: Terminology mappings
- Capture: "Signups" (UI) = "Registration" (code), etc.
- **This is gold** - prevents wasted AI searches

**Q6: "What do new developers always search for and can't find?"**
- Expected: Common false trails
- Capture: "They search for 'Signup' class but it's called 'Registration'"
- **This prevents repeated mistakes**

**Q7: "What's the internal vocabulary vs external/user-facing?"**
- Expected: Industry terms vs code terms
- Capture: Business language mappings

### 2.3 Architectural Gotchas

**Q8: "What's the #1 thing that must be understood before touching code?"**
- Expected: Critical architectural pattern
- Capture: Multi-tenancy, data flow, security model, etc.
- Example: "EVERY query must filter by orgid - no exceptions"

**Q9: "What do new developers always get wrong?"**
- Expected: Common mistakes and misunderstandings
- Capture: Specific gotchas and corrections
- Example: "They try to query MySQL directly instead of going through Elasticsearch"

**Q10: "How does data flow through the system?"**
- Expected: Request → Response path
- Capture: API → Cache → DB, or API → Service → Storage, etc.
- Example: "Browser → Controller → Elasticsearch (query) → MySQL (fetch) → Response"

**Q11: "What patterns are non-standard or surprising?"**
- Expected: Deviations from framework conventions
- Capture: Custom patterns, workarounds, legacy decisions
- Example: "We cache heavily in Redis, with complex invalidation logic"

**Q12: "What's the deployment/environment model?"**
- Expected: How multi-tenant works in practice
- Capture: Single instance serving all clients? Separate deployments? Database isolation?

### 2.4 Pain Points (Prioritization)

**Q13: "What takes longest to explain to new team members?"**
- Expected: Complex areas needing deep context
- Capture: Topics requiring detailed documentation
- Example: "How FormSections enable dynamic registration forms"

**Q14: "What causes the most bugs from misunderstanding?"**
- Expected: Error-prone areas
- Capture: Safety-critical patterns, edge cases
- Example: "Forgetting orgid filter causes cross-tenant data leaks"

**Q15: "If you had unlimited time, what would you document?"**
- Expected: Wishlist of documentation needs
- Capture: Gaps in current knowledge transfer
- Example: "Complete business workflow with state transitions"

### 2.5 Technology-Specific Context

**Q16: "What version-specific gotchas exist?"**
- Expected: Old framework/library quirks
- Capture: Rails 5.2 vs Rails 6+, MySQL 5.6 patterns, etc.
- Example: "Rails 5.2 uses ActiveRecord 5.2 API, caching patterns differ from Rails 6+"

**Q17: "What external dependencies are critical?"**
- Expected: External services, libraries, APIs
- Capture: Payment processors, email services, custom libraries
- Example: "PaymentsGem handles both billing and data access for registrations, NotificationService for emails"

**Q18: "What's the data persistence strategy?"**
- Expected: Storage details
- Capture: Database choice reasoning, data modeling approach
- Example: "MySQL for writes/consistency, Elasticsearch for complex queries (can't easily query MySQL directly)"

---

## Phase 3: Generate Initial Context Tree

**Based on interview answers, AI generates:**

### 3.1 Root CLAUDE.md
**Template:** See [Root CLAUDE.md Template](#root-claudemd-template) below

**Must include:**
- Quick start checklist (from interview answers)
- Decision tree navigation ("What are you trying to do?")
- Critical context (Q8, Q9, Q14 answers)
- Technology stack (from automated discovery)
- Complete documentation map (list what we'll create)

### 3.2 docs/GLOSSARY.md
**Source:** Q5, Q6, Q7 answers

**Format:**
```markdown
# Glossary: Business and Technical Terms

## UI → Code → Database Mappings

| User Sees | Code Uses | Database | Notes |
|-----------|-----------|----------|-------|
| Signup | Registration | registrations table | Always search for Registration, not Signup |
| Organization | Org | orgid field | Multi-tenant key |
```

### 3.3 docs/ARCHITECTURE.md
**Source:** Automated discovery + Q8, Q10, Q11, Q18 answers

**Sections:**
- Technology stack (versions, components)
- Data architecture (storage strategy, data flow)
- Multi-tenancy architecture (if applicable)
- Key architectural decisions (why this pattern?)

### 3.4 docs/BUSINESS_CONTEXT.md
**Source:** Q1, Q2, Q3, Q4 answers

**Sections:**
- Overview (what this system does)
- Users and roles
- Core entities (domain objects)
- Business workflows (step-by-step processes)

### 3.5 Priority Reference Docs
**Based on Q13, Q15 answers:**

Create docs for high-priority areas:
- KEY_CONTROLLERS.md or similar (complex code areas)
- Framework-specific guides (if old/unusual versions)
- External dependencies docs (if custom/critical)

---

## Phase 4: Validation & Iteration

**AI should:**

1. **Generate initial files**
2. **Ask developer to review:** "I've created root CLAUDE.md, GLOSSARY.md, ARCHITECTURE.md, and BUSINESS_CONTEXT.md. Please review for accuracy."
3. **Test with real task:** "Let's test this. Give me a real task (bug fix or feature) and I'll try to complete it using only the context tree."
4. **Identify gaps:** During task, note what information was missing or unclear
5. **Iterate:** Update context tree based on gaps found

**Example iteration:**
```
AI: "I tried to fix the cache invalidation bug but couldn't find information about
     Redis patterns. Where should I add this?"
Developer: "That should go in ARCHITECTURE.md under Caching section"
AI: "I'll add it. Also, I wasn't sure how to test multi-tenant scenarios -
     should we create TESTING.md?"
```

---

## Phase 5: Subdirectory CLAUDE.md Files

**After root context tree is solid, create scoped context:**

### Criteria for subdirectory CLAUDE.md:
- Directory has 5+ files with patterns/conventions
- Frequent developer work area (controllers, services, etc.)
- Domain-specific patterns not project-wide

### Standard subdirectories:
- `app/controllers/CLAUDE.md` - Controller patterns, key controllers
- `app/views/CLAUDE.md` - Template patterns, helpers
- `config/CLAUDE.md` - Configuration guide
- `spec/CLAUDE.md` - Testing patterns (if complex)

**Template:** See [Subdirectory CLAUDE.md Template](#subdirectory-claudemd-template) below

---

## Templates

**Note:** Text in `[brackets]` are placeholders - replace with actual content from your interview answers and automated discovery.

### Root CLAUDE.md Template

```markdown
# [Project Name] - Context Tree Navigation & Claude Code Guide

**Complete navigation hub and AI assistant guidance for [Project Name] codebase**

## 🚀 Quick Start for Developers

**What is [Project Name]?** [One sentence from Q1]

**Architecture**: [Tech stack from discovery]

### Critical Concepts to Understand First
[Top 5 things from Q3, Q8, Q9]

### First Day Checklist
- [ ] Read the decision trees below for quick task routing
- [ ] Understand the [Business Context](docs/BUSINESS_CONTEXT.md)
- [ ] Review [Architecture Overview](docs/ARCHITECTURE.md)
- [ ] Check [Glossary](docs/GLOSSARY.md) for terminology

---

## ⚡ Critical Context (Prevent Common Mistakes)
[From Q9, Q14 - common gotchas]

## 🎯 What are you trying to do? (Quick Decision Tree)

**Debugging something broken?**
├─ [Common issue 1]? → [Relevant doc]
├─ [Common issue 2]? → [Relevant doc]
└─ General debugging? → [TROUBLESHOOTING.md or ARCHITECTURE.md]

**Building a feature?**
├─ New API endpoint? → [KEY_CONTROLLERS.md or API_REFERENCE.md]
├─ Database operation? → [PAYMENTS_STORAGE or ARCHITECTURE doc]
└─ UI changes? → [VIEW_PATTERNS.md or app/views/CLAUDE.md]

**Understanding the system?**
└─ Start: [BUSINESS_CONTEXT.md] → [ARCHITECTURE.md]

---

## 🔧 [Critical Architecture Pattern - if multi-tenant, etc.]

[From Q8 - the #1 thing to understand]

[Code example or pattern]

---

## 📚 Complete Documentation Map

### Core Documentation
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - [When to read]
- [BUSINESS_CONTEXT.md](docs/BUSINESS_CONTEXT.md) - [When to read]
- [GLOSSARY.md](docs/GLOSSARY.md) - [When to read]
[Add others based on what was created]

### Directory Navigation (CLAUDE.md files)
- [docs/CLAUDE.md](docs/CLAUDE.md) - Documentation navigation
[Add others as created]

## 🔄 Core Business Workflow

[From Q4 - step-by-step workflow with ASCII diagram if helpful]

---

## 🏗️ System Architecture Overview

[From Q10 - data flow diagram or description]

### Technology Stack
[From automated discovery - be specific about versions]

---

## Language and Terminology Mappings

[From Q5, Q6 - critical mappings]

## Common Pitfalls to Avoid

### ❌ DON'T
[From Q9, Q14]

### ✅ DO
[Corrections for the DON'Ts]

---

*This context tree serves as both human navigation and AI assistant guidance.*
```

### Subdirectory CLAUDE.md Template

```markdown
# [Directory Name] - Patterns and Navigation

**Context for working with [directory purpose]**

## Purpose

This directory contains [what's in here and why].

## Key Files

**[Category 1]:**
- `[file1.ext]` - [Purpose and when to use]
- `[file2.ext]` - [Purpose and when to use]

**[Category 2]:**
- `[file3.ext]` - [Purpose and when to use]

## Common Patterns

### [Pattern 1 Name]
[Description and example]

### [Pattern 2 Name]
[Description and example]

## Gotchas

**[Gotcha 1]:**
- **Problem:** [What goes wrong]
- **Solution:** [How to avoid/fix]

## Related Documentation

- [Link to relevant root docs]
- [Link to related subdirectories]

---

*For project-wide context, see [root CLAUDE.md](../CLAUDE.md)*
```

---

## AI Assistant Implementation Notes

**When using this guide:**

1. **Start with Phase 1** - Run automated discovery commands from CONTEXT_TREE_DISCOVERY.md, present findings
2. **Don't ask all Phase 2 questions at once** - Group by section (2.1, then 2.2, etc.)
3. **Adapt questions** - If developer says "not applicable", skip related questions
4. **Generate incrementally** - Create files as you gather info, don't wait till end
5. **Show, don't tell** - Generate actual content, not placeholders
6. **Validate architecture claims** - If developer says "we use X pattern", verify against code
7. **Iterate** - First pass won't be perfect, refine based on real usage

**Time management:**
- Phase 1: 10-15 minutes (automated)
- Phase 2: 30-60 minutes (interview - can be split across sessions)
- Phase 3: 30-45 minutes (generation)
- Phase 4: 1-2 weeks (validation during real work)
- Phase 5: As needed (subdirectories)

**Quality checks:**
- Does GLOSSARY.md prevent common search mistakes?
- Does root CLAUDE.md have clear decision trees?
- Can AI complete a real task using only the context tree?
- Are architectural facts verifiable against code?

---

## For Developers: How to Use This Guide

**Option 1: Guided session with Claude Code**
```
You: "Help me build a context tree using CONTEXT_TREE_BUILDER.md"
Claude: [Runs discovery, asks interview questions, generates files]
```

**Option 2: Async/incremental**
```
You: "Let's do Phase 1 of CONTEXT_TREE_BUILDER.md"
Claude: [Runs discovery, presents findings]
[Later session]
You: "Let's do Phase 2.1 and 2.2"
Claude: [Asks business context questions]
```

**Option 3: Self-guided**
- Read through interview questions
- Write answers in a scratch file
- Ask AI to generate context tree from your answers

---

*This builder guide is based on lessons learned from real brownfield implementations - see CONTEXT_TREE_PRINCIPLES.md for the underlying principles and patterns.*
