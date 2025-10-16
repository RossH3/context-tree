---
name: Context Tree Maintenance
description: Build, maintain, audit, and validate context trees for brownfield codebases. Use when building initial context trees, auditing documentation for signal-to-noise ratio, capturing insights during development, validating architectural claims against code, performing monthly maintenance checks, removing outdated content, or running automated codebase discovery.
---

# Context Tree Maintenance

## Overview

A **context tree** is a structured documentation architecture that maximizes AI assistant effectiveness when working with codebases. It uses hierarchical CLAUDE.md files and focused reference documents to provide decision-tree-like guidance, connecting business domain knowledge, technical architecture, and implementation patterns.

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
- When correcting architectural documentation, search entire context tree for propagated errors
- Example lesson: Configuration systems are often misunderstood - check the actual code paths

### Bad Context is Worse Than Bad Code

**Outdated or incorrect documentation actively misleads and compounds errors.**

- Bad code: Can be debugged, identified through testing, fixed incrementally
- Bad context: Silently trains AI assistants incorrectly, compounds errors, erodes trust
- **Maintenance priority**: Context tree maintenance is as critical as code maintenance
- **Rule**: Fix inconsistencies immediately when discovered

### Single Source of Truth for Architectural Facts

**Architectural facts must have ONE authoritative location to prevent documentation drift.**

- Core architecture → `docs/ARCHITECTURE.md`
- Technology stack versions → `docs/ARCHITECTURE.md`
- Business workflows → `docs/BUSINESS_CONTEXT.md`
- Configuration patterns → `docs/CONFIGURATION.md`
- **Rule**: Other documents reference the source of truth, NEVER duplicate it
- **When adding facts**: Check if they already exist elsewhere first

### Hard vs Soft Context Separation

**Focus on semantic meaning that complements structural analysis.**

- **Hard Context** (Language Server Domain): Symbols, types, imports, syntax - don't document this
- **Soft Context** (Context Tree Domain): Business logic, design decisions, gotchas, institutional knowledge
- **Example**:
  - ❌ Don't document: `class Order extends Model` (visible in code)
  - ✅ Do document: "Orders represent student applications - search for Order not Application" (institutional knowledge)

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

❌ **"I'll add this insight to my notes and document it later"**
→ NO. You'll forget. Capture NOW while context is fresh.
→ **Correct action**: STOP current work, add insight immediately, commit.

**Commitment Device**: Before documenting anything, announce: "I'm verifying [claim] against code at [file:line]"

## Building Initial Context Tree

### Phase 1: Automated Discovery (15-20 minutes)

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

### Phase 2: Domain Expert Interview (30-60 minutes)

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

### Phase 3: Generate Core Files (45-60 minutes)

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

### Phase 4: Validation (1-2 weeks)

**Test context tree effectiveness with real tasks.**

1. Give AI assistant a real debugging task using only the context tree
2. Give AI assistant a feature implementation task
3. Identify what information was missing (add it)
4. Note what information was present but unused (candidate for removal)

**Iterate based on gaps discovered.**

## Capturing Insights During Development

**This is where high-value context emerges - capture it immediately.**

### When to Capture

**During normal development, STOP and capture context when you discover:**
- Terminology that differs between UI/code/database
- Architectural pattern that isn't obvious from code structure
- Business rule that explains why code is structured a certain way
- Version-specific gotcha or workaround
- Common mistake or confusion point
- Non-obvious dependency or integration pattern

**Commitment Device**: When you discover an insight, announce:
"STOP - I've discovered [insight]. Capturing to [filename] before continuing."

### Where to Add Insights

**Follow single-source-of-truth principle:**

- **Terminology mapping** → `docs/GLOSSARY.md`
- **Architectural fact** → `docs/ARCHITECTURE.md` (or check if it already exists there)
- **Business rule** → `docs/BUSINESS_CONTEXT.md`
- **Framework-specific pattern** → `docs/[FRAMEWORK]_REFERENCE.md` (e.g., `PLAY_2.0.4_REFERENCE.md`)
- **Common mistake** → `docs/TROUBLESHOOTING.md` or relevant CLAUDE.md decision tree
- **Critical pattern** → Root `CLAUDE.md` (if project-wide) or subdirectory `CLAUDE.md` (if scoped)

### How to Add Insights

**Keep it concise and actionable:**

```markdown
## [Section name]

[Specific pattern or gotcha]

**Example:**
```code
[Actual code snippet if helpful]
```

**Common mistake:** [What developers do wrong]
**Correct approach:** [What to do instead]
```

**Commit immediately with clear message describing the insight captured.**

## Validating & Pruning

**Continuous quality control is essential.**

### Validation Process

**Run these checks regularly (monthly or when major changes occur):**

