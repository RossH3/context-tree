# AI Documentation Field Guide
**Practical lessons from documenting a 50+ tenant legacy codebase for AI assistants**

*After months of experimentation with elaborate documentation systems, here's what actually works.*

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
- "Student applications are called `Order` objects in the code - search for `Order` not `Application`"
- "All queries MUST include clientid filter: `String client = request().host()`"
- "Don't refactor PaymentsPlugin code - it's a shared dependency used by 5 other projects"

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
<summary>Click to view: Production CLAUDE.md Example</summary>

```markdown
# Choice Project - Context Tree Navigation & Claude Code Guide

**Complete navigation hub and AI assistant guidance for Choice application codebase**

## 🚀 Quick Start for Developers

**What is Choice?** A multi-tenant SaaS platform for managing school choice/lottery applications, serving 50+ school districts.

**Architecture**: [See Technology Stack](docs/ARCHITECTURE.md#technology-stack) for complete tech details

### Critical Concepts to Understand First
1. **Opportunity = Process + School + Grade** - The central business entity
2. **Applications are "Orders"** - Search for `Order` not `Application` in code
3. **Multi-tenant by hostname** - Each district isolated by `clientid = hostname`
4. **Database A = Primary Storage** - Source of truth for all data
5. **Database B = Query Engine** - All queries go through B, data pulled from A
6. **Question Groups** - The foundation of dynamic form building

### First Day Checklist
- [ ] Read the decision trees below for quick task routing
- [ ] Understand the [Business Context](docs/BUSINESS_CONTEXT.md)
- [ ] Review [Architecture Overview](docs/ARCHITECTURE.md)
- [ ] Explore [Key Controllers](docs/KEY_CONTROLLERS.md)

---

## ⚡ Critical Context (Prevent Common Mistakes)
- **Student Applications = "Order" objects** - Backend uses `Order`, UI says "applications". See [GLOSSARY.md](docs/GLOSSARY.md) for complete terminology mappings.
- **Dual Database Pattern** - Primary storage is source of truth, separate query engine for reads. See [ARCHITECTURE.md - Data Architecture](docs/ARCHITECTURE.md#data-architecture) for complete pattern.
- **Multi-tenancy by clientid** - EVERY query must filter by clientid (derived from hostname). See [ARCHITECTURE.md - Multi-Tenancy](docs/ARCHITECTURE.md#multi-tenancy-architecture).
- **Technology Stack**: Legacy framework versions with specific constraints. See [ARCHITECTURE.md - Technology Stack](docs/ARCHITECTURE.md#technology-stack) for complete details.

## 🎯 What are you trying to do? (Quick Decision Tree)

**Debugging something broken?**
├─ Order/Application not showing? → [ENTITIES.md](docs/ENTITIES.md) → [DATA_FLOWS.md](docs/DATA_FLOWS.md)
├─ Authentication failing? → [KEY_CONTROLLERS.md](docs/KEY_CONTROLLERS.md#authentication)
├─ Wrong district data showing? → Check clientid filter → [CONFIGURATION.md](docs/CONFIGURATION.md)
├─ Scanner/document upload issues? → [DOCUMENT_MANAGEMENT.md](docs/DOCUMENT_MANAGEMENT.md)
├─ Form not saving? → [ENTITIES.md](docs/ENTITIES.md#questiongroups) → [API_REFERENCE.md](docs/API_REFERENCE.md)
└─ Search strategies? → [AI_STRATEGIES.md](docs/AI_STRATEGIES.md)

**Building a feature?**
├─ New API endpoint? → [KEY_CONTROLLERS.md](docs/KEY_CONTROLLERS.md) → [conf/routes](conf/routes)
├─ Modifying forms? → [ENTITIES.md](docs/ENTITIES.md#questiongroups)
├─ Database operation? → [PAYMENTSPLUGIN_STORAGE.md](docs/PAYMENTSPLUGIN_STORAGE.md)
└─ View templates? → [app/views/CLAUDE.md](app/views/CLAUDE.md) → [VIEW_PATTERNS.md](docs/VIEW_PATTERNS.md)

**Understanding the system?**
└─ Start: [BUSINESS_CONTEXT.md](docs/BUSINESS_CONTEXT.md) → [ARCHITECTURE.md](docs/ARCHITECTURE.md) → [PLAY_2.0.4_REFERENCE.md](docs/PLAY_2.0.4_REFERENCE.md)

---

## 🔧 Multi-Tenant Critical

⚠️ **Every query MUST include client filter** (derived from `request().host()`).

```java
// Quick reference - Always extract and use clientid
String clientid = request().host();  // Full hostname
Order order = oMan.getOrder(clientid, orderId);
```

📖 **Complete multi-tenant patterns**: See [ARCHITECTURE.md - Multi-Tenancy Architecture](docs/ARCHITECTURE.md#multi-tenancy-architecture) for:
- Client extraction patterns
- Query filtering examples
- Security implications
- Common mistakes and prevention

---

## Common Pitfalls to Avoid

### ❌ DON'T
- Search for "Application" class when looking for applications (use "Order")
- Assume traditional DAO pattern or modern framework patterns
- Look for normalized database tables (uses JSON blob storage)

### ✅ DO
- Always include multi-tenant clientid filter in queries
- Check [GLOSSARY.md](docs/GLOSSARY.md) for terminology, [ARCHITECTURE.md](docs/ARCHITECTURE.md) for patterns
- Check per-client database configuration for settings (multiple config types: "site", "application", etc.)

---

*This context tree serves as both human navigation and AI assistant guidance. All detailed documentation is organized in the `docs/` directory with clear cross-references.*
```

</details>

**Key lessons from this example:**
- "Applications are Orders" appears multiple times (critical terminology trap)
- Multi-tenant filtering is emphasized (security-critical pattern)
- Decision trees route to specific files (not comprehensive explanations)
- Total length: 166 lines (scannable in 60 seconds)

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
