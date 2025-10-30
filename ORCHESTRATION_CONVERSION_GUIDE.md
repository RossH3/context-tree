# Context Tree Builder: Orchestration Conversion Guide

**Status:** Reference only - not yet implemented
**Created:** 2025-10-30
**Purpose:** Document how to convert context-tree-builder skill from monolithic to orchestrated workflow

---

## Current State

**File:** `skills/context-tree-builder/SKILL.md` (361 lines)
**Pattern:** Monolithic skill with 5 phases executed in one context
**Works well for:** Initial builds, but accumulates context across 2-4 hour sessions

---

## Why Orchestration Could Help

**Context accumulation pattern:**
- Phase 1 (Discovery): Generates 50KB+ of bash output, file listings, pattern analysis
- Phase 2 (Interview): Q&A session, captures institutional knowledge
- Phase 3 (Doc Generation): Needs interview answers but not raw discovery output
- Phase 4 (Validation): Happens days/weeks later, needs docs but not discovery details
- Phase 5 (Subdirectory CLAUDE.md): Scoped context, doesn't need full discovery

**Benefits of orchestration:**
- Compress discovery (50KB bash output → 5KB structured JSON)
- Save checkpoints between phases (resume after interruptions)
- Reusable subagents (discovery pattern works for other brownfield analysis)
- Fresh context for each phase (no accumulated noise)

---

## Proposed Structure

### File Organization

```
.claude/
├── commands/
│   └── build-context-tree.md           # Orchestrator (Ross invokes this)
└── orchestrators/
    └── context-tree-builder/
        ├── codebase-discovery.md        # Subagent 1
        ├── domain-interview.md          # Subagent 2
        ├── doc-generator.md             # Subagent 3
        ├── context-validator.md         # Subagent 4
        └── subdirectory-builder.md      # Subagent 5
```

---

## Orchestrator Flow

**Command:** `/build-context-tree`

**Workflow:**

```
1. Spawn: codebase-discovery
   Input: {project_path: cwd}
   Output: docs/context-tree-build/discovery_summary.json
   Context: Discarded after JSON written

2. Spawn: domain-interview
   Input: {discovery_summary: <from step 1>}
   Output: docs/context-tree-build/interview_notes.json
   Context: Discarded after JSON written

3. Spawn: doc-generator
   Input: {discovery_summary, interview_notes}
   Output: CLAUDE.md, docs/GLOSSARY.md, docs/ARCHITECTURE.md, docs/BUSINESS_CONTEXT.md
   Context: Discarded after files written

4. [PAUSE - Validation happens during first 1-2 weeks of use]

5. Spawn: context-validator (on-demand: /validate-context-tree)
   Input: {context_docs: docs/*.md}
   Output: docs/context-tree-build/validation_report.json

6. Spawn: subdirectory-builder (on-demand: /add-subdirectory-context)
   Input: {directory: <arg>, root_context: CLAUDE.md}
   Output: <directory>/CLAUDE.md
```

---

## Subagent Responsibilities

### 1. codebase-discovery.md
**Job:** Run automated discovery commands, analyze codebase structure

**Tasks:**
- Run all bash commands from current discovery-commands.md
- Detect tech stack, database, architecture patterns
- Identify entry points, routes, key directories
- Analyze existing documentation

**Output:** `discovery_summary.json`
```json
{
  "tech_stack": {
    "framework": "Rails 5.2.8",
    "language": "Java",
    "build_tool": "SBT"
  },
  "architecture": {
    "pattern": "MVC",
    "multi_tenant": true,
    "databases": ["PostgreSQL", "Redis"]
  },
  "entry_points": ["conf/routes", "app/Global.java"],
  "key_directories": ["app/controllers", "app/models", "app/views"],
  "existing_docs": ["README.md"],
  "gotchas": ["Legacy framework version", "Dual database pattern"]
}
```

**Critical principles:**
- Verify claims against code (not docs)
- Focus on non-obvious patterns
- Keep signal-to-noise ratio high

---

### 2. domain-interview.md
**Job:** Ask focused questions to capture institutional knowledge

**Tasks:**
- Load discovery_summary.json for context
- Ask questions from current Phase 2
- Adapt questions based on discovery findings
- Push for specific examples, not generic answers

**Output:** `interview_notes.json`
```json
{
  "business_context": {
    "purpose": "Multi-tenant SaaS for school choice applications",
    "users": ["District admins", "Parents", "School staff"],
    "core_workflow": ["Create process", "Parents apply", "Lottery run", "Results distributed"]
  },
  "terminology_traps": [
    {"ui_term": "Application", "code_term": "Order", "db_term": "order", "note": "Search for Order not Application"}
  ],
  "architectural_gotchas": [
    {"pattern": "Multi-tenant by hostname", "enforcement": "clientid = request().host()"}
  ],
  "pain_points": [
    "Explaining dual database pattern takes longest",
    "New devs always forget clientid filter"
  ]
}
```

**Critical principles:**
- Verify answers against code immediately
- Capture specific examples, not generics
- Focus on what takes longest to explain

---

### 3. doc-generator.md
**Job:** Generate core documentation files

**Tasks:**
- Read discovery_summary.json + interview_notes.json
- Generate root CLAUDE.md (navigation hub)
- Generate docs/GLOSSARY.md (terminology mappings)
- Generate docs/ARCHITECTURE.md (tech stack, patterns)
- Generate docs/BUSINESS_CONTEXT.md (domain knowledge)
- Verify architectural claims against code
- Commit files as created

