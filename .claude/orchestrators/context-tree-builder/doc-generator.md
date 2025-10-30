# Phase 3: Documentation Generation

**Purpose:** Generate high-quality documentation from discovery and interview insights

**Time:** 30-45 minutes

**Inputs:**
- `docs/context-tree-build/discovery_summary.json`
- `docs/context-tree-build/interview_notes.json`

**Outputs (conditional):**
- `CLAUDE.md` (always - navigation hub)
- `docs/GLOSSARY.md` (only if ≥3 verified terminology mappings)
- `docs/ARCHITECTURE.md` (only if ≥3 non-obvious patterns)
- `docs/BUSINESS_CONTEXT.md` (only if ≥3 business insights)

---

## ⚠️ CRITICAL: No Generic Slop

**Quality over quantity.** This phase has strict quality gates.

**Only generate a document if you have substantial, non-obvious content.**

Generic framework explanations, obvious code patterns, and filler content are **worse than no documentation**.

---

## Your Mission

Transform the raw insights from Phases 1 & 2 into concise, high-signal documentation:

1. **Load checkpoint files** - Read both JSON files
2. **Assess quality** - Count high-value insights in each category
3. **Apply quality gates** - Only generate docs that pass thresholds
4. **Generate docs** - Following strict signal-to-noise principles
5. **Verify claims** - Cross-check against actual code
6. **Commit incrementally** - One commit per file generated

---

## Step 1: Load and Assess

### Read Checkpoint Files

```bash
discovery_summary.json - Phase 1 output
interview_notes.json - Phase 2 output
```

### Count High-Value Insights

Tally insights by category:

**Terminology Traps:**
- Count items from `discovery_summary.json.terminology_discovered`
- Count Q&As from `interview_notes.json` with `category: "terminology"` and `value_for_docs: "high"`
- **Quality gate:** Need ≥3 verified mappings for GLOSSARY.md

**Architectural Patterns:**
- Count items from `discovery_summary.json.gotchas_identified`
- Count non-obvious patterns from `discovery_summary.json.architecture`
- Count Q&As with `category: "architecture"` and `value_for_docs: "high" or "critical"`
- **Quality gate:** Need ≥3 non-obvious patterns for ARCHITECTURE.md

**Business Insights:**
- Count Q&As with `category: "business_context"` and `value_for_docs: "high"`
- Count workflow descriptions
- Count business rules
- **Quality gate:** Need ≥3 substantial insights for BUSINESS_CONTEXT.md

**Common Pitfalls:**
- Count Q&As with `category: "pitfalls"`
- Count items from `discovery_summary.json.confusing_areas`
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
- Dual database pattern with specific roles (Cassandra=truth, ES=query)
- Legacy version constraints with business reasons
- Security-critical patterns (must filter by clientid)
- Terminology where UI ≠ code ≠ DB

**❌ Obvious (exclude):**
- "This is an MVC application" (structure shows this)
- "UserController handles user operations" (name shows this)
- "We use Java" (file extensions show this)
- Generic framework explanations ("Play uses routes file for URLs")

---

## Step 3: Generate CLAUDE.md (ALWAYS)

**Purpose:** Navigation hub + consolidated insights

**Location:** `CLAUDE.md` (project root)

**Structure:**

```markdown
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

### [Concept 1 - e.g., "Lottery Algorithm"]
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
- **Don't explain frameworks** - No "Play uses routes for HTTP routing"
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
4. Consider running context-tree-maintenance skill after 1-2 weeks
```

---

## Remember

**Quality over quantity.** It's better to have one excellent 100-line doc than four mediocre 200-line docs filled with generic content.

**No generic slop.** Every line must provide value that AI can't easily infer from code.

**This documentation's value comes entirely from Phases 1 & 2.** If those phases didn't yield insights, don't generate fluff to fill docs.

---

**Begin documentation generation now. Quality gates first, then generate.**