**Commitment Device**: Announce at start: "I'm validating the context tree against actual code."

1. **Architectural accuracy check**
   - Pick 3 architectural claims from `ARCHITECTURE.md`
   - Find actual code that implements each claim
   - Verify claims match implementation
   - **Announce**: "Verifying [claim] at [file:line]"
   - If mismatch: Fix immediately and search for propagated errors

2. **Terminology accuracy check**
   - Pick 3 terms from `GLOSSARY.md`
   - Grep codebase for actual usage
   - Verify mappings are correct
   - **Announce**: "Verifying term '[term]' with grep"
   - If mismatch: Fix immediately

3. **Effectiveness test**
   - Give AI assistant a task using only context tree
   - Note what information was missing (add it)
   - Note what information was unused (candidate for removal)
   - Note what information was incorrect (fix immediately)

### Pruning Low-Value Content

**Remove content that doesn't justify its token cost.**

**Candidates for removal:**
- Generic framework explanations ("MVC separates concerns...")
- Information derivable from code structure (file listings, class hierarchies)
- Verbose examples that don't add clarity
- Outdated information
- Duplicate information (consolidate to single source of truth)
- Speculative future architecture (document what exists, not what might be)

**Rule: When in doubt about removing content, test without it. If AI assistant can still complete tasks effectively, remove it.**

**Commitment Device**: Before removing content, announce:
"Testing if context tree works without [section]. If task succeeds, I'll remove it."

### Handling Architectural Changes

**When code changes, context tree must change.**

1. **During development**: Update context tree on the same branch as code changes
2. **Before committing code**: Review if any architectural facts changed
3. **If facts changed**: Update source-of-truth document + search for cross-references
4. **Commit documentation with code**: Keep them synchronized

## Maintenance Patterns

### Regular Maintenance Tasks

**Weekly (during active development):**
- Capture insights discovered during work
- Update terminology mappings if new terms emerge
- Fix any incorrect information discovered

**Monthly:**
- Validation pass (architectural accuracy check)
- Pruning pass (remove low-value content)
- Effectiveness test (AI assistant task with context tree)

**After major refactoring:**
- Update architectural claims
- Search entire context tree for propagated changes
- Update decision trees if patterns changed

### When Adding New Documentation

1. **Check for existing content**: Don't duplicate - reference or consolidate
2. **Choose correct location**: Follow single-source-of-truth principle
3. **Update navigation**: Add reference in appropriate CLAUDE.md
4. **Cross-reference**: Link from related documents
5. **Verify accuracy**: Check claims against actual code
6. **Commit with code**: Documentation updates merge with related code changes

### Merge-Friendly Practices

**The hierarchical structure minimizes conflicts:**
- Work within relevant directory's CLAUDE.md to minimize conflicts
- Commit documentation with related code changes (atomic commits)
- Review cross-references after merging branches
- Use clear commit messages for both code and doc changes

## Verification Checklist

### Is Your Context Tree Working?

**Answer these questions:**

✅ **Signal-to-noise**: Can you read any section and find unique, non-obvious insights? (Not generic framework info)

✅ **Accuracy**: Do architectural claims match actual code implementation?

✅ **Terminology**: Are UI ↔ code ↔ database mappings complete and correct?

✅ **Effectiveness**: Can AI assistant complete tasks using context tree without extensive additional explanation?

✅ **Maintenance**: Is context tree updated alongside code changes?

✅ **Discovery**: Can developers find relevant information quickly via decision trees?

✅ **No duplication**: Do architectural facts exist in only one location?

### Red Flags (Fix Immediately)

❌ **Generic content**: Sections explaining how MVC works, what REST is, etc.

❌ **Outdated information**: Claims that don't match current code

❌ **Duplicate facts**: Same architectural claim in multiple files

❌ **Unverified claims**: Architecture documented from assumptions, not code verification

❌ **Unused content**: Information present but never referenced during actual work

❌ **Missing terminology**: Developers repeatedly confused by terms not in GLOSSARY

## Summary: Core Workflow

**Building:**
1. Automated discovery → Review with domain expert
2. Focused interview (quality over quantity)
3. Generate core files (verify against code)
4. Test with real tasks → Iterate

**Maintaining:**
1. Capture insights immediately when discovered
2. Validate architectural claims against code regularly
3. Prune low-value content ruthlessly
4. Update alongside code changes
5. Test effectiveness monthly

**Remember:**
- Signal-to-noise ratio is the primary quality metric
- Bad context is worse than bad code
- Verify architectural claims against actual code, always
- Every line must justify its token cost
- Commit context tree changes with code changes
- Announce your actions (commitment device)

---

*This skill focuses on curation and quality control - the hard part of context trees. Generation is easy; maintaining high signal-to-noise ratio is what matters.*
