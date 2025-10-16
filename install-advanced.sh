#!/bin/bash

# ABOUTME: Installs context-tree skills, commands, and hooks to project-local .claude/ directory
# ABOUTME: Supports local testing (--local) and remote installation via curl from GitHub

set -e  # Exit on error

# GitHub repository details
GITHUB_USER="RossH3"
GITHUB_REPO="context-tree"
GITHUB_BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$GITHUB_BRANCH"

# Parse arguments
LOCAL_MODE=false
if [[ "$1" == "--local" ]]; then
  LOCAL_MODE=true
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║        Context Tree - Advanced Installation                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "This installs to: $(pwd)/.claude/"
echo "  ✓ Context tree maintenance skill → .claude/skills/context-tree-maintenance/"
echo "  ✓ Slash commands → .claude/commands/"
echo "  ✓ Session hooks → .claude/hooks/"
echo ""

# Function to fetch file from GitHub
fetch_file() {
  local remote_path=$1
  local local_path=$2

  echo "  Fetching: $remote_path"

  if ! curl -fsSL "$BASE_URL/$remote_path" -o "$local_path" 2>/dev/null; then
    echo ""
    echo "❌ Error: Failed to fetch $remote_path from GitHub"
    echo "   URL: $BASE_URL/$remote_path"
    echo "   Check your network connection or verify the file exists in the repository"
    return 1
  fi
}

# Function to copy file from local context-tree repo
copy_local_file() {
  local rel_path=$1
  local dest_path=$2

  # Try to find context-tree repo (assume it's in same parent directory)
  local source_paths=(
    "../context-tree/$rel_path"
    "../../context-tree/$rel_path"
    "$HOME/projects/context-tree/$rel_path"
  )

  for source in "${source_paths[@]}"; do
    if [ -f "$source" ]; then
      echo "  Copying: $rel_path (from $source)"
      cp "$source" "$dest_path"
      return 0
    fi
  done

  echo ""
  echo "❌ Error: Cannot find local file: $rel_path"
  echo "   Searched in:"
  for source in "${source_paths[@]}"; do
    echo "     - $source"
  done
  echo "   Please run from a directory near the context-tree repository"
  return 1
}

# Function to install a file (local or remote)
install_file() {
  local rel_path=$1
  local dest_path=$2

  if [ "$LOCAL_MODE" = true ]; then
    copy_local_file "$rel_path" "$dest_path"
  else
    fetch_file "$rel_path" "$dest_path"
  fi
}

echo "📦 Installing Files"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if .claude directory already exists with files
if [ -d ".claude/skills" ] || [ -d ".claude/commands" ] || [ -d ".claude/hooks" ]; then
  echo "⚠️  .claude/ directory already contains skills/commands/hooks"
  echo ""
  read -p "   Overwrite existing files? (y/N): " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Installation cancelled"
    exit 1
  fi
  echo ""
fi

# Create directory structure
echo "Creating directory structure..."
mkdir -p .claude/skills/context-tree-maintenance
mkdir -p .claude/commands
mkdir -p .claude/hooks

# Install skill
echo ""
echo "Installing skill..."
install_file "skills/context-tree-maintenance/SKILL.md" ".claude/skills/context-tree-maintenance/SKILL.md" || exit 1
install_file "skills/context-tree-maintenance/discovery-commands.md" ".claude/skills/context-tree-maintenance/discovery-commands.md" || exit 1

# Install commands
echo ""
echo "Installing slash commands..."
install_file "commands/audit-context.md" ".claude/commands/audit-context.md" || exit 1
install_file "commands/discover-codebase.md" ".claude/commands/discover-codebase.md" || exit 1
install_file "commands/capture-insight.md" ".claude/commands/capture-insight.md" || exit 1

# Install hooks
echo ""
echo "Installing session hook..."
install_file "hooks/session-start.sh" ".claude/hooks/session-start.sh" || exit 1
chmod +x .claude/hooks/session-start.sh

echo ""
echo "✅ Installation Complete!"
echo ""

# Calculate sizes
SKILL_LINES=$(wc -l < ".claude/skills/context-tree-maintenance/SKILL.md" | tr -d ' ')
COMMANDS_LINES=$(wc -l < ".claude/skills/context-tree-maintenance/discovery-commands.md" | tr -d ' ')
echo "   Skill: $SKILL_LINES lines (SKILL.md)"
echo "   Supporting files: $COMMANDS_LINES lines (discovery-commands.md)"
echo "   Location: $(pwd)/.claude/"
echo ""

echo "🚀 Usage"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Start Claude Code in this project:"
echo "  claude"
echo ""
echo "Use slash commands:"
echo "  /audit-context       - Full validation workflow"
echo "  /discover-codebase   - Automated codebase discovery"
echo "  /capture-insight     - Quick insight capture"
echo ""
echo "Claude will automatically use the skill when relevant."
echo "You can also invoke it explicitly:"
echo '  "Use the Context Tree Maintenance skill to audit the docs"'
echo ""

if [ "$LOCAL_MODE" = true ]; then
  echo "🧪 Local Testing Mode"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Files copied from local context-tree repository"
  echo ""
fi

echo "🔄 Uninstalling"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To uninstall:"
echo "  rm -rf .claude/skills/context-tree-maintenance .claude/commands .claude/hooks"
echo ""
