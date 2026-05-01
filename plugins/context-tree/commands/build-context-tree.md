# Build Context Tree (Orchestrated Workflow)

**Purpose:** AI onboarding tool for brownfield codebases with domain expert interview

**Overview:** This orchestrator runs 3 phases sequentially, with markdown checkpoints between each phase for resumability.

---

## Workflow

### Phase 1: Codebase Discovery (15-20 min)
**Goal:** Explore codebase to gather context for intelligent interview questions

**Subagent:** `${CLAUDE_PLUGIN_ROOT}/docs/workflow-prompts/codebase-discovery.md`

**Output:** `docs/context-tree-build/discovery.md`

**Resume:** If discovery.md exists, ask user whether to skip or re-run

---

### Phase 2: Domain Expert Interview (30-60 min) ⭐ THE KEY DIFFERENTIATOR
**Goal:** Interactive Q&A with domain expert to capture institutional knowledge

**Subagent:** `${CLAUDE_PLUGIN_ROOT}/docs/workflow-prompts/domain-interview.md`

**Input:** `docs/context-tree-build/discovery.md`

**Output:** `docs/context-tree-build/interview.md` (append-only with summary tracking)

**Resume:** If interview.md exists, read summary section and continue from next category

---

### Phase 3: Documentation Generation (30-45 min)
**Goal:** Generate high-quality docs from discovery and interview insights

**Subagent:** `${CLAUDE_PLUGIN_ROOT}/docs/workflow-prompts/doc-generator.md`

**Inputs:**
- `docs/context-tree-build/discovery.md`
- `docs/context-tree-build/interview.md`

**Outputs (conditional based on quality):**
- `CLAUDE.md` (always - navigation hub, with v4 frontmatter)
- `docs/GLOSSARY.md` (only if ≥3 verified terminology mappings)
- `docs/ARCHITECTURE.md` (only if ≥3 non-obvious patterns)
- `docs/BUSINESS_CONTEXT.md` (only if ≥3 business insights)
- `knowledge.yaml` (only if ≥4 docs total — optional KCP routing manifest)

**Resume:** If final docs exist, ask user whether to regenerate

---

## Execution Instructions

You are the orchestrator. Your job is to:

1. **Check for existing checkpoints** in `docs/context-tree-build/`:
   - If `status.md` exists: Read to determine current phase and resumability
   - If `discovery.md` exists: Ask user if they want to skip Phase 1
   - If `interview.md` exists: Read summary section to resume Phase 2 from correct category
   - If final docs exist: Ask user if they want to skip Phase 3

2. **Execute phases sequentially:**
   ```
   Phase 1: Spawn subagent with codebase-discovery.md
   [Wait for completion → discovery.md created]
   [Update status.md: Phase 1 complete]

   Phase 2: Spawn subagent with domain-interview.md
   [Wait for completion - may take multiple sessions]
   [interview.md appends Q&As with summary section for resumability]
   [Update status.md: Phase 2 complete]

   Phase 3: Spawn subagent with doc-generator.md
   [Wait for completion → final docs generated]
   [Update status.md: Phase 3 complete]
   ```

3. **After each phase:**
   - Update `docs/context-tree-build/status.md` with progress
   - Commit working files with clear messages
   - Show readable progress to user

4. **After completion:**
   - Report summary of generated files
   - Remind user to commit working files and final docs
   - Suggest validation during first week of use
   - Note: Working files can be kept or removed after docs are validated

---

## Status Tracking (status.md)

The `status.md` file tracks workflow state for resumability:

```markdown
# Context Tree Build - Status

**Started:** [timestamp]
**Last Updated:** [timestamp]

---

## Phase Progress

- [x] Phase 1: Discovery *(completed)*
- [ ] Phase 2: Interview *(in progress)*
- [ ] Phase 3: Documentation Generation

---

## Current State

**Active Phase:** 2 - Interview
**Can Resume:** Yes
**Next Action:** Continue interview from Business Context category

---

## Files Generated

- [ ] CLAUDE.md
- [ ] docs/GLOSSARY.md
- [ ] docs/ARCHITECTURE.md
- [ ] docs/BUSINESS_CONTEXT.md
```

Update this file after each phase completion.

---

## Resumability with Markdown

### How It Works

**Phase 1 (Discovery):**
- Checkpoint: `discovery.md` exists
- Resume: Ask to skip or re-run

**Phase 2 (Interview):**
- Checkpoint: `interview.md` with summary section
- Resume: Read summary → shows questions asked, categories complete, next category
- Continue: Append new Q&As to file, update summary after each session

**Phase 3 (Generation):**
- Checkpoint: Final docs exist
- Resume: Ask to regenerate or skip

### Reading Summary for Resumability

interview.md has structured format:
```markdown
## Interview Session 1
[Q&As...]

## Interview Session 2
[Q&As...]

## Interview Summary
**Total Questions Asked:** 12
**Categories Completed:** Terminology, Architecture
**Categories Remaining:** Business Context, Pitfalls
**Status:** Can resume - continue with Business Context
```

Parse the summary section to determine where to continue.

---

## Core Principles (enforced in all phases)

1. **Verify against code** - Never trust docs, always verify
2. **Signal-to-noise ratio** - Every line must justify token cost
3. **No generic slop** - Only document what AI can't easily infer
4. **Resumable** - Can stop and continue at checkpoint boundaries
5. **Quality gates** - Don't generate docs without substantial content

---

## Working Files

**Location:** `docs/context-tree-build/`

**Files created:**
- `status.md` - Workflow state and progress tracking
- `discovery.md` - Phase 1 findings (human-readable)
- `interview.md` - Phase 2 Q&A (append-only, with summary)

**Benefits of markdown format:**
- Human-readable git diffs (reviewable in PRs)
- Easy to scan and verify progress
- Can manually edit if needed
- Clear commit history
- No JSON parsing complexity

**After completion:**
- Working files can be committed to track build process
- Or removed after final docs are validated
- Up to team preference

---

## Important Notes

- Working files (`docs/context-tree-build/*.md`) create readable git history
- Phase 2 (interview) is the unique value - take time to do it well
- Phase 3 quality gates prevent generic documentation
- This can span multiple sessions - markdown checkpoints enable resuming
- Commit after each phase for safety

---

**Begin orchestration now.**
