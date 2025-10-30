# Phase 1: Codebase Discovery

**Purpose:** Explore brownfield codebase to gather enough context for intelligent interview questions

**Time:** 15-20 minutes

**Output:** `docs/context-tree-build/discovery_summary.json`

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

**Why versions matter:** Legacy versions (Play 2.0.4, Cassandra 1.2.12) have non-obvious constraints

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

## Output Format: discovery_summary.json

Create this file at: `docs/context-tree-build/discovery_summary.json`

```json
{
  "metadata": {
    "project_root": "/absolute/path/to/project",
    "analyzed_at": "2025-10-30T14:30:00Z",
    "discovery_duration_minutes": 18
  },
  "tech_stack": {
    "framework": "Play Framework 2.0.4",
    "language": "Java 8",
    "build_tool": "SBT 0.13.5",
    "databases": ["Cassandra 1.2.12", "ElasticSearch 1.7.6"],
    "key_dependencies": [
      "PaymentsPlugin (internal, shared across 5 projects)",
      "Apache Commons Lang 2.6"
    ]
  },
  "architecture": {
    "pattern": "MVC with service layer",
    "multi_tenant": true,
    "multi_tenant_mechanism": "Hostname-based tenant isolation (clientid = request().host())",
    "data_architecture": "Dual database: Cassandra (primary storage), ElasticSearch (query engine)",
    "authentication": "Session cookies (legacy, not JWT)"
  },
  "entry_points": [
    "conf/routes - defines all HTTP endpoints",
    "app/Global.java - application startup",
    "app/controllers/*.java - request handlers"
  ],
  "key_directories": {
    "controllers": "app/controllers/",
    "models": "app/models/",
    "views": "app/views/",
    "business_logic": "Distributed between controllers and models (no separate service layer for most code)",
    "shared_code": "app/com/opensesame/plugins/payments/ - PaymentsPlugin"
  },
  "terminology_discovered": [
    {
      "ui_term": "Application",
      "code_term": "Order",
      "db_term": "order",
      "files_verified": ["app/models/Order.java", "app/controllers/Applications.java"],
      "note": "Critical - developers searching for 'Application' will miss 'Order' class"
    },
    {
      "ui_term": "School Choice Process",
      "code_term": "Opportunity",
      "db_term": "opportunity",
      "note": "Process is actually Opportunity = Process + School + Grade combination"
    }
  ],
  "confusing_areas": [
    "Why both Cassandra AND ElasticSearch? What's the relationship?",
    "How does multi-tenancy actually work? Every query filtered by clientid?",
    "Why still on Play 2.0.4 (released 2012)?",
    "PaymentsPlugin is shared - can we modify it? What's the constraint?",
    "Some controllers bypass models - when is this okay vs wrong?"
  ],
  "existing_docs": {
    "README.md": "Exists, but describes old deployment process (mentions Heroku, now uses AWS)",
    "architecture_docs": "None found",
    "inline_comments": "Sparse, mostly in PaymentsPlugin code"
  },
  "gotchas_identified": [
    "Legacy Play 2.0.4 - many modern Play docs don't apply",
    "Multi-tenant: MUST include clientid filter in all queries",
    "Dual database: Cassandra is source of truth, ES is for queries only",
    "PaymentsPlugin: Shared dependency, cannot modify without coordinating across 5 projects"
  ],
  "questions_for_interview": [
    "What's the relationship between Cassandra and ElasticSearch? When do you use each?",
    "How do you ensure every query includes the clientid filter?",
    "Are there other terminology traps beyond Application=Order?",
    "Why is the codebase still on Play 2.0.4? Is upgrade planned?",
    "What are the common mistakes new developers make?",
    "What takes longest to explain to new team members?"
  ]
}
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

Before finalizing discovery_summary.json:

- [ ] Tech stack versions verified against actual build files (not docs)
- [ ] At least 2-3 terminology traps identified (or note "none found after thorough search")
- [ ] Architecture patterns are non-obvious discoveries (not just "it's MVC")
- [ ] Confusing areas documented (will seed interview questions)
- [ ] All claims verified against actual code
- [ ] Gotchas focus on things AI couldn't easily infer
- [ ] Questions for interview are specific, not generic

---

## After Completion

1. **Write discovery_summary.json** to `docs/context-tree-build/discovery_summary.json`
2. **Commit the file** (with message: "feat: complete Phase 1 codebase discovery")
3. **Report to orchestrator:** "Phase 1 complete. Discovered [X] terminology traps, [Y] architectural patterns. Ready for Phase 2 interview."

---

**Begin codebase discovery now. Be a detective, not a documentarian.**
