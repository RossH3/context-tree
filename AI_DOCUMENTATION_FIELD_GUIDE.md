# AI Documentation Field Guide
**Practical lessons from documenting a 50+ tenant legacy codebase for AI assistants**

*After months of experimentation with elaborate documentation systems, here's what actually works.*

---

## What This Guide Is About

**Context Tree is a Claude Code-first methodology** for documenting brownfield repositories.

**Primary Audience:** This documentation is written FOR Claude Code (the AI) to consume. Senior developers can read it, but Claude is the primary reader. Every pattern here optimizes for Claude's comprehension and token efficiency.

**It operates on two levels:**

**Physical: Tree Structure**
Hierarchical CLAUDE.md files matching your source tree - leveraging Claude Code's layered context loading. Repository-specific, not portable. Predictable discovery: need controller context? → `app/controllers/CLAUDE.md`

**Logical: Knowledge Graph**
Cross-references and semantic relationships that span the hierarchy. Terminology maps (UI → Code → DB), architectural patterns referenced from multiple places, single sources of truth with many-to-many connections.

**Why both matter:** The tree provides navigation (where to find context), the graph provides richness (how concepts connect). Together they make Claude Code work better with your specific brownfield codebase.

**This guide focuses on practical implementation** - what to document, when to document it, and how to keep signal-to-noise ratio high. The lessons below come from production use on complex, multi-tenant codebases.

---

## The Core Insight

AI assistants (Claude, GitHub Copilot, etc.) are getting better at exploring code, but they still can't infer:
- Why you made architectural decisions
- What business terms mean (and how UI → code → database terms map)
- What the gotchas are in your specific codebase
- What institutional knowledge exists outside the code

**But**: Comprehensive upfront documentation doesn't work. You can't predict what matters. You discover it by working.

**Solution**: Lightweight navigation hub + incremental capture when problems repeat.

---

## Part 1: The Pattern That Works

### Root CLAUDE.md as Navigation Hub

**Purpose**: One-page orientation that prevents the most common mistakes and routes to the right places.

**Structure** (keep it under 200 lines):

```markdown
# [Project Name] - Navigation & AI Assistant Guide

## Critical Concepts (Top 5 things that cause confusion)
1. [Most confusing terminology mapping]
2. [Biggest architectural gotcha]
3. [Most common wrong assumption]
4. [Critical business rule]
5. [Key technology constraint]

## What Are You Trying To Do? (Decision Trees)

**Debugging something broken?**
├─ [Common problem 1] → [File/pattern to check]
├─ [Common problem 2] → [File/pattern to check]
└─ [Common problem 3] → [File/pattern to check]

**Building a feature?**
├─ [Common task 1] → [Starting point]
├─ [Common task 2] → [Starting point]
└─ [Common task 3] → [Starting point]

**Understanding the system?**
└─ Start: [2-3 sentence system overview]

## Common Pitfalls to Avoid

### ❌ DON'T
- [Most common mistake 1]
- [Most common mistake 2]
- [Most common mistake 3]

### ✅ DO
- [Correct pattern 1]
- [Correct pattern 2]
- [Correct pattern 3]
```

**That's it.** No elaborate docs hierarchy. No comprehensive architecture docs. Just the essentials.

---

## Part 2: Incremental Capture System

### When to Document

Document when you hit the **Rule of Two**:
- You've explained the same thing to the AI twice, OR
- AI made the same wrong assumption twice, OR
- You've had to correct the same misunderstanding twice

**First time**: Just answer the question.
**Second time**: Consider documenting.
**Third time would happen**: Document it now.

### What to Capture

Capture **just enough to prevent the third occurrence**. Usually 2-3 lines:

**Good examples:**
- "User submissions are called `Entry` objects in the code - search for `Entry` not `Submission`"
- "All queries MUST include tenantid filter: `String tenant = request().host()`"
- "Don't refactor InternalAuthPlugin code - it's a shared dependency used by multiple projects"

**Bad examples:**
- Full architecture explanations
- Code that's visible in the codebase
- Generic programming patterns

### Where to Put It

**Add to existing sections in root CLAUDE.md:**

- Terminology mapping → Add to "Critical Concepts"
- Common mistake → Add to "Common Pitfalls"
- Routing info → Add to decision tree
- Technology constraint → Add to "Critical Concepts"

**Keep it inline.** Don't create separate files until you have 10+ items in a category.

### The Capture Process

1. AI makes mistake or asks question (first time)
2. You answer, continue working
3. AI makes same mistake/asks same question (second time)
4. Stop. Open root CLAUDE.md
5. Add 2-3 lines in the relevant section
6. Commit: "docs: clarify [the thing]"
7. Continue working

**Time cost**: 2 minutes. **Time saved**: Every future session.

---

## Part 3: Anti-Patterns to Avoid

### ❌ Don't Build Comprehensive Docs Upfront

You don't know what matters yet. You'll document the wrong things and miss the important stuff.

