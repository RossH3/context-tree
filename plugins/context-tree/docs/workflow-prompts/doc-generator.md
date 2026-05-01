# Phase 3: Documentation Generation

**Purpose:** Generate high-quality documentation from discovery and interview insights

**Time:** 30-45 minutes

**Inputs:**
- `docs/context-tree-build/discovery.md`
- `docs/context-tree-build/interview.md`

**Outputs (conditional):**
- `CLAUDE.md` (always - navigation hub, with v4 frontmatter)
- `docs/GLOSSARY.md` (only if ≥3 verified terminology mappings)
- `docs/ARCHITECTURE.md` (only if ≥3 non-obvious patterns)
- `docs/BUSINESS_CONTEXT.md` (only if ≥3 business insights)
- `knowledge.yaml` (only if ≥4 docs total — KCP routing manifest)

---

## ⚠️ CRITICAL: No Generic Slop

**Quality over quantity.** This phase has strict quality gates.

**Only generate a document if you have substantial, non-obvious content.**

Generic framework explanations, obvious code patterns, and filler content are **worse than no documentation**.

---

## Your Mission

Transform the raw insights from Phases 1 & 2 into concise, high-signal documentation:

1. **Load working files** - Read both markdown files
2. **Assess quality** - Count high-value insights in each category
3. **Apply quality gates** - Only generate docs that pass thresholds
4. **Generate docs** - Following strict signal-to-noise principles
5. **Verify claims** - Cross-check against actual code
6. **Commit incrementally** - One commit per file generated

---

## Step 1: Load and Assess

### Read Working Files

```bash
discovery.md - Phase 1 output
interview.md - Phase 2 output
```

### Count High-Value Insights

Tally insights by category from the markdown files:

**Terminology Traps:**
- Count items from discovery.md "Terminology Traps Discovered" section
- Count Q&As from interview.md with Category: Terminology and Value: High
- **Quality gate:** Need ≥3 verified mappings for GLOSSARY.md

**Architectural Patterns:**
- Count items from discovery.md "Gotchas Identified" section
- Count non-obvious patterns from discovery.md "Architecture Patterns" section
- Count Q&As from interview.md Category: Architecture with Value: High or Critical
- **Quality gate:** Need ≥3 non-obvious patterns for ARCHITECTURE.md

**Business Insights:**
- Count Q&As from interview.md Category: Business Context with Value: High
- Count workflow descriptions
- Count business rules
- **Quality gate:** Need ≥3 substantial insights for BUSINESS_CONTEXT.md

**Common Pitfalls:**
- Count Q&As from interview.md Category: Pitfalls
- Count items from discovery.md "Confusing Areas" section
- **These go into CLAUDE.md "Common Pitfalls" section**

---

## Step 2: Apply Quality Gates

### Decision Matrix

```
Terminology mappings found:
  ≥3 verified → Generate GLOSSARY.md
  <3 verified → Skip GLOSSARY.md, add to CLAUDE.md inline

Architecture patterns found:
  ≥3 non-obvious → Generate ARCHITECTURE.md
  <3 non-obvious → Skip ARCHITECTURE.md, add to CLAUDE.md inline

Business insights found:
  ≥3 substantial → Generate BUSINESS_CONTEXT.md
  <3 substantial → Skip BUSINESS_CONTEXT.md, add to CLAUDE.md inline

CLAUDE.md:
  ALWAYS generate (navigation hub + whatever doesn't warrant separate docs)
```

### What Counts as "Non-Obvious"?

**✅ Non-obvious (include):**
- Multi-tenant by hostname extraction (not obvious from code structure)
- Dual database pattern with specific roles (Primary DB=truth, Cache=acceleration)
- Legacy version constraints with business reasons
- Security-critical patterns (must filter by tenant_id)
- Terminology where UI ≠ code ≠ DB

**❌ Obvious (exclude):**
- "This is an MVC application" (structure shows this)
- "UserController handles user operations" (name shows this)
- "We use Ruby" (file extensions show this)
- Generic framework explanations ("Rails uses routes file for URLs")

---

## Frontmatter Convention (v4)

**Every generated doc starts with this frontmatter.** It aligns with Anthropic's auto-memory shape so tools can read both layers consistently.

```yaml
---
name: <doc name, e.g. "Architecture Reference">
description: <one-line purpose, used for routing>
type: reference          # nearly all Context Tree docs are 'reference' to the codebase
scope: repo              # distinguishes from auto-memory's user-scope
source: build            # one of: build | interview | ingest | promoted-from-memory | manual
verified: YYYY-MM-DD     # date claims were last verified against code
---
```

