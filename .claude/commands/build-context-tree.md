# Build Context Tree (Orchestrated Workflow)

**Purpose:** AI onboarding tool for brownfield codebases with domain expert interview

**Overview:** This orchestrator runs 3 phases sequentially, with checkpoints between each phase for resumability.

---

## Workflow

### Phase 1: Codebase Discovery (15-20 min)
**Goal:** Explore codebase to gather context for intelligent interview questions

**Subagent:** `.claude/orchestrators/context-tree-builder/codebase-discovery.md`

**Output:** `docs/context-tree-build/discovery_summary.json`

**Resume:** If discovery_summary.json exists, ask user whether to skip or re-run

---

### Phase 2: Domain Expert Interview (30-60 min) ⭐ THE KEY DIFFERENTIATOR
**Goal:** Interactive Q&A with domain expert to capture institutional knowledge

**Subagent:** `.claude/orchestrators/context-tree-builder/domain-interview.md`

**Input:** `docs/context-tree-build/discovery_summary.json`

**Output:** `docs/context-tree-build/interview_notes.json` (incremental updates)

**Resume:** If interview_notes.json exists, continue from where it left off

---

### Phase 3: Documentation Generation (30-45 min)
**Goal:** Generate high-quality docs from discovery and interview insights

**Subagent:** `.claude/orchestrators/context-tree-builder/doc-generator.md`

**Inputs:**
- `docs/context-tree-build/discovery_summary.json`
- `docs/context-tree-build/interview_notes.json`

**Outputs (conditional based on quality):**
- `CLAUDE.md` (always - navigation hub)
- `docs/GLOSSARY.md` (only if ≥3 verified terminology mappings)
- `docs/ARCHITECTURE.md` (only if ≥3 non-obvious patterns)
- `docs/BUSINESS_CONTEXT.md` (only if ≥3 business insights)

**Resume:** If final docs exist, ask user whether to regenerate

---

## Execution Instructions

You are the orchestrator. Your job is to:

1. **Check for existing checkpoints** in `docs/context-tree-build/`:
   - If `discovery_summary.json` exists: Ask user if they want to skip Phase 1
   - If `interview_notes.json` exists: Ask user if they want to skip/resume Phase 2
   - If final docs exist: Ask user if they want to skip Phase 3

2. **Execute phases sequentially:**
   ```
   Phase 1: Spawn subagent with codebase-discovery.md
   [Wait for completion]

   Phase 2: Spawn subagent with domain-interview.md
   [Wait for completion - may take multiple sessions]

   Phase 3: Spawn subagent with doc-generator.md
   [Wait for completion]
   ```

3. **After completion:**
   - Report summary of generated files
   - Remind user to commit checkpoint JSON files and final docs
   - Suggest validation during first week of use

---

## Core Principles (enforced in all phases)

1. **Verify against code** - Never trust docs, always verify
2. **Signal-to-noise ratio** - Every line must justify token cost
3. **No generic slop** - Only document what AI can't easily infer
4. **Resumable** - Can stop and continue at checkpoint boundaries
5. **Quality gates** - Don't generate docs without substantial content

---

## Important Notes

- Checkpoint files (`docs/context-tree-build/*.json`) should be committed to git
- Phase 2 (interview) is the unique value - take time to do it well
- Phase 3 quality gates prevent generic documentation
- This can span multiple sessions - checkpoints enable resuming

---

**Begin orchestration now.**