**Wrong**: "I'll document the entire architecture, all entities, all workflows, then start working."
**Right**: "I'll create a minimal CLAUDE.md, then add to it when I hit friction."

### ❌ Don't Document What Code Structure Shows

AI can see:
- Class/function names and signatures
- Directory structure
- Import relationships
- Code comments

**Wrong**: "The UserController handles user-related endpoints"
**Right**: "User authentication uses legacy session cookies, not JWTs - don't refactor without migration plan"

### ❌ Don't Document From Documentation

Always verify against actual code. Documentation lies. Code doesn't (usually).

**Wrong**: Reading old architecture docs and transcribing them.
**Right**: Searching codebase to verify how something actually works, then documenting that.

### ❌ Don't Let It Grow Unchecked

If root CLAUDE.md hits 200 lines, it's time to prune or extract.

**Prune**: Remove things that haven't been referenced in 3 months.
**Extract**: Create a separate doc only if you have 10+ related items (e.g., GLOSSARY.md if you have many terminology mappings).

**Target**: Keep root CLAUDE.md scannable in 60 seconds.

---

## Part 4: Quality Checks

Before adding something to CLAUDE.md, ask:

1. **Would this save time on the next task?**
   - Yes → Add it
   - No → Skip it

2. **Have I verified this against actual code?**
   - Yes → Add it
   - No → Go verify first

3. **Could AI infer this from code structure?**
   - No → Add it
   - Yes → Skip it

4. **Is this less than 5 lines?**
   - Yes → Add it inline
   - No → Summarize in 2-3 lines or extract to separate doc

---

## Part 5: Real Example

Below is the root CLAUDE.md from a production multi-tenant SaaS application. This evolved over months of actual work, capturing real friction points.

**Notice:**
- Critical concepts up front (terminology traps, architecture gotchas)
- Decision trees for common tasks
- Minimal explanation, maximum navigation
- Under 200 lines total

<details>
<summary>Click to view: Sample CLAUDE.md (fictional product, illustrative only)</summary>

```markdown
# Apex Platform - Context Tree Navigation & Claude Code Guide

**Navigation hub and AI assistant guidance for the Apex application codebase**

## 🚀 Quick Start for Developers

**What is Apex?** A multi-tenant SaaS platform for HR leave management, serving multiple companies as separate tenants.

**Architecture**: See [Technology Stack](docs/ARCHITECTURE.md#technology-stack) for complete tech details

### Critical Concepts to Understand First
1. **Policy = Country + EmploymentType + Role** - The central business entity for leave eligibility
2. **Time Off Requests are "Entries"** - Search for `Entry` not `Request` in code
3. **Multi-tenant by hostname** - Each company isolated by `tenantid = hostname`
4. **Database A = Primary Storage** - Source of truth for all data
5. **Database B = Query Engine** - All queries go through B; writes go to A
6. **Form Templates** - The foundation of dynamic policy configuration

### First Day Checklist
- [ ] Read the decision trees below for quick task routing
- [ ] Understand the [Business Context](docs/BUSINESS_CONTEXT.md)
- [ ] Review [Architecture Overview](docs/ARCHITECTURE.md)
- [ ] Explore [Key Controllers](docs/KEY_CONTROLLERS.md)

---

## ⚡ Critical Context (Prevent Common Mistakes)
- **Time Off Requests = "Entry" objects** - Backend uses `Entry`, UI says "Time Off Request". See [GLOSSARY.md](docs/GLOSSARY.md) for complete terminology mappings.
- **Dual Database Pattern** - Primary storage is source of truth, separate query engine for reads. See [ARCHITECTURE.md - Data Architecture](docs/ARCHITECTURE.md#data-architecture).
- **Multi-tenancy by tenantid** - EVERY query must filter by tenantid (derived from hostname). See [ARCHITECTURE.md - Multi-Tenancy](docs/ARCHITECTURE.md#multi-tenancy-architecture).
- **Technology Stack**: Legacy framework versions with specific constraints. See [ARCHITECTURE.md - Technology Stack](docs/ARCHITECTURE.md#technology-stack).

## 🎯 What are you trying to do? (Quick Decision Tree)

**Debugging something broken?**
├─ Entry/Request not showing? → [ENTITIES.md](docs/ENTITIES.md) → [DATA_FLOWS.md](docs/DATA_FLOWS.md)
├─ Authentication failing? → [KEY_CONTROLLERS.md](docs/KEY_CONTROLLERS.md#authentication)
├─ Wrong tenant data showing? → Check tenantid filter → [CONFIGURATION.md](docs/CONFIGURATION.md)
├─ File upload issues? → [DOCUMENT_MANAGEMENT.md](docs/DOCUMENT_MANAGEMENT.md)
├─ Form not saving? → [ENTITIES.md](docs/ENTITIES.md#formtemplates) → [API_REFERENCE.md](docs/API_REFERENCE.md)
└─ Search strategies? → [AI_STRATEGIES.md](docs/AI_STRATEGIES.md)

**Building a feature?**
├─ New API endpoint? → [KEY_CONTROLLERS.md](docs/KEY_CONTROLLERS.md) → routes config
├─ Modifying forms? → [ENTITIES.md](docs/ENTITIES.md#formtemplates)
├─ Database operation? → [STORAGE_LAYER.md](docs/STORAGE_LAYER.md)
└─ View templates? → [app/views/CLAUDE.md](app/views/CLAUDE.md) → [VIEW_PATTERNS.md](docs/VIEW_PATTERNS.md)

**Understanding the system?**
└─ Start: [BUSINESS_CONTEXT.md](docs/BUSINESS_CONTEXT.md) → [ARCHITECTURE.md](docs/ARCHITECTURE.md) → [FRAMEWORK_REFERENCE.md](docs/FRAMEWORK_REFERENCE.md)

---

## 🔧 Multi-Tenant Critical

⚠️ **Every query MUST include tenant filter** (derived from `request().host()`).

```java
// Quick reference - Always extract and use tenantid
String tenantid = request().host();  // Full hostname
Entry entry = entryManager.getEntry(tenantid, entryId);
```

📖 **Complete multi-tenant patterns**: See [ARCHITECTURE.md - Multi-Tenancy Architecture](docs/ARCHITECTURE.md#multi-tenancy-architecture) for:
- Tenant extraction patterns
- Query filtering examples
- Security implications
- Common mistakes and prevention

---

## Common Pitfalls to Avoid

### ❌ DON'T
- Search for "Request" class when looking for time off requests (use "Entry")
- Assume traditional DAO pattern or modern framework patterns
- Look for normalized database tables (uses JSON blob storage)

### ✅ DO
- Always include multi-tenant tenantid filter in queries
- Check [GLOSSARY.md](docs/GLOSSARY.md) for terminology, [ARCHITECTURE.md](docs/ARCHITECTURE.md) for patterns
- Check per-tenant database configuration for settings (multiple config types: "site", "application", etc.)

---

*This context tree serves as both human navigation and AI assistant guidance. All detailed documentation is organized in the `docs/` directory with clear cross-references.*
```

