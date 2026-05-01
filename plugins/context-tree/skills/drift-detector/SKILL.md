---
name: drift-detector
description: Validate Context Tree documentation claims against actual code, detect drift, and prune stale or incorrect content. Use when the user asks to audit documentation quality, check whether docs are still accurate, or validate architectural claims. Also activates as part of /maintain-context-tree.
---

# Drift Detector

## Purpose

Documentation drifts. Code changes; docs don't. **Bad context is worse than bad code** — it silently trains AI wrong and compounds errors. This skill validates Context Tree claims against actual code, fixes mismatches, and prunes content that no longer holds.

---

## Execution

### 1. Audit CLAUDE.md (root)

```
Auditing CLAUDE.md...

✅ Under 200 lines (current: 156)
✅ No generic framework explanations
⚠️ Claim: "Redis stores sessions" (line 78)
   Verifying... grep -r "session" config/
   ❌ Incorrect — sessions use cookies, not Redis

   Fix now? (y/n)
```

For every claim in CLAUDE.md:
- Grep for relevant patterns
- Read implementation files
- If claim matches code → mark verified, update `verified:` frontmatter date
- If claim contradicts code → show diff, offer to fix
- If claim cannot be verified → flag as "unverified" or remove

### 2. Audit each `docs/*.md` file

Same protocol. Architectural claims, terminology mappings, business rules, file:line references — all checked.

For terminology files (GLOSSARY.md): verify both UI and code terms exist in their claimed contexts.

For architecture files (ARCHITECTURE.md): verify patterns still exist in the code as described.

### 3. Detect duplicates

Same fact in multiple places violates single-source-of-truth. Suggest consolidation; reference, don't duplicate.

### 4. Prune low-value content

Remove:
- Generic framework explanations ("Rails uses routes for HTTP routing")
- Code-derivable facts ("UserController handles user operations")
- Verbose examples without insight
- Sections that haven't been referenced and aren't critical

### 5. Update frontmatter

For docs that were verified during this audit, update the `verified:` date in the frontmatter.

### 6. Summary

```
Drift Audit Complete

Fixed: 1 incorrect claim (Redis usage)
Added: 1 missing terminology mapping (Process)
Removed: 0 sections
Verified: 12 existing claims (frontmatter timestamps refreshed)

Commit? (y/n)
```

Commit: `docs: audit context tree against code, fix drift`

---

## Common Rationalizations to Reject

- ❌ "I'll verify this architectural claim later" → NO. Verify NOW.
- ❌ "This might be outdated but I'll leave it" → NEVER. Fix or delete.
- ❌ "I'll find single source of truth later" → NO. Don't add duplicates.

---

## Core Principles

- **Verify against code** — never trust the doc you're auditing
- **Bad context is worse than bad code** — fix or delete; never leave stale content
- **Single source of truth** — consolidate duplicates as you find them
- **Frontmatter `verified:` date** — refresh after each audit so freshness is visible

---

**Run when:** `/maintain-context-tree` (option 2), or whenever the user asks to audit, validate, or quality-check existing Context Tree docs.
