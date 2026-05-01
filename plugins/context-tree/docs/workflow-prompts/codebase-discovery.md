# Phase 1: Codebase Discovery

**Purpose:** Explore brownfield codebase to gather enough context for intelligent interview questions

**Time:** 15-20 minutes

**Output:** `docs/context-tree-build/discovery.md`

---

## Your Mission

You are a detective exploring an unfamiliar codebase. Your goal is **not** to understand everything, but to:

1. **Identify what's non-obvious** (architecture patterns, tech stack quirks, terminology traps)
2. **Find what's confusing** (these become interview questions for domain expert)
3. **Verify against actual code** (not docs - docs lie, code doesn't)
4. **Prepare for Phase 2** (domain expert interview needs focused questions)

---

## Discovery Goals

### 1. Tech Stack & Versions
- Framework name and **exact version** (check build files, not docs)
- Programming language and version
- Build tool (Maven, SBT, npm, etc.)
- Databases (check actual connection code, not README)
- Key dependencies with versions (especially legacy/unusual ones)

**Why versions matter:** Legacy versions often have non-obvious constraints that affect development

### 2. Architecture Patterns
- MVC? Microservices? Monolith? Hybrid?
- Data storage pattern (single DB? dual DB? event sourcing?)
- Multi-tenant? If yes, how is tenant isolation implemented?
- Authentication/authorization pattern
- API style (REST? GraphQL? RPC?)

**Focus on non-obvious patterns** - AI can see "it's MVC", but can't infer "multi-tenant by hostname extraction"

### 3. Terminology Traps (CRITICAL for interview)
Look for cases where:
- **UI term ≠ code term ≠ DB term**
- Example: UI says "Application", code has `Order` class, DB table is `orders`
- Generic class names that hide domain concepts
- Business jargon in code vs user-facing terms

**These are gold for interview questions**

### 4. Entry Points & Key Directories
- Where does execution start? (Global.java, main.js, routes file?)
- Controllers/handlers directory
- Models/entities directory
- Views/templates directory
- Where is business logic? (controllers? services? models?)

### 5. Existing Documentation
- README.md - does it match reality?
- Architecture docs - are they current?
- Inline comments - what do they reveal?
- API docs - do they exist?

**Cross-check docs against code** - note discrepancies

### 6. Confusing Areas (Seeds for Interview)
Things that make you go "wait, what?":
- Unexpected patterns or constraints
- Complex relationships between components
- Magic strings or unexplained constants
- Technical debt markers (TODOs, FIXMEs, "temporary" code from 2015)
- Why certain technologies still in use

**Document your confusion - it's valuable**

---

## Exploration Approach

**You have flexibility in HOW you explore.** Use whatever tools make sense:

- **Explore agent** for broad codebase understanding
- **Grep** for finding patterns (class names, imports, keywords)
- **Read** for examining specific files
- **Glob** for finding file types or directories
- **Bash** for running project-specific commands (package.json scripts, build info, etc.)

**Goal-oriented, not prescriptive.** Adapt based on what you find.

---

## Output Format: discovery.md

Create this file at: `docs/context-tree-build/discovery.md`

```markdown
# Phase 1: Codebase Discovery

**Analyzed:** 2025-12-16 13:45
**Duration:** 18 minutes
**Project Root:** /absolute/path/to/project

---

## Tech Stack

**Framework:** Rails 5.2.8
**Language:** Ruby 2.7.6
**Build Tool:** Bundler 2.3.10
**Databases:** PostgreSQL 12.9, Redis 6.2.6

**Key Dependencies:**
- InternalAuthPlugin (internal, shared across 5 projects)
- ActiveModel Serializers 0.10.12

**Version Constraints:** Still on Rails 5.2.8 due to [note constraint if found, or flag for interview]

---

## Architecture Patterns

**Pattern:** MVC with service layer
**Multi-tenant:** Yes - hostname-based isolation (clientid = request().host())
**Data:** Dual database - PostgreSQL (source of truth), Redis (cache + query acceleration)
**Authentication:** Session cookies (legacy, not JWT)

---

## Terminology Traps Discovered

### 1. Application → Order

**UI Term:** "Application"
**Code Term:** `Order`
**DB Table:** `orders`
**Files:** `app/models/Order.java`, `app/controllers/Applications.java`
**Why Critical:** Developers searching for 'Application' will miss core Order class

### 2. Workspace → Tenant

**UI Term:** "Workspace"
**Code Term:** `Tenant`
**DB Table:** `tenants`
**Note:** Tenant is the top-level isolation boundary; everything else is scoped under it

*(Add more as discovered)*

---

## Entry Points & Key Directories

**Entry Points:**
- `conf/routes` - defines all HTTP endpoints
- `app/Global.java` - application startup
- `app/controllers/*.java` - request handlers

**Key Directories:**
- Controllers: `app/controllers/`
- Models: `app/models/`
- Business Logic: Distributed between controllers and models
- Shared Code: `app/com/example/plugins/internal-auth/` (InternalAuthPlugin)

---

## Confusing Areas (Interview Seeds)

1. Why both PostgreSQL AND Redis? What's the relationship?
2. How does multi-tenancy actually work? Every query filtered?
3. Why still on Rails 5.2.8? Upgrade planned?
4. InternalAuthPlugin is shared - can we modify it?
5. Some controllers bypass models - when is this okay?

---

## Existing Documentation Status

**README.md:** Exists, but describes old deployment (mentions Heroku, now AWS)
**Architecture Docs:** None found
**Inline Comments:** Sparse, mostly in InternalAuthPlugin code

---

## Gotchas Identified

- Legacy Rails 5.2.8 - many modern Rails docs don't apply
- Multi-tenant: MUST include tenant_id filter in all queries
- Dual database: PostgreSQL is source of truth, Redis for cache/queries only
- InternalAuthPlugin: Shared dependency across 5 projects - can't modify freely

---

## Questions for Interview

1. What's the relationship between PostgreSQL and Redis? When to use each?
2. How do you ensure every query includes the tenant_id filter?
3. Are there other terminology traps beyond Application=Order?
4. Why is the codebase still on Rails 5.2.8? Is upgrade planned?
5. What are the common mistakes new developers make?
6. What takes longest to explain to new team members?

---

*Discovery complete. Ready for Phase 2 interview.*
```

---

## Critical Principles

### ✅ DO
- **Verify every claim against actual code** (grep, read files, check imports)
- **Focus on non-obvious patterns** (AI can infer "it's MVC", can't infer multi-tenant mechanism)
- **Document confusion** ("I don't understand X" is valuable for interview)
- **Note discrepancies** (docs say X, code does Y)
- **Identify terminology traps** (UI term ≠ code term is pure gold)
- **Check actual versions** (build.sbt, pom.xml, package.json - not README)

### ❌ DON'T
- **Don't trust documentation** - verify against code
- **Don't document what's obvious from code structure** (AI can see "UserController handles users")
- **Don't explain how frameworks work** (no need to explain what MVC is)
- **Don't try to understand everything** - focus on non-obvious patterns
- **Don't add fluff** - every line in JSON must provide value

---

## Completion Checklist

Before finalizing discovery.md:

- [ ] Tech stack versions verified against actual build files (not docs)
- [ ] At least 2-3 terminology traps identified (or note "none found after thorough search")
- [ ] Architecture patterns are non-obvious discoveries (not just "it's MVC")
- [ ] Confusing areas documented (will seed interview questions)
- [ ] All claims verified against actual code
- [ ] Gotchas focus on things AI couldn't easily infer
- [ ] Questions for interview are specific, not generic

---

## After Completion

1. **Write discovery.md** to `docs/context-tree-build/discovery.md`
2. **Update status.md:** Mark Phase 1 as complete
3. **Commit the files** (with message: "feat: complete Phase 1 codebase discovery")
4. **Report to orchestrator:** "Phase 1 complete. Discovered [X] terminology traps, [Y] architectural patterns. Ready for Phase 2 interview."

---

**Begin codebase discovery now. Be a detective, not a documentarian.**