</details>

**Key lessons from this example:**
- The terminology trap ("Time Off Requests are Entries") appears in multiple sections — critical traps deserve repetition
- Multi-tenant filtering is emphasized as security-critical, with a code snippet for instant pattern matching
- Decision trees route to specific files rather than embedding explanations
- Total length: ~165 lines (scannable in 60 seconds)
- The product, domain, and entity names here are fictional — the *patterns* are what to copy when building your own root CLAUDE.md

---

## Part 6: Getting Started

### For a New Project

1. **Create root CLAUDE.md with basic structure** (10 minutes):
   - 2-3 sentence project description
   - Empty "Critical Concepts" section
   - Empty "Common Pitfalls" section
   - Basic decision tree structure

2. **Start working** - Don't document anything yet

3. **When friction occurs** (second time only):
   - Open CLAUDE.md
   - Add 2-3 lines to relevant section
   - Commit and continue

4. **After 2-3 weeks**, review:
   - What's actually being referenced?
   - What never gets used? (Delete it)
   - Does anything need extraction to separate doc? (Probably not yet)

### For an Existing Project

If you already have extensive documentation:

1. **Create new minimal CLAUDE.md** (don't migrate old docs yet)
2. **Work for 2 weeks using only the new CLAUDE.md**
3. **Track what you wish was documented** (add those things)
4. **Track what you thought you'd need but didn't** (ignore old docs)
5. **After 2 weeks**: Old comprehensive docs probably weren't helping

---

## Part 7: What This Replaces

This field guide is the distillation of:
- 5-phase structured build process (too heavy)
- Automated discovery commands (AI Explore agents do this now)
- Monthly audit workflows (too much process)
- Elaborate .claude/ skills and commands (over-engineered)
- Comprehensive architecture docs (unused)

**What survived:**
- Root CLAUDE.md pattern (works)
- Signal-to-noise principle (critical)
- Verify against code, not docs (critical)
- Incremental capture (works)

The elaborate methodology taught these lessons. You don't need the methodology anymore—just the lessons.

---

## Conclusion

Good AI documentation is:
1. **Minimal** - One navigation hub, under 200 lines
2. **Incremental** - Built during work, not before it
3. **Practical** - Prevents repeated mistakes
4. **Verified** - Against actual code, not other docs
5. **Pruned** - Delete what's not being used

**Start small. Add when friction repeats. Prune ruthlessly.**

That's it. That's the system.

---

## Additional Resources

- **Context Tree Principles** (CONTEXT_TREE_PRINCIPLES.md) - Deeper exploration of signal-to-noise, verification discipline
- **Your root CLAUDE.md** - Living example of this pattern in action
- **Claude Code /init command** - Anthropic's built-in initialization creates similar structure

---

*Last updated: 2025-10-27*
*Lessons learned from: Production multi-tenant SaaS project (12K+ lines of initial docs, 6 months of iteration)*
