---
name: drift-detector
description: Validate Context Tree documentation claims against actual code, detect drift, and prune stale or incorrect content. By default it audits only docs whose referenced code changed since they were last checked. Use when the user asks to audit documentation quality, check whether docs are still accurate, or validate architectural claims. Also activates as part of /maintain-context-tree.
---

# Drift Detector

## Purpose

Documentation drifts. Code changes; docs don't. **Bad context is worse than bad code** — it silently trains AI wrong and compounds errors. This skill validates Context Tree claims against actual code, fixes mismatches, and prunes content that no longer holds.

---

## Execution

### 0. Scope the audit

Don't re-check everything by default. Concentrate on docs whose code has changed since they were last checked; stable code rarely makes docs wrong.

**Default (scoped) audit:**

1. **Root `CLAUDE.md` is always in scope.** It's loaded into every session, so a wrong claim there spreads everywhere. It's also short.
2. For each `docs/*.md` (and nested `CLAUDE.md`), find when it was last checked:
   - the `verified:` frontmatter date, if present
   - otherwise the date of the last commit that touched the doc: `git log -1 --format=%cs -- <doc>`
3. List the code paths the doc references (`path/file.ext`, `path/file.ext:42`, backticked paths that exist in the repo).
4. Check whether any of them changed since that date:
   ```bash
   git log --since=<date> --format=%h -- <path1> <path2> ... | head -1
   ```
5. Sort each doc into one bucket:
   - **Changed**: a referenced path has commits since the last check. Audit it.
   - **Missing refs**: a referenced path no longer exists. Audit it first; something moved or was deleted.
   - **Unanchored**: no resolvable code references. Can't be scoped. List it; audit only on a full sweep or if the user asks.
   - **Stable**: nothing referenced has changed. Skip it, and say so in the summary.
6. Show the buckets before auditing:
   ```
   Audit scope (since each doc's last check)
   Always:      CLAUDE.md
   Missing refs: docs/CACHING.md (app/util/CacheHelper.java gone)
   Changed:     docs/DATA_FLOWS.md (12 commits), docs/EMAIL.md (2 commits)
   Unanchored:  docs/BUSINESS_CONTEXT.md, docs/GLOSSARY.md
   Stable:      14 docs skipped

   Audit the 4 in-scope docs? (y / full sweep / pick)
   ```

**Full sweep** (every doc): run when the user asks, after a framework upgrade or major rewrite, or when a tree is being handed to another team.

Steps 1–4 below apply to the in-scope docs.

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

### 2. Audit each in-scope `docs/*.md` file

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

Scope: 4 docs audited, 14 stable docs skipped, 2 unanchored not checked
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
- **Frontmatter `verified:` date** — refresh after each audit so freshness is visible; it's also what scopes the next audit
- **Check what changed** — scoped by default; a full sweep is a deliberate choice, not the habit

---

**Run when:** `/maintain-context-tree` (option 2), or whenever the user asks to audit, validate, or quality-check existing Context Tree docs.
