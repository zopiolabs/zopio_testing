#!/usr/bin/env bash

# Common patterns for secrets and sensitive data
SECRET_PATTERNS=(
  # API Keys and Tokens
  'api[_-]?key[[:space:]]*[:=][[:space:]]*["\047]?[A-Za-z0-9_\-]{20,}'
  'token[[:space:]]*[:=][[:space:]]*["\047]?[A-Za-z0-9_\-]{20,}'
  'secret[_-]?key[[:space:]]*[:=][[:space:]]*["\047]?[A-Za-z0-9_\-]{20,}'
  
  # AWS
  'AKIA[0-9A-Z]{16}'
  'aws[_-]?access[_-]?key[_-]?id[[:space:]]*[:=]'
  'aws[_-]?secret[_-]?access[_-]?key[[:space:]]*[:=]'
  
  # Private Keys
  '-----BEGIN (RSA |DSA |EC |OPENSSH |PGP )?PRIVATE KEY'
  
  # Generic Secrets
  'password[[:space:]]*[:=][[:space:]]*["\047]?[^[:space:]"\047]{8,}'
  'passwd[[:space:]]*[:=][[:space:]]*["\047]?[^[:space:]"\047]{8,}'
  
  # Database URLs with credentials
  'postgres://[^:]+:[^@]+@'
  'mysql://[^:]+:[^@]+@'
  'mongodb(\+srv)?://[^:]+:[^@]+@'
  
  # JWT
  'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}'
  
  # Stripe
  'sk_(test|live)_[0-9a-zA-Z]{24,}'
  'pk_(test|live)_[0-9a-zA-Z]{24,}'
  
  # GitHub
  'gh[pousr]_[0-9a-zA-Z]{36,}'
  
  # NPM
  'npm_[0-9a-zA-Z]{36,}'
)

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

if [ -z "$STAGED_FILES" ]; then
  echo "No staged files to check"
  exit 0
fi

FOUND_SECRETS=false
TEMP_FILE=$(mktemp)

# Check each staged file
for FILE in $STAGED_FILES; do
  # Skip binary files
  if file "$FILE" | grep -q "binary"; then
    continue
  fi
  
  # Skip .env.example files
  if [[ "$FILE" == *.env.example ]] || [[ "$FILE" == *.env.sample ]]; then
    continue
  fi
  
  # Get staged content
  git show ":$FILE" > "$TEMP_FILE" 2>/dev/null || continue
  
  # Check for each pattern
  for PATTERN in "${SECRET_PATTERNS[@]}"; do
    if grep -EnH "$PATTERN" "$TEMP_FILE" 2>/dev/null; then
      echo "⚠️  Potential secret found in $FILE"
      FOUND_SECRETS=true
    fi
  done
done

rm -f "$TEMP_FILE"

if [ "$FOUND_SECRETS" = true ]; then
  echo ""
  echo "❌ Potential secrets detected in staged files!"
  echo "Please review and remove any sensitive data before committing."
  echo ""
  echo "If these are false positives, you can:"
  echo "1. Use environment variables instead"
  echo "2. Add the file to .gitignore"
  echo "3. Use .env.example for sample configurations"
  exit 1
fi

echo "✅ No secrets detected in staged files"