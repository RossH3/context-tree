#!/bin/bash

# ABOUTME: Session start hook for Claude Code
# ABOUTME: Lists available Claude Skills and slash commands in project

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
COMMANDS_DIR="$PROJECT_ROOT/.claude/commands"

# Build message
MESSAGE=""

# Check for skills (Claude will auto-discover via SKILL.md)
if [ -d "$SKILLS_DIR/context-tree-maintenance" ] && [ -f "$SKILLS_DIR/context-tree-maintenance/SKILL.md" ]; then
  MESSAGE+="📋 **Context Tree Maintenance** skill is available\\n"
  MESSAGE+="   Claude will automatically use it when relevant.\\n\\n"
fi

# List available slash commands
if [ -d "$COMMANDS_DIR" ]; then
  COMMAND_COUNT=$(find "$COMMANDS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')
  if [ "$COMMAND_COUNT" -gt 0 ]; then
    MESSAGE+="**Available slash commands:**\\n"
    for cmd_file in "$COMMANDS_DIR"/*.md; do
      if [ -f "$cmd_file" ]; then
        cmd_name=$(basename "$cmd_file" .md)
        MESSAGE+="   - /$cmd_name\\n"
      fi
    done
  fi
fi

# Output JSON for Claude Code if there's a message
if [ -n "$MESSAGE" ]; then
  # Use python for reliable JSON escaping
  ESCAPED_MESSAGE=$(echo -e "$MESSAGE" | python3 -c 'import sys, json; print(json.dumps(sys.stdin.read()))')

  cat <<EOF
{
  "event": "session-start",
  "context": $ESCAPED_MESSAGE
}
EOF
fi
