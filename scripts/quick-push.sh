#!/bin/bash

# Tiation Terminal Workflows - Quick Push Script
# Fast automation for pushing changes in current repository
# Author: Tia Astor <tiatheone@protonmail.com>

set -euo pipefail

# Colors for terminal output (dark neon theme)
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check if we're in a git repository
if [[ ! -d ".git" ]]; then
    print_color "$RED" "❌ Error: Not in a git repository"
    exit 1
fi

# Get repository name
REPO_NAME=$(basename "$(pwd)")
BRANCH=$(git branch --show-current)

print_color "$MAGENTA" "🚀 Quick Push - $REPO_NAME"
print_color "$CYAN" "Branch: $BRANCH"

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    print_color "$YELLOW" "📋 Uncommitted changes detected"
    
    # Show what will be committed
    git status --porcelain
    
    # Get commit message from user input or use default
    if [[ $# -gt 0 ]]; then
        COMMIT_MSG="$*"
    else
        print_color "$CYAN" "Enter commit message (or press Enter for auto-message):"
        read -r COMMIT_MSG
        if [[ -z "$COMMIT_MSG" ]]; then
            COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M:%S')"
        fi
    fi
    
    # Add all changes
    print_color "$YELLOW" "📝 Adding all changes..."
    git add .
    
    # Commit changes
    print_color "$YELLOW" "💾 Committing changes..."
    git commit -m "$COMMIT_MSG"
    
    print_color "$GREEN" "✅ Changes committed: $COMMIT_MSG"
fi

# Check for unpushed commits
UNPUSHED=$(git log origin/"$BRANCH"..HEAD --oneline 2>/dev/null | wc -l || echo "0")

if [[ $UNPUSHED -gt 0 ]]; then
    print_color "$MAGENTA" "🚀 Pushing $UNPUSHED commit(s) to origin/$BRANCH"
    
    if git push origin "$BRANCH"; then
        print_color "$GREEN" "✅ Successfully pushed to GitHub!"
        
        # Show recent commits
        print_color "$CYAN" "Recent commits:"
        git log --oneline -3
    else
        print_color "$RED" "❌ Failed to push to GitHub"
        exit 1
    fi
else
    print_color "$GREEN" "✅ Repository is already up to date"
fi

print_color "$MAGENTA" "🎉 Quick push completed for $REPO_NAME"