**Output:** Documentation files created + commit messages

**Critical principles:**
- Single source of truth for architectural facts
- Every line must justify token cost
- No generic framework explanations
- Cross-reference between docs, never duplicate

---

### 4. context-validator.md
**Job:** Test context tree effectiveness (run during first 1-2 weeks)

**Tasks:**
- Give AI assistant a real debugging task using only context tree
- Give AI assistant a feature implementation task
- Identify missing information (add it)
- Note unused information (candidate for removal)
- Generate validation report

**Output:** `validation_report.json`
```json
{
  "gaps_found": [
    "Missing: How to add new controller",
    "Missing: Database migration process"
  ],
  "unused_content": [
    "Section on SBT tasks - never referenced"
  ],
  "effectiveness_score": 8,
  "recommendations": ["Add controller creation pattern", "Remove SBT section"]
}
```

---

### 5. subdirectory-builder.md
**Job:** Create scoped CLAUDE.md for specific directories (on-demand)

**Tasks:**
- Analyze target directory structure
- Identify patterns and conventions
- Generate directory-scoped CLAUDE.md
- Link to root documentation

**Output:** `<directory>/CLAUDE.md`

---

## Checkpoint Files

Orchestration creates persistent checkpoints in `docs/context-tree-build/`:

```
docs/context-tree-build/
├── discovery_summary.json      # Phase 1 output
├── interview_notes.json        # Phase 2 output
└── validation_report.json      # Phase 4 output
```

**Benefits:**
- Resume after interruptions
- Skip phases if already completed
- Review/edit phase outputs before continuing
- Audit trail of build process

---

## Commands

### Primary Command
```bash
/build-context-tree
```
Runs full orchestrated workflow (Phases 1-3)

### Phase-Specific Commands
```bash
/build-context-tree --discover-only        # Run Phase 1 only
/build-context-tree --resume-at=interview  # Skip to Phase 2
/build-context-tree --resume-at=docs       # Skip to Phase 3
/validate-context-tree                     # Run Phase 4
/add-subdirectory-context app/controllers  # Run Phase 5 for specific dir
```

---

## Comparison: Before vs After

### Before (Monolithic)
- 1 file: 361 lines
- All phases in one context
- Context accumulates: ~150KB by Phase 3
- Interruptions = restart from beginning
- Works well for: Single-session builds

### After (Orchestrated)
- 6 files: ~400 lines total
- Each phase has fresh context
- Orchestrator context: ~10KB (just JSON files)
- Interruptions = resume from checkpoint
- Works well for: Multi-session builds, repeated use

---

## Implementation Steps

When ready to implement:

1. **Create orchestrator structure:**
   - `.claude/commands/build-context-tree.md` (main orchestrator)
   - `.claude/orchestrators/context-tree-builder/` (directory for subagents)

2. **Extract Phase 1 → codebase-discovery.md:**
   - Copy discovery commands from current SKILL.md
   - Add JSON output format
   - Add file write to `docs/context-tree-build/discovery_summary.json`

3. **Extract Phase 2 → domain-interview.md:**
   - Copy interview questions from current SKILL.md
   - Add discovery_summary.json as input
   - Add JSON output format
   - Add file write to `docs/context-tree-build/interview_notes.json`

4. **Extract Phase 3 → doc-generator.md:**
   - Copy doc generation logic from current SKILL.md
   - Add checkpoint files as input
   - Keep all verification principles
   - Add commit after each file

5. **Extract Phase 4 → context-validator.md:**
   - Copy validation logic from current SKILL.md
   - Add effectiveness testing
   - Generate validation report

6. **Extract Phase 5 → subdirectory-builder.md:**
   - Copy subdirectory logic from current SKILL.md
   - Make it target-directory aware

7. **Test orchestrator:**
   - Run on a small test project
   - Verify checkpoint files are created
   - Test resume functionality
   - Compare output quality to monolithic version

8. **Keep both versions:**
   - Move current SKILL.md to `skills/context-tree-builder-monolithic/SKILL.md`
   - Keep orchestrated version as primary
   - Use monolithic for quick, single-session builds
   - Use orchestrated for complex, multi-session builds

---

## Decision Criteria

**Use orchestrated version when:**
- Build will span multiple sessions (2-4 hours interrupted)
- Running on complex brownfield codebases (10K+ lines)
- Want to review/edit phase outputs before continuing
- Building context trees repeatedly (3+ projects)

**Use monolithic version when:**
- Can complete in one sitting
- Small codebase (< 5K lines)
- One-off context tree build
- Already familiar with the codebase

---

## Open Questions

- Should orchestrator auto-detect interruptions and resume?
- Should checkpoint JSON files be gitignored or committed?
- Should validation be triggered automatically after 1 week?
- Should doc-generator verify ALL architectural claims or sample?

---

## References

- Current monolithic skill: `skills/context-tree-builder/SKILL.md`
- Principles document: `CONTEXT_TREE_PRINCIPLES.md`
- Field guide: `AI_DOCUMENTATION_FIELD_GUIDE.md`

---

**Note:** This is a reference document. The current monolithic skill works well. Only implement orchestration if context management becomes painful during actual use.
