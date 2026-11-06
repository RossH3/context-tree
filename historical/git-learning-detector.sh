#!/bin/bash
# git-learning-detector.sh
# Analyzes git history to detect learning opportunities for Context Tree documentation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default options
SINCE="3.months"
BRANCH=""
BASE_BRANCH=""
HELP=false
IGNORE_WORKFLOW=false
MIN_FREQUENCY=2
HIGH_SIGNAL_ONLY=false

# Workflow noise patterns to filter (customize for your project)
# NOTE: These patterns are project-specific. Common patterns include:
# - Branch naming: merged, feature, branch
# - Ticket systems: ticket, jira, flight (customize to your ticket prefix)
# - Generic updates: update, change, request
WORKFLOW_PATTERNS="merged|feature|ticket|jira|update|change|request|branch|pull"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --since=*)
      SINCE="${1#*=}"
      shift
      ;;
    --branch=*)
      BRANCH="${1#*=}"
      shift
      ;;
    --base=*)
      BASE_BRANCH="${1#*=}"
      shift
      ;;
    --ignore-workflow)
      IGNORE_WORKFLOW=true
      shift
      ;;
    --min-frequency=*)
      MIN_FREQUENCY="${1#*=}"
      shift
      ;;
    --high-signal-only)
      HIGH_SIGNAL_ONLY=true
      IGNORE_WORKFLOW=true
      MIN_FREQUENCY=3
      shift
      ;;
    --help)
      HELP=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Help text
if [ "$HELP" = true ]; then
  cat << EOF
${BOLD}Git Learning Detector${NC}
Analyzes git history to detect "Rule of Two" violations - patterns indicating
documentation opportunities for your Context Tree.

${BOLD}USAGE:${NC}
  ./git-learning-detector.sh [options]

${BOLD}OPTIONS:${NC}
  --since=<date>        Analyze commits since date (default: 3.months)
                        Examples: 3.months, 6.months, 2024-01-01
  --branch=<name>       Analyze specific branch (default: current branch)
  --base=<name>         Compare against base branch (shows diff commits)
  --ignore-workflow     Filter out workflow noise (merged, feature, ticket refs)
  --min-frequency=<N>   Only show patterns with N+ occurrences (default: 2)
  --high-signal-only    Preset: --ignore-workflow + --min-frequency=3
  --help                Show this help message

${BOLD}EXAMPLES:${NC}
  # Analyze last 3 months on current branch
  ./git-learning-detector.sh

  # Analyze last 6 months
  ./git-learning-detector.sh --since=6.months

  # High signal-to-noise ratio (recommended)
  ./git-learning-detector.sh --high-signal-only

  # Compare feature branch against main
  ./git-learning-detector.sh --branch=feature/new-feature --base=main

${BOLD}OUTPUT:${NC}
  Detects 5 types of learning signals:
  1. Repeated fix patterns (same issue, different files)
  2. Defensive comments (IMPORTANT/DON'T/NEVER added to code)
  3. High churn files (changed repeatedly - confusion zones)
  4. Terminology inconsistencies (multiple names for same concept)
  5. Learning signals in commits (TIL, learned, figured out, gotcha)

  For each signal, suggests where to document in your Context Tree.

${BOLD}MORE INFO:${NC}
  See README.md for integration with context-tree-maintenance workflow.
EOF
  exit 0
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}Error: Not a git repository${NC}"
  exit 1
fi

# Set branch options for git log
BRANCH_OPTS=""
if [ -n "$BRANCH" ]; then
  BRANCH_OPTS="$BRANCH"
elif [ -n "$BASE_BRANCH" ]; then
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  BRANCH_OPTS="$BASE_BRANCH..$CURRENT_BRANCH"
fi

echo -e "${BOLD}=== GIT LEARNING DETECTOR ===${NC}"
echo -e "Analyzing commits since ${BLUE}$SINCE${NC}..."
if [ -n "$BRANCH_OPTS" ]; then
  echo -e "Branch range: ${BLUE}$BRANCH_OPTS${NC}"
fi
if [ "$IGNORE_WORKFLOW" = true ]; then
  echo -e "Filters: ${YELLOW}Ignoring workflow noise${NC} (merged, feature, tickets)"
fi
if [ "$MIN_FREQUENCY" -gt 2 ]; then
  echo -e "Threshold: ${YELLOW}Min ${MIN_FREQUENCY} occurrences${NC}"
fi
echo ""

