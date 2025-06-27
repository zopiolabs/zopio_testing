#!/usr/bin/env bash

# Get current branch name
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Define allowed branch patterns
ALLOWED_PATTERNS=(
  '^main$'
  '^develop$'
  '^staging$'
  '^feat/.+$'
  '^feature/.+$'
  '^fix/.+$'
  '^hotfix/.+$'
  '^release/v[0-9]+\.[0-9]+\.[0-9]+$'
  '^docs/.+$'
  '^chore/.+$'
  '^test/.+$'
  '^refactor/.+$'
  '^ci/.+$'
  '^build/.+$'
  '^perf/.+$'
  '^style/.+$'
  '^revert/.+$'
  '^v[0-9]+\.[0-9]+$'
  '^sync/.+$'
  '^dependabot/.+$'
  '^codex/.+$'
)

# Check if branch matches any allowed pattern
VALID=false
for PATTERN in "${ALLOWED_PATTERNS[@]}"; do
  if [[ "$BRANCH" =~ $PATTERN ]]; then
    VALID=true
    break
  fi
done

if [ "$VALID" = false ]; then
  echo "❌ Branch name '$BRANCH' does not follow naming conventions."
  echo ""
  echo "Allowed patterns:"
  echo "  - main, develop, staging (protected branches)"
  echo "  - feat/* or feature/* - New features"
  echo "  - fix/* - Bug fixes"
  echo "  - hotfix/* - Emergency fixes"
  echo "  - release/v*.*.* - Release branches"
  echo "  - docs/* - Documentation"
  echo "  - chore/* - Maintenance"
  echo "  - test/* - Tests"
  echo "  - refactor/* - Refactoring"
  echo "  - ci/* - CI/CD changes"
  echo "  - build/* - Build changes"
  echo "  - perf/* - Performance improvements"
  echo "  - style/* - Code style"
  echo "  - revert/* - Reverts"
  echo "  - v*.* - Version branches"
  exit 1
fi

echo "✅ Branch name '$BRANCH' is valid"