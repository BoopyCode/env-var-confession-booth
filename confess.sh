#!/bin/bash
# Env Var Confession Booth - Where your secrets come to repent
# Usage: ./confess.sh [directory]

# The priest is in, sinners
PRIEST="\e[33m⛪\e[0m"
SINNER="\e[31m😈\e[0m"
FORGIVEN="\e[32m😇\e[0m"

# Default to current dir if none specified
DIR="${1:-.}"

# Find all the .env files hiding in shame
ENV_FILES=$(find "$DIR" -name ".env*" -type f 2>/dev/null)

if [ -z "$ENV_FILES" ]; then
    echo -e "${PRIEST} No sinners found. Are you... perfect?"
    exit 0
fi

# The confession begins
echo -e "${PRIEST} Welcome to the Env Var Confession Booth"
echo -e "${PRIEST} Let us begin the audit of your sins..."

TOTAL_SECRETS=0
TOTAL_FILES=0

for FILE in $ENV_FILES; do
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    # Count the secrets (lines with = that aren't empty or comments)
    SECRETS=$(grep -E '^[^#].*=' "$FILE" 2>/dev/null | wc -l)
    
    if [ "$SECRETS" -gt 0 ]; then
        echo -e "${SINNER} $(basename "$FILE"): $SECRETS secrets found"
        TOTAL_SECRETS=$((TOTAL_SECRETS + SECRETS))
        
        # Show a sneak peek of the first 3 sins
        echo -e "   First 3 confessions:"
        grep -E '^[^#].*=' "$FILE" 2>/dev/null | head -3 | sed 's/^/     /'
    else
        echo -e "${FORGIVEN} $(basename "$FILE"): Empty or all commented"
    fi
    echo

done

# The final judgment
echo -e "${PRIEST} Confession complete!"
echo -e "${PRIEST} Total files examined: $TOTAL_FILES"

echo -n -e "${PRIEST} Total secrets found: "
if [ "$TOTAL_SECRETS" -gt 10 ]; then
    echo -e "\e[31m$TOTAL_SECRETS\e[0m (Repent!)"
elif [ "$TOTAL_SECRETS" -gt 0 ]; then
    echo -e "\e[33m$TOTAL_SECRETS\e[0m (Minor sins)"
else
    echo -e "\e[32m$TOTAL_SECRETS\e[0m (Saintly!)"
fi

echo -e "\n${PRIEST} Go forth and sin no more. Or at least use a secrets manager."