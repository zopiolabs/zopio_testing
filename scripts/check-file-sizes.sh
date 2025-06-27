#!/usr/bin/env bash

# Maximum file size in bytes (1MB)
MAX_SIZE=1048576
LARGE_FILES=()

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
  echo "No staged files to check"
  exit 0
fi

# Check each staged file
for FILE in $STAGED_FILES; do
  # Skip if file doesn't exist (might be deleted)
  if [ ! -f "$FILE" ]; then
    continue
  fi
  
  # Get file size
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    SIZE=$(stat -f%z "$FILE" 2>/dev/null || echo 0)
  else
    # Linux
    SIZE=$(stat -c%s "$FILE" 2>/dev/null || echo 0)
  fi
  
  # Check if file exceeds max size
  if [ "$SIZE" -gt "$MAX_SIZE" ]; then
    SIZE_MB=$((SIZE / 1048576))
    LARGE_FILES+=("$FILE (${SIZE_MB}MB)")
  fi
done

# Report results
if [ ${#LARGE_FILES[@]} -gt 0 ]; then
  echo "❌ Large files detected (> 1MB):"
  for FILE in "${LARGE_FILES[@]}"; do
    echo "  - $FILE"
  done
  echo ""
  echo "Consider:"
  echo "1. Using Git LFS for large files"
  echo "2. Compressing the files"
  echo "3. Excluding them from the repository"
  echo "4. Moving them to cloud storage"
  exit 1
fi

echo "✅ All staged files are within size limits"