Fields:
- `name`, `description` — match Anthropic's auto-memory frontmatter
- `type: reference` — Context Tree docs describe the codebase, not the user
- `scope: repo` — Context Tree-specific. Always `repo`. (Distinguishes from memory's user-scope.)
- `source` — provenance. `build` for docs generated here, other values for ingest/promote/manual updates
- `verified` — refreshed by `drift-detector` after audits

CLAUDE.md at root may use `name: "Repo Navigation"` and otherwise the same frontmatter.

---

## Step 3: Generate CLAUDE.md (ALWAYS)

**Purpose:** Navigation hub + consolidated insights

**Location:** `CLAUDE.md` (project root)

**Structure:**

```markdown
---
name: Repo Navigation
description: AI assistant entry point for [Project Name]
type: reference
scope: repo
source: build
verified: [today's date]
---

# [Project Name] - AI Assistant Guide

**Purpose:** [One-sentence project description from interview]

**Quick Start:** [Link to most important doc/section]

---

## Critical Concepts (Top 5 Confusion Points)

1. [Most critical gotcha from interview - usually terminology or architecture]
2. [Second most critical]
3. [Third most critical]
4. [Fourth most critical]
5. [Fifth most critical]

*(Pull from security_critical + high-value items in interview_notes.json)*

---

## What Are You Trying To Do? (Decision Trees)

**Debugging something broken?**
├─ [Common problem 1] → [Where to look - file/pattern]
├─ [Common problem 2] → [Where to look - file/pattern]
└─ [Common problem 3] → [Where to look - file/pattern]

**Building a feature?**
├─ [Common task 1] → [Entry point - file/directory]
├─ [Common task 2] → [Entry point - file/directory]
└─ [Common task 3] → [Entry point - file/directory]

**Understanding the system?**
└─ Start: [2-3 sentence system overview]
   ├─ Then: [Link to ARCHITECTURE.md if it exists, or inline summary]
   └─ See: [Link to GLOSSARY.md if it exists, or inline terminology]

*(Build from discovery entry_points and interview workflows)*

---

## Common Pitfalls to Avoid

### ❌ DON'T
- [Most common mistake from interview]
- [Second most common mistake]
- [Third most common mistake]

### ✅ DO
- [Correct pattern for pitfall 1]
- [Correct pattern for pitfall 2]
- [Correct pattern for pitfall 3]

*(Pull from interview category: "pitfalls" + discovery gotchas)*

---

## Terminology Quick Reference

[If GLOSSARY.md exists: Link to it]
[If not: Inline 3-5 most critical mappings]

**Critical mappings:**
- `UI term` → `Code term` (`db_term` table) - [why this matters]
- ...

---

## Architecture Quick Reference

[If ARCHITECTURE.md exists: Link to it + 2-sentence summary]
[If not: Inline 3-5 most critical patterns]

**Critical patterns:**
- [Pattern name]: [One sentence description]
- ...

---

## Additional Resources

[Links to other docs if they exist]
[Links to external resources if mentioned in interview]

---

*Context tree built: [date]*
*Based on interview with: [if mentioned in interview metadata]*
```

### CLAUDE.md Quality Principles

- **Under 200 lines** if possible (scannable in 60 seconds)
- **Every line justifies token cost** - no filler
- **Action-oriented** - "Here's what to do" not "Here's what exists"
- **Prevents mistakes** - Focus on what goes wrong
- **Links, don't duplicate** - If separate docs exist, link to them

---

## Step 4: Generate GLOSSARY.md (Conditional)

**Quality Gate:** Only if ≥3 verified terminology mappings

**Purpose:** Map UI terms ↔ Code terms ↔ DB terms

**Location:** `docs/GLOSSARY.md`

**Structure:**

```markdown
---
name: Glossary
description: UI -> Code -> DB terminology mappings for [Project Name]
type: reference
scope: repo
source: build
verified: [today's date]
---

# Glossary: Terminology Mappings

**Purpose:** Critical mappings between UI language, code classes, and database tables

**When to use this:** You're searching the codebase for a feature and can't find it

---

## UI → Code → Database Mappings

### [UI Term 1]
- **What users see:** "[UI term]"
- **Code class/concept:** `[ClassName]`
- **Database:** `[table_name]` table
- **Why different:** [Explanation from interview]
- **Where to look:** `[file paths]`
- **Example:** [Concrete example if provided in interview]

### [UI Term 2]
...

---

## Domain-Specific Terminology

### [Business Term 1]
**Definition:** [From interview - what it actually means]

**Why it matters:** [Context from interview]

**Related code:** `[file:line]`

---

## Search Cheat Sheet

Searching for...? Try grepping for:
- [Feature name] → `[keyword that actually works]`
- [Another feature] → `[keyword that actually works]`

---

*Mappings verified: [date]*
*Source: Domain expert interview + code verification*
```

### GLOSSARY.md Quality Principles

- **Only verified mappings** - Every entry must be confirmed against code
- **Explains WHY** - Why is UI term different from code term?
- **Actionable** - "Search for X not Y" guidance
- **Specific examples** - Real class names, file paths, line numbers

---

## Step 5: Generate ARCHITECTURE.md (Conditional)

**Quality Gate:** Only if ≥3 non-obvious architectural patterns

**Purpose:** Document architectural decisions and patterns that aren't obvious from code structure

**Location:** `docs/ARCHITECTURE.md`

**Structure:**

```markdown
---
name: Architecture Reference
description: Non-obvious architectural patterns and constraints for [Project Name]
type: reference
scope: repo
source: build
verified: [today's date]
---

# Architecture Reference

**Purpose:** Non-obvious architectural patterns, decisions, and constraints

**Read this when:** You're confused about how systems interact or why things are structured a certain way

---

## Technology Stack

### Core Technologies
- **Framework:** [Name + exact version] - [Why this version? Any constraints?]
- **Language:** [Name + version]
- **Build Tool:** [Name + version]
- **Databases:** [List with versions]
- **Key Dependencies:** [Only unusual or legacy ones worth noting]

**Why these versions:** [Explanation from interview if provided]

**Upgrade constraints:** [If mentioned in interview]

---

## Critical Architectural Patterns

### [Pattern 1: e.g., Multi-Tenancy]
**What it is:** [One sentence]

**How it works:** [2-3 sentences from interview + code verification]

**Code evidence:** `[file:line]` - [what to look for]

**Critical rule:** [What developers MUST do - e.g., "filter by clientid"]

**What breaks if violated:** [From interview - real consequences]

**Example:**
```[language]
// Good example from code
[code snippet showing correct pattern]
```

### [Pattern 2: e.g., Dual Database]
...

---

## System Interactions

### [Subsystem A] ↔ [Subsystem B]
**Relationship:** [From interview]

**Data flow:** [A writes to X, B reads from Y]

**Code evidence:** `[file:line]`

**Gotchas:** [What to watch out for]

---

## Historical Context & Constraints

### Why [Old Technology/Pattern] Still In Use?
**Reason:** [From interview - business/technical constraints]

**Attempted changes:** [If mentioned in interview]

**Current plan:** [If mentioned in interview]

---

## Common Architectural Mistakes

*(Security-critical items from interview go here)*

1. **[Mistake 1 - e.g., Missing clientid filter]**
   - What happens: [Consequence]
   - How to avoid: [Code pattern]
   - How to verify: [Grep for pattern]

---

*Architecture verified: [date]*
*Source: Code analysis + domain expert interview*
```

### ARCHITECTURE.md Quality Principles

- **Non-obvious only** - Skip what code structure shows
- **Explains WHY** - Why this pattern exists
- **Security-critical first** - Prioritize items flagged as security_critical
- **Code evidence** - Every claim has file:line reference
- **Real consequences** - "What breaks if you violate this"

---

## Step 6: Generate BUSINESS_CONTEXT.md (Conditional)

**Quality Gate:** Only if ≥3 substantial business insights

**Purpose:** Domain knowledge and business workflows that can't be inferred from code

**Location:** `docs/BUSINESS_CONTEXT.md`

**Structure:**

```markdown
---
name: Business Context
description: Domain knowledge, workflows, and business rules for [Project Name]
type: reference
scope: repo
source: build
verified: [today's date]
---

# Business Context

**Purpose:** Domain knowledge, user workflows, and business rules

**Read this when:** You need to understand what the system does and why

---

## What This System Does

[2-3 paragraph explanation from interview]

**Core problem solved:** [Business problem]

**Users:** [User types and their goals]

---

## Primary Workflow

### [Main User Journey - e.g., "Parent Application Process"]

1. **[Step 1]:** [Actor] does [action]
   - Code: `[file:line]` - [what handles this]
   - Business rule: [If any]

2. **[Step 2]:** [Actor] does [action]
   - Code: `[file:line]`
   - Business rule: [If any]

3. **[Step 3]:** [Actor] does [action]
   - Code: `[file:line]`
   - Business rule: [If any]

...

---

## Business Rules

### [Rule 1 - from interview]
**Rule:** [Statement of the rule]

**Why it exists:** [Business reason]

**Code enforcement:** `[file:line]` - [how it's enforced]

**Edge cases:** [If mentioned]

### [Rule 2]
...

---

## Domain Concepts

### [Concept 1 - e.g., "Pricing Algorithm"]
**What it is:** [Explanation from interview]

**When it runs:** [Trigger conditions]

**What it does:** [High-level algorithm if explained in interview]

**Code:** `[file:line]`

---

## User Roles & Permissions

[If mentioned in interview]

| Role | Capabilities | Code Enforcement |
|------|-------------|------------------|
| [Role 1] | [What they can do] | `[file:line]` |

---

*Business context captured: [date]*
*Source: Domain expert interview*
```

### BUSINESS_CONTEXT.md Quality Principles

- **Business knowledge only** - Not technical implementation details
- **User-centric** - Focuses on what users do and why
- **Workflow-oriented** - Shows how things flow through the system
- **Explains WHY** - Why business rules exist
- **Links to code** - Where workflow steps are implemented

---

## Step 6.5: Generate `knowledge.yaml` (Conditional, v4)

**Quality gate:** Only generate `knowledge.yaml` if the tree has **≥4 docs total** (CLAUDE.md + ≥3 conditional docs, or CLAUDE.md + multiple subdirectory CLAUDE.md files). Smaller trees don't need a routing manifest — Anthropic's automatic CLAUDE.md discovery is enough.

**Purpose:** A KCP-style routing manifest. Conceptual cousin to Anthropic's `MEMORY.md` index, but richer — includes triggers and decision trees so Claude can route to the right doc by intent.

**Location:** `knowledge.yaml` at the project root.

**Format:**

```yaml
# Knowledge Context Protocol (KCP) v0.9 Manifest
# [Project Name] — [one-line description]

kcp_version: "0.9"
project: [Project Name]
version: "1.0.0"
updated: "[today's date]"
indexing: read-only
language: en

# Root hints — guide agents to the right starting point
root_hints:
  entry_point: root-navigation
  quick_start:
    - "[Top critical concept 1 — terminology trap or architectural rule]"
    - "[Top critical concept 2]"
    - "[Top critical concept 3]"
    - "[Top critical concept 4]"
    - "[Top critical concept 5]"
  decision_tree:
    debugging:
      description: "Something is broken"
      routes:
        - trigger: "[symptom keywords]"
          targets: [unit-id, unit-id]
    building:
      description: "Building a new feature"
      routes:
        - trigger: "[task keywords]"
          targets: [unit-id]
    understanding:
      description: "Understanding the system"
      routes:
        - trigger: "business|domain|workflow"
          targets: [business-context, architecture]

# Units — one per generated doc
units:
  - id: root-navigation
    path: CLAUDE.md
    intent: "How do I navigate this codebase?"
    load_strategy: eager
    priority: critical
    triggers:
      - "navigate|where do I start|overview"
    depends_on: []

  - id: glossary
    path: docs/GLOSSARY.md
    intent: "What does [UI term] map to in code?"
    load_strategy: lazy
    priority: high
    triggers:
      - "terminology|glossary|naming"
      - "[domain-specific term keywords]"
    depends_on: []

  - id: architecture
    path: docs/ARCHITECTURE.md
    intent: "How does the system fit together?"
    load_strategy: lazy
    priority: high
    triggers:
      - "architecture|pattern|how does X work"
    depends_on: []

  - id: business-context
    path: docs/BUSINESS_CONTEXT.md
    intent: "What does this system do and why?"
    load_strategy: lazy
    priority: high
    triggers:
      - "business|workflow|domain|why"
    depends_on: []
```

### Field guide

- `id` — short kebab-case identifier (used in `targets:` and `depends_on:`)
- `path` — relative path from repo root
- `intent` — the question this unit answers
- `load_strategy` — `eager` (always loaded) or `lazy` (load when triggered)
- `priority` — `critical | high | supplementary | reference`
- `triggers` — regex-style patterns matching user intent
- `depends_on` — other unit ids that should be loaded alongside this one

### Quality principles

- **Trigger phrases must be concrete** — avoid generic single words; prefer phrases that real users type
- **Decision tree branches mirror real workflows** — debugging / building / deploying / understanding are good defaults; add others if the interview revealed them
- **`eager` is rare** — only navigation hubs and absolutely-must-load docs. Most are `lazy`
- **Keep depths sensible** — `depends_on` chains shouldn't be more than 2-3 hops

### When NOT to generate this

- Tree has only CLAUDE.md (no docs/ files generated due to quality gates) — skip; CLAUDE.md is itself the index
- Tree is small enough that any reader would just read everything — skip
- The team explicitly doesn't want a YAML routing layer — skip

If skipping: note in the build summary that `knowledge.yaml` was not generated and why.

---

## Step 7: Verify All Claims

Before finalizing ANY document:

### Verification Checklist

For each architectural claim:
- [ ] Grep for relevant patterns
- [ ] Read actual implementation files
- [ ] Confirm claim matches reality
- [ ] Add file:line references
- [ ] If claim can't be verified, either remove it or mark as "from interview - verify needed"

For each code reference:
- [ ] File exists at specified path
- [ ] Line number is accurate (or use approximate)
- [ ] Code actually does what doc claims

For each terminology mapping:
- [ ] Class/file actually exists
- [ ] DB table exists (check schema files or actual DB)
- [ ] Mapping is correct

**If you can't verify a claim, don't include it without a clear disclaimer.**

---

## Step 8: Commit Files Incrementally

As each file is completed:

```bash
# CLAUDE.md
git add CLAUDE.md
git commit -m "docs: add root CLAUDE.md navigation hub"

# GLOSSARY.md (if generated)
git add docs/GLOSSARY.md
git commit -m "docs: add terminology glossary with UI↔Code↔DB mappings"

# ARCHITECTURE.md (if generated)
git add docs/ARCHITECTURE.md
git commit -m "docs: add architecture reference with non-obvious patterns"

# BUSINESS_CONTEXT.md (if generated)
git add docs/BUSINESS_CONTEXT.md
git commit -m "docs: add business context and workflows"

# knowledge.yaml (if generated)
git add knowledge.yaml
git commit -m "docs: add KCP routing manifest"
```

**Each file gets its own commit** so changes are independently tracked.

---

## Example Quality Gate Decision

**Scenario:** After reading checkpoint files, you find:
- 5 verified terminology mappings
- 4 non-obvious architectural patterns
- 2 business insights

**Decision:**
```
✅ Generate GLOSSARY.md (5 ≥ 3)
✅ Generate ARCHITECTURE.md (4 ≥ 3)
❌ Skip BUSINESS_CONTEXT.md (2 < 3)
✅ Generate CLAUDE.md (always)
   - Include 2 business insights inline in CLAUDE.md
```

**Result:** 3 files generated, all with substantial content. No fluff.

---

## Critical Principles

### ✅ DO
- **Apply quality gates strictly** - Better to skip than generate slop
- **Verify every claim** - Against actual code, not just interview answers
- **Link, don't duplicate** - CLAUDE.md links to other docs
- **Be concise** - Every line justifies token cost
- **Use concrete examples** - Real file paths, real class names
- **Mark security-critical** - Highlight items flagged in interview
- **Commit incrementally** - One commit per file

### ❌ DON'T
- **Don't explain frameworks** - No "Rails uses routes for HTTP routing"
- **Don't document obvious structure** - AI can see "UserController handles users"
- **Don't generate docs just to fill slots** - Quality gates exist for a reason
- **Don't duplicate content** - If it's in GLOSSARY.md, link to it from CLAUDE.md
- **Don't trust interview without verification** - Always check code
- **Don't batch commits** - Separate commit per file

---

## Completion Checklist

Before reporting completion:

- [ ] All generated docs pass quality gates (≥3 items for optional docs)
- [ ] All architectural claims verified against code
- [ ] All file:line references are accurate
- [ ] CLAUDE.md is under 200 lines (or has good reason to be longer)
- [ ] No generic framework explanations
- [ ] No obvious code patterns documented
- [ ] Each file committed separately
- [ ] No spelling errors or broken links

---

## After Completion

**Report to orchestrator:**

```
Phase 3 complete. Generated documentation:
✅ CLAUDE.md (root navigation hub)
✅ docs/GLOSSARY.md (5 terminology mappings)
✅ docs/ARCHITECTURE.md (4 architectural patterns)
❌ docs/BUSINESS_CONTEXT.md (skipped - insufficient insights)

Files committed separately. Ready for use.

Recommended next steps:
1. Review generated docs for accuracy
2. Use during first week to validate effectiveness
3. Add incremental insights as needed
4. Run `/maintain-context-tree` after 1-2 weeks (drift-detector, learning-capture, memory-promoter)
```

---

## Remember

**Quality over quantity.** It's better to have one excellent 100-line doc than four mediocre 200-line docs filled with generic content.

**No generic slop.** Every line must provide value that AI can't easily infer from code.

**This documentation's value comes entirely from Phases 1 & 2.** If those phases didn't yield insights, don't generate fluff to fill docs.

---

**Begin documentation generation now. Quality gates first, then generate.**
