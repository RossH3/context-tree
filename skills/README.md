# Context Tree Skills

## What Are Skills?

Skills are specialized capabilities that extend Claude's effectiveness through organized instructions and resources. Context-tree uses the **official Claude Skills format** introduced in Claude Code 2.0.20.

**Claude Skills format:**
- **SKILL.md** with YAML frontmatter (name, description)
- **Automatic discovery** - Claude loads skills when relevant based on description
- **Portable** - Works across Claude Code, Claude web, and API
- **Composable** - Multiple skills work together seamlessly
- **Progressive disclosure** - Keep SKILL.md under 500 lines, use supporting files for details

Think of skills as **executable best practices** that Claude follows consistently across projects.

## Available Skills

### Context Tree Builder

**Location**: `skills/context-tree-builder/SKILL.md`

**Purpose**: Build initial context tree for brownfield codebases through structured 2-4 hour session

**When to use**:
- Starting a new context tree from scratch
- Initial codebase documentation project
- Setting up AI-optimized documentation for the first time

**Slash commands** (if installed in project):
- `/build-context-tree` - Full build workflow (Phase 1-5)

**Key features**:
- Claude Skills format with automatic discovery
- Structured 5-phase workflow: Discovery → Interview → Generate → Validate → Subdirectories
- SKILL.md + discovery-commands.md reference file
- "Common Rationalizations" section to prevent shortcuts
- Commitment devices for verification discipline
- Templates for all core files (CLAUDE.md, GLOSSARY, ARCHITECTURE, BUSINESS_CONTEXT)
- Subdirectory CLAUDE.md generation
- Signal-to-noise optimization focus

### Context Tree Maintenance

**Location**: `skills/context-tree-maintenance/SKILL.md`

**Purpose**: Maintain, audit, and validate existing context trees for ongoing quality

**When to use**:
- Capturing insights discovered during development
- Auditing existing documentation for signal-to-noise ratio
- Validating architectural claims against code
- Monthly maintenance and quality checks
- Pruning outdated or low-value content
- Updating context tree alongside code changes

**Slash commands** (if installed in project):
- `/audit-context` - Monthly quality audit workflow
- `/capture-insight` - Quick insight capture during development

**Key features**:
- Claude Skills format with automatic discovery
- Structured monthly audit checklist (6 steps)
- "Common Rationalizations" section to prevent shortcuts
- Commitment devices for verification discipline
- Insight capture workflow
- Pruning guidelines
- Signal-to-noise optimization focus

## How Skills Work

### File Structure

**Claude Skills format:**
```
skills/
├── context-tree-builder/
│   ├── SKILL.md                    # Initial build workflow (5 phases)
│   │   ├── YAML frontmatter (name, description)
│   │   ├── Overview
│   │   ├── Critical Principles
│   │   ├── Common Rationalizations
│   │   ├── Phase 1-5 workflows
│   │   ├── Templates for core files
│   │   └── Verification Checklist
│   └── discovery-commands.md       # Supporting file for bash commands
└── context-tree-maintenance/
    └── SKILL.md                    # Ongoing maintenance workflows
        ├── YAML frontmatter (name, description)
        ├── Overview
        ├── Critical Principles
        ├── Common Rationalizations
        ├── Capturing Insights
        ├── Running Quality Audit (6-step checklist)
        ├── Maintenance Patterns
        └── Verification Checklist
```

**Key characteristics:**
- SKILL.md under 500 lines (best practice)
- Progressive disclosure via supporting files
- Automatic discovery via description field
- Clear YAML frontmatter for Claude Code

### Usage

**Automatic discovery** (Claude Skills):
- Claude automatically loads skills based on description keywords
- Builder: "build initial context tree", "brownfield codebase"
- Maintenance: "maintain", "audit", "validate", "capture insights"

**Manual invocation**:
```
Claude, use the Context Tree Builder skill to build docs
Claude, use the Context Tree Maintenance skill to audit the docs
```

**Slash commands** (if installed):
```
/build-context-tree     # Initial build (Builder skill)
/audit-context          # Monthly audit (Maintenance skill)
/capture-insight        # Quick insight (Maintenance skill)
```

## Enhancing Skills

Skills are designed to evolve based on real usage. Here's how to enhance them:

### 1. Add New Sections

When you discover a new workflow or pattern:

```markdown
## New Workflow Name

**When to use this:**
- [Trigger condition 1]
- [Trigger condition 2]

**Steps:**
1. [Step 1 with specific action]
2. [Step 2 with verification]
3. [Step 3 with commitment device]

**Verification:**
- [How to know it worked]
```