# Function 1: Analyze repeated fix patterns
analyze_repeated_fixes() {
  echo -e "${BOLD}1. REPEATED FIX PATTERNS${NC} ${YELLOW}(Candidates for Common Pitfalls)${NC}"
  echo ""

  # Extract fix commits and look for patterns
  local fixes=$(git log --since="$SINCE" $BRANCH_OPTS --oneline --grep="^fix:" --grep="^Fix:" -i 2>/dev/null || true)

  if [ -z "$fixes" ]; then
    echo "  No repeated fix patterns detected."
    echo ""
    return
  fi

  # Analyze patterns (remove commit hash, lowercase, look for common words)
  local patterns=$(echo "$fixes" | \
    cut -d' ' -f2- | \
    tr '[:upper:]' '[:lower:]' | \
    sed 's/[^a-z ]/  /g' | \
    awk '{for(i=1;i<=NF;i++) if(length($i) > 4) print $i}' | \
    sort | uniq -c | sort -rn | \
    awk -v min="$MIN_FREQUENCY" '$1 >= min {print "  [" $1 "x] " $2}')

  # Filter out workflow noise if requested
  if [ "$IGNORE_WORKFLOW" = true ]; then
    # Match format: "  [21x] word" and filter out workflow patterns
    patterns=$(echo "$patterns" | grep -vE "x\] ($WORKFLOW_PATTERNS)\$" || true)
  fi

  if [ -z "$patterns" ]; then
    echo "  No repeated patterns found (threshold: ${MIN_FREQUENCY}+ occurrences)."
  else
    echo "$patterns"
    echo ""
    echo -e "  ${GREEN}→ Suggestion:${NC} Add to ${BOLD}CLAUDE.md Common Pitfalls${NC} section"
    echo "  Format: ❌ DON'T [common mistake] / ✅ DO [correct approach]"
  fi
  echo ""
}

# Function 2: Analyze defensive comments
analyze_defensive_comments() {
  echo -e "${BOLD}2. DEFENSIVE COMMENTS ADDED${NC} ${YELLOW}(Knowledge gained from pain)${NC}"
  echo ""

  # Search for defensive keywords added in commits
  local defensive_pattern="IMPORTANT:|WARNING:|DON'T|NEVER|ALWAYS|GOTCHA:|CAREFUL:|NOTE:"
  local defensive_commits=$(git log --since="$SINCE" $BRANCH_OPTS -p --all 2>/dev/null | \
    grep -E "^\+.*($defensive_pattern)" | \
    head -20 || true)

  if [ -z "$defensive_commits" ]; then
    echo "  No defensive comments detected."
    echo ""
    return
  fi

  # Show first few examples
  local count=$(echo "$defensive_commits" | wc -l | tr -d ' ')
  echo "  Found ${count} defensive comments added. Examples:"
  echo ""
  echo "$defensive_commits" | head -5 | sed 's/^/    /'
  echo ""

  if [ "$count" -gt 5 ]; then
    echo "    ... and $((count - 5)) more"
    echo ""
  fi

  echo -e "  ${GREEN}→ Suggestion:${NC} Review these warnings and add to ${BOLD}CLAUDE.md${NC}"
  echo "  These comments indicate pain points that should be documented."
  echo ""
}

# Function 3: Analyze high churn files
analyze_high_churn() {
  echo -e "${BOLD}3. HIGH CHURN FILES${NC} ${YELLOW}(Confusion zones)${NC}"
  echo ""

  # Files changed most frequently
  local churn=$(git log --since="$SINCE" $BRANCH_OPTS --name-only --format="" 2>/dev/null | \
    grep -v "^$" | \
    sort | uniq -c | sort -rn | head -10 || true)

  if [ -z "$churn" ]; then
    echo "  No high churn detected."
    echo ""
    return
  fi

  echo "  Top 10 most frequently changed files:"
  echo ""
  echo "$churn" | awk '{printf "    %3d changes: %s\n", $1, $2}'
  echo ""

  echo -e "  ${GREEN}→ Suggestion:${NC} High churn often indicates:"
  echo "    • Confusing area that needs better documentation"
  echo "    • Evolving patterns that should be captured in ARCHITECTURE.md"
  echo "    • Complex business logic that needs BUSINESS_CONTEXT.md explanation"
  echo ""
}

# Function 4: Analyze terminology inconsistencies
analyze_terminology() {
  echo -e "${BOLD}4. TERMINOLOGY INCONSISTENCIES${NC} ${YELLOW}(Candidates for GLOSSARY.md)${NC}"
  echo ""

  # Common patterns of inconsistent naming
  local patterns=(
    "orgId|organizationId|org_id|organisation_id:Organization ID"
    "userId|user_id|uid:User ID"
    "clientId|client_id|clientid:Client ID"
    "tenantId|tenant_id:Tenant ID"
  )

  local found_inconsistencies=false

  for pattern_def in "${patterns[@]}"; do
    local pattern="${pattern_def%:*}"
    local name="${pattern_def#*:}"

    # Count occurrences of each variation in recent commits
    local counts=$(git log --since="$SINCE" $BRANCH_OPTS -p 2>/dev/null | \
      grep -oE "$pattern" | sort | uniq -c | sort -rn || true)

    if [ -n "$counts" ]; then
      local variation_count=$(echo "$counts" | wc -l | tr -d ' ')
      if [ "$variation_count" -gt 1 ]; then
        found_inconsistencies=true
        echo "  ${name} variations:"
        echo "$counts" | awk '{printf "    %3dx %s\n", $1, $2}'
        echo ""
      fi
    fi
  done

  if [ "$found_inconsistencies" = false ]; then
    echo "  No terminology inconsistencies detected in common patterns."
    echo ""
    return
  fi

  echo -e "  ${GREEN}→ Suggestion:${NC} Add to ${BOLD}docs/GLOSSARY.md${NC}"
  echo "  Document preferred naming conventions and explain variations."
  echo "  Format: Term (preferred) | Code | Database | UI | Notes"
  echo ""
}

