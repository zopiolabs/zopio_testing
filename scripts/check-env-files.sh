#!/usr/bin/env bash

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
  echo "No staged files to check"
  exit 0
fi

# Check for .env files
ENV_FILES=()
for FILE in $STAGED_FILES; do
  # Check for any .env file (but allow .env.example or .env.sample)
  if [[ "$FILE" =~ \.env($|\.local$|\.production$|\.development$|\.test$) ]]; then
    ENV_FILES+=("$FILE")
  fi
done

# Report results
if [ ${#ENV_FILES[@]} -gt 0 ]; then
  echo "❌ Environment files detected in commit:"
  for FILE in "${ENV_FILES[@]}"; do
    echo "  - $FILE"
  done
  echo ""
  echo "Environment files should never be committed!"
  echo ""
  echo "To fix this:"
  echo "1. Remove the file from staging: git reset HEAD $FILE"
  echo "2. Add to .gitignore: echo '$FILE' >> .gitignore"
  echo "3. Use .env.example for sample configurations"
  echo ""
  echo "If you already committed sensitive data:"
  echo "1. Change all exposed secrets immediately"
  echo "2. Remove from git history: git filter-branch or BFG Repo-Cleaner"
  exit 1
fi

echo "✅ No environment files in staged changes"