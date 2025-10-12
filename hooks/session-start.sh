#!/bin/bash

# ABOUTME: Session start hook for Claude Code
# ABOUTME: Discovers and injects context-tree skills from project-local .claude/ directory

# Find project root by searching upward for .claude directory
find_project_root() {
  local current_dir="$PWD"

  while [ "$current_dir" != "/" ]; do
    if [ -d "$current_dir/.claude" ]; then
      echo "$current_dir"
      return 0
    fi
    current_dir=$(dirname "$current_dir")
  done

  return 1
}

# Find project root
PROJECT_ROOT=$(find_project_root)

if [ -z "$PROJECT_ROOT" ]; then
  # No .claude directory found, exit silently
  exit 0
fi

SKILLS_DIR="$PROJECT_ROOT/.claude/skills"

# Build skills context message
SKILLS_CONTEXT=""

if [ -d "$SKILLS_DIR/documentation" ]; then
  SKILLS_CONTEXT+="You have context-tree maintenance skills available:\\n\\n"

  if [ -f "$SKILLS_DIR/documentation/context-tree-maintenance.md" ]; then
    SKILLS_CONTEXT+="📋 **context-tree-maintenance.md**\\n"
    SKILLS_CONTEXT+="   Location: .claude/skills/documentation/context-tree-maintenance.md\\n"
    SKILLS_CONTEXT+="   Purpose: Build, maintain, audit, and validate context trees\\n\\n"
    SKILLS_CONTEXT+="   Use when:\\n"
    SKILLS_CONTEXT+="   - Building initial context tree for a codebase\\n"
    SKILLS_CONTEXT+="   - Auditing documentation for signal-to-noise ratio\\n"
    SKILLS_CONTEXT+="   - Capturing insights during development\\n"
    SKILLS_CONTEXT+="   - Validating architectural claims against code\\n"
    SKILLS_CONTEXT+="   - Monthly maintenance checks\\n"
    SKILLS_CONTEXT+="   - Removing outdated or low-value content\\n"
    SKILLS_CONTEXT+="   - Running automated codebase discovery\\n\\n"
    SKILLS_CONTEXT+="   Slash commands (if installed in project):\\n"
    SKILLS_CONTEXT+="   - /audit-context - Full validation workflow\\n"
    SKILLS_CONTEXT+="   - /discover-codebase - Automated discovery only\\n"
    SKILLS_CONTEXT+="   - /capture-insight - Quick insight capture\\n\\n"
  fi

  SKILLS_CONTEXT+="**Proactive Usage Guidelines:**\\n"
  SKILLS_CONTEXT+="- When Ross discusses context tree or documentation, suggest using the skill\\n"
  SKILLS_CONTEXT+="- When validating architecture, reference the skill's verification checklist\\n"
  SKILLS_CONTEXT+="- When capturing insights, follow the skill's 'where to add' guidance\\n"
  SKILLS_CONTEXT+="- Watch for 'Common Rationalizations' - stop them immediately\\n"
  SKILLS_CONTEXT+="- Use commitment devices: Announce 'I'm verifying [claim] at [file:line]'\\n"
  SKILLS_CONTEXT+="- NEVER document without verifying against code first\\n"
fi

# Output JSON for Claude Code
# Use python for reliable JSON escaping
ESCAPED_CONTEXT=$(echo -e "$SKILLS_CONTEXT" | python3 -c 'import sys, json; print(json.dumps(sys.stdin.read()))')

cat <<EOF
{
  "event": "session-start",
  "context": $ESCAPED_CONTEXT
}
EOF