# Function 5: Analyze learning signals in commits
analyze_learning_signals() {
  echo -e "${BOLD}5. LEARNING SIGNALS IN COMMITS${NC} ${YELLOW}(Explicit knowledge capture)${NC}"
  echo ""

  # Search for explicit learning indicators
  local learning_pattern="TIL|learned|figured out|turns out|gotcha|tricky|confusing|took a while"
  local learning_commits=$(git log --since="$SINCE" $BRANCH_OPTS --oneline --all -i --grep="$learning_pattern" 2>/dev/null || true)

  # Filter out workflow noise if requested
  if [ "$IGNORE_WORKFLOW" = true ]; then
    # Filter out merge commits, ticket references, and workflow patterns
    learning_commits=$(echo "$learning_commits" | grep -viE "(merge branch|^[a-z]+-[0-9]+|$WORKFLOW_PATTERNS)" || true)
  fi

  if [ -z "$learning_commits" ]; then
    echo "  No explicit learning signals detected in commit messages."
    echo ""
    return
  fi

  local count=$(echo "$learning_commits" | wc -l | tr -d ' ')
  echo "  Found ${count} commits with learning signals:"
  echo ""
  echo "$learning_commits" | sed 's/^/    /' | head -10
  echo ""

  if [ "$count" -gt 10 ]; then
    echo "    ... and $((count - 10)) more"
    echo ""
  fi

  echo -e "  ${GREEN}→ Suggestion:${NC} Review these commits - developers are explicitly flagging insights"
  echo "  These are prime candidates for documentation:"
  echo "    • Technical gotchas → ARCHITECTURE.md or framework-specific reference"
  echo "    • Business logic complexity → BUSINESS_CONTEXT.md"
  echo "    • Common mistakes → CLAUDE.md Common Pitfalls"
  echo ""
}

# Function 6: Generate summary and recommendations
generate_summary() {
  echo -e "${BOLD}=== SUMMARY & RECOMMENDATIONS ===${NC}"
  echo ""

  # Count total signals detected
  local fix_count=$(git log --since="$SINCE" $BRANCH_OPTS --oneline --grep="^fix:" --grep="^Fix:" -i 2>/dev/null | wc -l | tr -d ' ')
  local defensive_count=$(git log --since="$SINCE" $BRANCH_OPTS -p --all 2>/dev/null | grep -c -E "^\+.*(IMPORTANT:|WARNING:|DON'T|NEVER|ALWAYS)" || echo "0")
  local learning_count=$(git log --since="$SINCE" $BRANCH_OPTS --oneline --all -i --grep="TIL|learned|figured out|turns out|gotcha" 2>/dev/null | wc -l | tr -d ' ')

  local total=$((fix_count + defensive_count + learning_count))

  if [ "$total" -eq 0 ]; then
    echo "  ${GREEN}✓${NC} No significant learning signals detected."
    echo "  Your Context Tree may already be capturing key patterns, or"
    echo "  try analyzing a longer time period with --since=6.months"
    echo ""
    return
  fi

  echo "  Detected ${BOLD}${total}${NC} total learning signals:"
  echo "    • ${fix_count} fix commits (repeated patterns)"
  echo "    • ${defensive_count} defensive comments added"
  echo "    • ${learning_count} explicit learning indicators"
  echo ""

  echo -e "  ${BOLD}Next steps:${NC}"
  echo "    1. Review signals above and verify against code"
  echo "    2. For patterns with 2+ occurrences, add to Context Tree:"
  echo "       • Common mistakes → CLAUDE.md Common Pitfalls"
  echo "       • Terminology variations → docs/GLOSSARY.md"
  echo "       • Architectural insights → docs/ARCHITECTURE.md"
  echo "       • Business logic → docs/BUSINESS_CONTEXT.md"
  echo "    3. Commit with message: 'docs: capture learning from git history'"
  echo "    4. Run this tool monthly to maintain signal-to-noise ratio"
  echo ""

  echo -e "  ${BLUE}Pro tip:${NC} Use context-tree-maintenance skill for guided documentation"
  echo ""
}

# Main execution
analyze_repeated_fixes
analyze_defensive_comments
analyze_high_churn
analyze_terminology
analyze_learning_signals
generate_summary

echo -e "${BOLD}=== ANALYSIS COMPLETE ===${NC}"
echo ""
