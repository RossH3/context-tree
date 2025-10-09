#!/bin/bash
# Context Tree Installation Script
# Downloads the 4 context tree builder files to your project root

set -e

REPO_BASE="https://raw.githubusercontent.com/RossH3/context-tree/main"
FILES=(
  "CONTEXT_TREE_QUICK_START.md"
  "CONTEXT_TREE_BUILDER.md"
  "CONTEXT_TREE_DISCOVERY.md"
  "CONTEXT_TREE_PRINCIPLES.md"
)

echo "📦 Installing Context Tree files..."
echo ""

for file in "${FILES[@]}"; do
  echo "  Downloading $file..."
  curl -sSL "$REPO_BASE/$file" -o "$file"
done

echo ""
echo "✅ Installation complete!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Start Claude Code:"
echo "   claude"
echo ""
echo "2. Tell Claude to build your context tree:"
echo "   Help me build a context tree using CONTEXT_TREE_BUILDER.md"
echo ""
echo "3. After building, you can delete these files:"
echo "   - CONTEXT_TREE_QUICK_START.md"
echo "   - CONTEXT_TREE_BUILDER.md"
echo "   - CONTEXT_TREE_DISCOVERY.md"
echo ""
echo "4. Keep this file for maintenance:"
echo "   - CONTEXT_TREE_PRINCIPLES.md"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📖 For detailed guidance, see CONTEXT_TREE_QUICK_START.md"
echo ""
