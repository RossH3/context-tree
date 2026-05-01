---
name: tree-health
description: Quick structural health check on a Context Tree - validate links, file sizes, frontmatter presence, knowledge.yaml routing entries, and overall tree shape. Use when the user asks for a quick context tree health check, or before/after restructuring. Also activates as part of /maintain-context-tree.
---

# Tree Health

## Purpose

Lightweight structural validation. Catches broken links, oversized files, missing frontmatter, and routing-manifest drift before they cause problems. Fast (~2 minutes); no deep code verification.

For deep claim-vs-code validation, use `drift-detector` instead.

---

## Execution

### 1. File structure

```
✅ CLAUDE.md exists at root
✅ docs/ directory present
✅ Working files in docs/context-tree-build/ (or absent — both fine)
```

### 2. Cross-references

- Walk every internal link in CLAUDE.md and docs/*.md
- Walk every file:line reference
- Report broken targets

```
Cross-References:
✅ All internal links valid (23 checked)
⚠️ 2 broken file references:
   - docs/ARCHITECTURE.md:45 → app/services/PaymentService.java (file moved)
```

### 3. File sizes (signal-to-noise heuristic)

- CLAUDE.md target: under 200 lines (warn if over 250)
- Each doc/*.md target: under 300 lines (warn if over 400)
- Oversized = candidate for splitting or pruning

**Chunking awareness:** Before warning on an oversized doc, check `knowledge.yaml` (if present). If the doc appears in **multiple units** (i.e., it has been chunked into routing entries — same `path:` value, different `id:` and `intent:`), do **not** warn on size — chunking is the v3+ mitigation strategy and the doc is already routed by section. Report it as `chunked into N units` instead of as a warning.

Example detection in pseudocode:
```
chunk_counts = group_by(units, key=path).count()
for each oversized doc:
    if chunk_counts[doc.path] >= 2:
        report as "✓ chunked (N units)" — not a warning
    else:
        report as "⚠ oversized, not chunked — candidate for split"
```

Real cases this catches: `DATA_FLOWS.md` (2407 lines, 7 units), `TROUBLESHOOTING.md` (1827 lines, 6 units). Both are working as designed; warning on raw line count creates a false positive.

### 4. Frontmatter presence

For trees built with v4+, every generated doc should have frontmatter:

```yaml
---
name: ...
description: ...
type: reference
scope: repo
source: build|ingest|interview|promoted-from-memory
verified: YYYY-MM-DD
---
```

Report docs missing frontmatter. Don't auto-add — flag for the user (frontmatter on legacy docs needs the user to decide source/type).

### 5. knowledge.yaml routing manifest (if present)

- Every unit listed has a corresponding file
- Every doc file has a unit (or is intentionally excluded — e.g., working files)
- `validated:` dates not too stale (warn if older than 90 days)

### 6. Staleness signal

```
⚠️ Last update 45 days ago
   Run rule-of-two-detector for new patterns
   Run drift-detector to validate claims still hold
```

### 7. Report

```
Tree Health Complete

Status: Good
Critical issues: 0
Warnings: 2
- docs/ARCHITECTURE.md has 2 broken file references
- docs/ARCHITECTURE.md is 287 lines (approaching 300-line warning)

Recommended next step: Run drift-detector to validate ARCHITECTURE claims.
```

---

## What This Skill Does NOT Do

- Does **not** verify whether claims are true (that's `drift-detector`)
- Does **not** look at git history (that's `rule-of-two-detector`)
- Does **not** harvest insights (that's `learning-capture` or `memory-promoter`)

Stay narrow. Health is structural, not semantic.

---

**Run when:** `/maintain-context-tree` (option 3), or whenever the user wants a fast structural check, or after restructuring.
