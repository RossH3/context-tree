# Context Tree Skills

## What Are Skills?

Skills are reusable methodology documents that guide AI assistants (like Claude Code) through specific workflows. They're markdown files containing:

- **Clear principles** - Fundamental rules and guardrails
- **Step-by-step workflows** - Systematic approaches to tasks
- **Validation checklists** - How to verify work quality
- **Authoritative tone** - Strong imperatives (NEVER, MUST, STOP)
- **Commitment devices** - Announcements that enforce discipline

Think of skills as **executable best practices** that an AI can follow consistently across projects.

## Available Skills

### context-tree-maintenance.md

**Purpose**: Build, maintain, audit, and validate context trees for brownfield codebases

**When to use**:
- Building initial context tree for a project
- Auditing existing documentation for signal-to-noise ratio
- Capturing insights discovered during development
- Validating architectural claims against code
- Monthly maintenance and quality checks
- Pruning outdated or low-value content
- Running automated codebase discovery

**Slash commands** (if installed in project):
- `/audit-context` - Full validation workflow
- `/discover-codebase` - Automated discovery only
- `/capture-insight` - Quick insight capture

**Key features**:
- Detailed discovery commands for tech stack analysis
- "Common Rationalizations" section to prevent shortcuts
- Commitment devices for verification discipline
- Validation checklists for quality control
- Signal-to-noise optimization focus

## How Skills Work

### Structure

Skills follow a consistent structure:

1. **Overview** - What the skill does
2. **When to Use** - Trigger conditions
3. **Critical Principles** - Non-negotiable guardrails
4. **Common Rationalizations** - Traps to avoid
5. **Workflows** - Step-by-step processes
6. **Validation** - How to verify quality
7. **Summary** - Key takeaways

### Usage

**Manual invocation**:
```
Claude, use the context-tree-maintenance skill to audit the docs
```

**Slash command** (if installed):
```
/audit-context
```

**Automatic** (with session hook):
- Skill context injected at session start
- Claude proactively suggests skills when relevant

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
- Skill → `.claude/skills/documentation/`
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
git add .claude/skills/documentation/context-tree-maintenance.md
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
- **Superpowers** (Jesse Vincent's skills system): https://github.com/obra/superpowers
- **Persuasion Principles**: Robert Cialdini's research on commitment, authority, consistency

---

*Skills are living documents. They improve through real usage and honest reflection. Keep enhancing them.*
