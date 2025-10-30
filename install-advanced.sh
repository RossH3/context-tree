#!/bin/bash

# ABOUTME: Installs context-tree orchestrated workflow to project-local .claude/ directory
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
echo "║   Context Tree Builder - Orchestrated Workflow Install    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "This installs to: $(pwd)/.claude/"
echo "  ✓ Orchestrated workflow → .claude/orchestrators/context-tree-builder/"
echo "  ✓ Context Tree Maintenance skill → .claude/skills/context-tree-maintenance/"
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
if [ -d ".claude/orchestrators" ] || [ -d ".claude/skills" ] || [ -d ".claude/commands" ] || [ -d ".claude/hooks" ]; then
  echo "⚠️  .claude/ directory already contains orchestrators/skills/commands/hooks"
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
mkdir -p .claude/orchestrators/context-tree-builder
mkdir -p .claude/skills/context-tree-maintenance
mkdir -p .claude/commands
mkdir -p .claude/hooks

# Install orchestrators (the 3-phase workflow)
echo ""
echo "Installing orchestrated workflow (3 phases)..."
install_file ".claude/orchestrators/context-tree-builder/codebase-discovery.md" ".claude/orchestrators/context-tree-builder/codebase-discovery.md" || exit 1
install_file ".claude/orchestrators/context-tree-builder/domain-interview.md" ".claude/orchestrators/context-tree-builder/domain-interview.md" || exit 1
install_file ".claude/orchestrators/context-tree-builder/doc-generator.md" ".claude/orchestrators/context-tree-builder/doc-generator.md" || exit 1

# Install maintenance skill (for ongoing work)
echo ""
echo "Installing maintenance skill..."
install_file "skills/context-tree-maintenance/SKILL.md" ".claude/skills/context-tree-maintenance/SKILL.md" || exit 1

# Install commands
echo ""
echo "Installing slash commands..."
install_file ".claude/commands/build-context-tree.md" ".claude/commands/build-context-tree.md" || exit 1
install_file ".claude/commands/audit-context.md" ".claude/commands/audit-context.md" || exit 1
install_file ".claude/commands/capture-insight.md" ".claude/commands/capture-insight.md" || exit 1

# Install hooks
echo ""
echo "Installing session hook..."
install_file ".claude/hooks/session-start.sh" ".claude/hooks/session-start.sh" || exit 1
chmod +x .claude/hooks/session-start.sh

echo ""
echo "✅ Installation Complete!"
echo ""

# Calculate sizes
DISCOVERY_LINES=$(wc -l < ".claude/orchestrators/context-tree-builder/codebase-discovery.md" | tr -d ' ')
INTERVIEW_LINES=$(wc -l < ".claude/orchestrators/context-tree-builder/domain-interview.md" | tr -d ' ')
DOCGEN_LINES=$(wc -l < ".claude/orchestrators/context-tree-builder/doc-generator.md" | tr -d ' ')
MAINTENANCE_LINES=$(wc -l < ".claude/skills/context-tree-maintenance/SKILL.md" | tr -d ' ')

echo "   Phase 1 (Discovery): $DISCOVERY_LINES lines"
echo "   Phase 2 (Interview): $INTERVIEW_LINES lines ⭐ THE KEY DIFFERENTIATOR"
echo "   Phase 3 (Docs): $DOCGEN_LINES lines"
echo "   Maintenance skill: $MAINTENANCE_LINES lines"
echo "   Location: $(pwd)/.claude/"
echo ""

echo "🚀 Usage"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Start Claude Code in this project:"
echo "  claude"
echo ""
echo "Build Context Tree (3-phase orchestrated workflow):"
echo "  /build-context-tree"
echo ""
echo "  Phase 1: Codebase Discovery (15-20 min)"
echo "    - Automated exploration to find patterns and gotchas"
echo ""
echo "  Phase 2: Domain Expert Interview (30-60 min) ⭐"
echo "    - Interactive Q&A to capture institutional knowledge"
echo "    - Resumable across multiple sessions"
echo ""
echo "  Phase 3: Documentation Generation (30-45 min)"
echo "    - Quality-gated docs (only generates with ≥3 insights)"
echo "    - CLAUDE.md (always) + optional GLOSSARY, ARCHITECTURE, BUSINESS_CONTEXT"
echo ""
echo "Ongoing Maintenance:"
echo "  /audit-context       - Monthly quality audit"
echo "  /capture-insight     - Quick insight capture during development"
echo ""

if [ "$LOCAL_MODE" = true ]; then
  echo "🧪 Local Testing Mode"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "Files copied from local context-tree repository"
  echo ""
fi

echo "📖 Documentation"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "For detailed guidance, see:"
echo "  https://github.com/$GITHUB_USER/$GITHUB_REPO#readme"
echo ""
echo "Key principles:"
echo "  ✓ Verify against code, not docs"
echo "  ✓ Signal-to-noise ratio (every line justifies token cost)"
echo "  ✓ No generic slop (only document what AI can't infer)"
echo "  ✓ Quality over quantity"
echo ""

echo "🔄 Uninstalling"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "To uninstall:"
echo "  rm -rf .claude/orchestrators/context-tree-builder .claude/skills/context-tree-maintenance .claude/commands .claude/hooks"
echo ""
echo "To keep maintenance tools but remove builder:"
echo "  rm -rf .claude/orchestrators/context-tree-builder"
echo "  rm .claude/commands/build-context-tree.md"
echo ""