### 2. Strengthen Guardrails

If you catch yourself (or Claude) violating a principle, add it to "Common Rationalizations":

```markdown
❌ **"[Excuse you used]"**
→ NO. [Why this is wrong]
→ **Correct action**: [What to do instead]
```

### 3. Add Concrete Examples

Replace generic advice with specific examples from real usage:

**Before:**
```markdown
- Verify architectural claims
```

**After:**
```markdown
- Verify architectural claims
  **Example**: "Cassandra = source of truth" → grep for Cassandra usage, check actual data flow
```

### 4. Update Validation Checklists

As you discover new quality indicators:

```markdown
✅ **New check**: [What to verify]
❌ **New red flag**: [What indicates problems]
```

### 5. Add Commitment Devices

When discipline is hard to maintain:

```markdown
**Commitment Device**: Before [action], announce: "[what you'll do]"
```

## Testing Skills

### Manual Testing

1. **Try the skill on a real task**
   ```
   Use the context-tree-maintenance skill to build docs for [project]
   ```

2. **Note what worked**
   - Which sections were helpful?
   - Which steps were clear?
   - What prevented mistakes?

3. **Note what didn't work**
   - What was missing?
   - What was confusing?
   - What did you skip?

4. **Update the skill** based on findings

### Pressure Testing (Advanced)

Use subagents to test if the skill prevents shortcuts:

```
Create a scenario where I'm tempted to skip verification.
Does the skill prevent this?
```

## Best Practices

### When Writing Skills

**DO**:
- ✅ Use strong imperatives (NEVER, MUST, STOP)
- ✅ Include specific examples from real usage
- ✅ Add commitment devices for discipline
- ✅ Focus on "why" not just "what"
- ✅ Make validation concrete and testable

**DON'T**:
- ❌ Write generic advice ("be careful")
- ❌ Skip the "Common Rationalizations" section
- ❌ Leave validation vague
- ❌ Forget to update after using the skill

### When Using Skills

**DO**:
- ✅ Follow the skill exactly, don't take shortcuts
- ✅ Use commitment devices (announce your actions)
- ✅ Check off validation items as you go
- ✅ Note gaps or improvements for later

**DON'T**:
- ❌ Cherry-pick easy parts
- ❌ Skip verification steps
- ❌ Ignore "Common Rationalizations" warnings
- ❌ Forget to update the skill with learnings

## Installation

### Project-Local Installation

Skills are installed to `.claude/` in your project directory:

```bash
cd ~/your-project
curl -sSL https://raw.githubusercontent.com/RossH3/context-tree/main/install-advanced.sh | bash
```

**Local testing** (before pushing to GitHub):
```bash
cd ~/your-project
bash /path/to/context-tree/install-advanced.sh --local
```

This installs:
- Skill → `.claude/skills/context-tree-maintenance/` (SKILL.md + discovery-commands.md)
- Commands → `.claude/commands/`
- Hooks → `.claude/hooks/`

## Maintenance

### Regular Review

**Monthly**:
- Review skill against actual usage
- Add examples from real scenarios
- Update validation checklists
- Remove outdated content

**After Major Use**:
- Note what worked well
- Note what was missing
- Note what was confusing
- Update skill immediately

### Version Control

Skills should be version controlled alongside your code (if project-specific) or in a dedicated repo (if shared).

Track changes to skills like code:
```bash
git add .claude/skills/context-tree-maintenance/SKILL.md
git commit -m "Add pressure testing validation step to skill"
```

## Philosophy

Skills embody a philosophy of **systematic excellence**:

1. **Discipline over motivation** - Systems beat willpower
2. **Verification over trust** - Always check against reality
3. **Prevention over correction** - Stop mistakes before they happen
4. **Evolution over perfection** - Skills improve through use

The goal is to make **doing it right** the **path of least resistance**.

## Contributing

To contribute improvements to context-tree skills:

1. **Test your enhancement** on real projects
2. **Document the improvement** with examples
3. **Share via GitHub** (if using context-tree repo)
4. **Explain the reasoning** - why this helps

## Resources

- **Context Tree Repo**: https://github.com/RossH3/context-tree
- **Claude Skills Documentation**: https://docs.claude.com/en/docs/claude-code/skills
- **Claude Skills Best Practices**: https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices
- **Superpowers** (Jesse Vincent's skills system): https://github.com/obra/superpowers
- **Persuasion Principles**: Robert Cialdini's research on commitment, authority, consistency

---

*Skills are living documents. They improve through real usage and honest reflection. Keep enhancing them.*
