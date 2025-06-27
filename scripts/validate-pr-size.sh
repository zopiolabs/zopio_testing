#!/usr/bin/env bash

# Get the base branch (usually main or develop)
BASE_BRANCH=${1:-main}

# Check if we're on the base branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
  echo "✅ On $BASE_BRANCH branch, skipping PR size check"
  exit 0
fi

# Get statistics for changes between current branch and base
STATS=$(git diff --shortstat "$BASE_BRANCH"...HEAD 2>/dev/null)

if [ -z "$STATS" ]; then
  echo "No changes detected or unable to compare with $BASE_BRANCH"
  exit 0
fi

# Extract additions and deletions
ADDITIONS=$(echo "$STATS" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' || echo 0)
DELETIONS=$(echo "$STATS" | grep -oE '[0-9]+ deletion' | grep -oE '[0-9]+' || echo 0)
TOTAL_CHANGES=$((ADDITIONS + DELETIONS))

# Get number of changed files
CHANGED_FILES=$(git diff --name-only "$BASE_BRANCH"...HEAD | wc -l | tr -d ' ')

# Define limits
SOFT_LIMIT=1000
HARD_LIMIT=5000
MAX_FILES=100

echo "PR Statistics:"
echo "  - Changed files: $CHANGED_FILES"
echo "  - Additions: $ADDITIONS"
echo "  - Deletions: $DELETIONS"
echo "  - Total changes: $TOTAL_CHANGES"
echo ""

# Check file count
if [ "$CHANGED_FILES" -gt "$MAX_FILES" ]; then
  echo "❌ Too many files changed ($CHANGED_FILES files)"
  echo "Maximum allowed: $MAX_FILES files"
  echo ""
  echo "Please split this into smaller, focused PRs"
  exit 1
fi

# Check line changes
if [ "$TOTAL_CHANGES" -gt "$HARD_LIMIT" ]; then
  echo "❌ PR is too large ($TOTAL_CHANGES lines changed)"
  echo "Hard limit: $HARD_LIMIT lines"
  echo ""
  echo "Please split this into smaller, focused PRs for easier review"
  exit 1
elif [ "$TOTAL_CHANGES" -gt "$SOFT_LIMIT" ]; then
  echo "⚠️  PR is large ($TOTAL_CHANGES lines changed)"
  echo "Soft limit: $SOFT_LIMIT lines"
  echo ""
  echo "Consider splitting this into smaller PRs for easier review"
  echo "Continuing anyway..."
fi

echo "✅ PR size is within acceptable limits"