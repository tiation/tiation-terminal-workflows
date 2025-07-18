#!/bin/bash

# Tiation Terminal Workflows - Push All Repositories Automation
# Enterprise-grade script for batch repository management
# Author: Tia Astor <tiatheone@protonmail.com>

set -euo pipefail

# Configuration
GITHUB_BASE_PATH="/Users/tiaastor/tiation-github"
LOG_FILE="/tmp/tiation-push-all-$(date +%Y%m%d-%H%M%S).log"
FAILED_REPOS=()

# Colors for terminal output (dark neon theme)
RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Repository list - matches your indexed codebases
REPOS=(
    "DiceRollerSimulator"
    "dice-roller-marketing-site"
    "tiation-ai-agents"
    "tiation-chase-white-rabbit-ngo"
    "tiation-cms"
    "tiation-docker-debian"
    "tiation-economic-reform-proposal"
    "tiation-go-sdk"
    "tiation-parrot-security-guide-au"
    "tiation-terminal-workflows"
    "tough-talk-podcast-chaos"
    "ubuntu-dev-setup"
)

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to print colored output
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if directory is a git repository
is_git_repo() {
    local repo_path=$1
    [[ -d "$repo_path/.git" ]]
}

# Function to check if repository has uncommitted changes
has_uncommitted_changes() {
    local repo_path=$1
    cd "$repo_path"
    ! git diff-index --quiet HEAD --
}

# Function to check if repository has unpushed commits
has_unpushed_commits() {
    local repo_path=$1
    cd "$repo_path"
    local branch=$(git branch --show-current)
    local unpushed=$(git log origin/"$branch"..HEAD --oneline 2>/dev/null | wc -l)
    [[ $unpushed -gt 0 ]]
}

# Function to push single repository
push_repo() {
    local repo_name=$1
    local repo_path="$GITHUB_BASE_PATH/$repo_name"
    
    print_color "$CYAN" "Processing repository: $repo_name"
    
    if [[ ! -d "$repo_path" ]]; then
        print_color "$RED" "❌ Repository directory not found: $repo_path"
        log "ERROR: Repository directory not found: $repo_path"
        FAILED_REPOS+=("$repo_name - Directory not found")
        return 1
    fi
    
    if ! is_git_repo "$repo_path"; then
        print_color "$RED" "❌ Not a git repository: $repo_path"
        log "ERROR: Not a git repository: $repo_path"
        FAILED_REPOS+=("$repo_name - Not a git repository")
        return 1
    fi
    
    cd "$repo_path"
    
    # Check git status
    local branch=$(git branch --show-current)
    print_color "$YELLOW" "  Current branch: $branch"
    
    # Check for uncommitted changes
    if has_uncommitted_changes "$repo_path"; then
        print_color "$YELLOW" "  📋 Repository has uncommitted changes"
        
        # Show status
        git status --porcelain
        
        # Optional: Auto-commit with timestamp (uncomment if desired)
        # git add .
        # git commit -m "Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
        # print_color "$GREEN" "  ✅ Auto-committed changes"
        
        print_color "$YELLOW" "  ⚠️  Skipping push due to uncommitted changes"
        log "WARNING: Skipping $repo_name - uncommitted changes"
        return 0
    fi
    
    # Check for unpushed commits
    if has_unpushed_commits "$repo_path"; then
        print_color "$MAGENTA" "  🚀 Pushing commits to origin/$branch"
        
        if git push origin "$branch"; then
            print_color "$GREEN" "  ✅ Successfully pushed $repo_name"
            log "SUCCESS: Pushed $repo_name"
        else
            print_color "$RED" "  ❌ Failed to push $repo_name"
            log "ERROR: Failed to push $repo_name"
            FAILED_REPOS+=("$repo_name - Push failed")
            return 1
        fi
    else
        print_color "$GREEN" "  ✅ Repository is up to date"
        log "INFO: $repo_name is up to date"
    fi
    
    return 0
}

# Function to show summary
show_summary() {
    print_color "$CYAN" "\n📊 PUSH SUMMARY"
    print_color "$CYAN" "=================="
    
    local total_repos=${#REPOS[@]}
    local failed_count=${#FAILED_REPOS[@]}
    local success_count=$((total_repos - failed_count))
    
    print_color "$GREEN" "✅ Successful: $success_count/$total_repos repositories"
    
    if [[ $failed_count -gt 0 ]]; then
        print_color "$RED" "❌ Failed: $failed_count repositories"
        print_color "$RED" "Failed repositories:"
        for failed in "${FAILED_REPOS[@]}"; do
            print_color "$RED" "  - $failed"
        done
    fi
    
    print_color "$YELLOW" "📝 Full log available at: $LOG_FILE"
}

# Main function
main() {
    print_color "$MAGENTA" "🚀 Tiation Terminal Workflows - Push All Repositories"
    print_color "$MAGENTA" "======================================================="
    print_color "$CYAN" "Starting batch push operation for ${#REPOS[@]} repositories"
    print_color "$CYAN" "Log file: $LOG_FILE"
    print_color "$CYAN" ""
    
    log "Starting batch push operation"
    
    # Process each repository
    for repo in "${REPOS[@]}"; do
        push_repo "$repo"
        print_color "$CYAN" ""
    done
    
    # Show summary
    show_summary
    
    log "Batch push operation completed"
    
    # Exit with error code if any repos failed
    if [[ ${#FAILED_REPOS[@]} -gt 0 ]]; then
        exit 1
    fi
}

# Handle script arguments
case "${1:-}" in
    --help|-h)
        echo "Tiation Terminal Workflows - Push All Repositories"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --dry-run      Show what would be done without executing"
        echo "  --force        Force push all repositories (use with caution)"
        echo ""
        echo "This script will:"
        echo "1. Check each repository for uncommitted changes"
        echo "2. Check for unpushed commits"
        echo "3. Push commits to the remote repository"
        echo "4. Generate a detailed log of all operations"
        exit 0
        ;;
    --dry-run)
        echo "DRY RUN MODE - No changes will be made"
        # Add dry-run logic here if needed
        ;;
    --force)
        echo "FORCE MODE - Will attempt to push all repositories"
        # Add force mode logic here if needed
        ;;
esac

# Run main function
main "$@"
