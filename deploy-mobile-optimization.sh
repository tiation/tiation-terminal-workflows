#!/bin/bash

# Mobile Optimization Deployment Script for Tiation GitHub Pages Sites
# This script applies mobile optimization to all repositories with web content

set -e

echo "🚀 Starting mobile optimization deployment across all repositories..."

# Base directory for all repositories
BASE_DIR="/Users/tiaastor/tiation-github"
TEMPLATE_DIR="${BASE_DIR}/tiation-terminal-workflows"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to log messages
log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if a file exists
file_exists() {
    [[ -f "$1" ]]
}

# Function to check if a directory exists
dir_exists() {
    [[ -d "$1" ]]
}

# Function to add viewport meta tag if missing
add_viewport_meta() {
    local file="$1"
    
    if ! grep -q "viewport" "$file"; then
        # Add viewport meta tag after charset
        sed -i '' '/charset=/a\
    <meta name="viewport" content="width=device-width, initial-scale=1.0">' "$file"
        log "Added viewport meta tag to $file"
    fi
}

# Function to add mobile optimization to HTML file
optimize_html_file() {
    local file="$1"
    local repo_name="$2"
    
    log "Processing HTML file: $file"
    
    # Add viewport meta tag if missing
    add_viewport_meta "$file"
    
    # Check if mobile optimization is already present
    if grep -q "mobile-menu-toggle" "$file"; then
        warn "Mobile optimization already present in $file"
        return 0
    fi
    
    # Add mobile menu toggle button to navigation
    if grep -q "<nav" "$file"; then
        # Add mobile menu toggle button before closing nav tag
        sed -i '' 's|</nav>|<button class="mobile-menu-toggle" aria-label="Toggle mobile menu">☰</button>\
        </nav>\
        <nav class="mobile-nav" id="mobile-nav">\
            <ul>\
                <li><a href="#home">Home</a></li>\
                <li><a href="#about">About</a></li>\
                <li><a href="#contact">Contact</a></li>\
                <li><a href="https://github.com/tiation/'$repo_name'">GitHub</a></li>\
            </ul>\
        </nav>|' "$file"
        log "Added mobile navigation to $file"
    fi
    
    # Add mobile optimization CSS before closing head tag
    if grep -q "</head>" "$file"; then
        # Create mobile CSS content
        cat << 'EOF' > /tmp/mobile-styles.css
        /* Mobile hamburger menu */
        .mobile-menu-toggle {
            display: none;
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #333;
            padding: 0.5rem;
        }

        .mobile-nav {
            display: none;
            position: fixed;
            top: 70px;
            left: 0;
            right: 0;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            z-index: 999;
        }

        .mobile-nav.active {
            display: block;
        }

        .mobile-nav ul {
            list-style: none;
            padding: 1rem 0;
            margin: 0;
        }

        .mobile-nav li {
            border-bottom: 1px solid #eee;
        }

        .mobile-nav a {
            display: block;
            padding: 1rem 2rem;
            text-decoration: none;
            font-weight: 500;
        }

        .mobile-nav a:hover {
            background: #f8f9fa;
        }

        /* Responsive breakpoints */
        @media (max-width: 1200px) {
            .container {
                padding: 0 15px;
            }
            
            .grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .mobile-menu-toggle {
                display: block;
            }
            
            .nav-links {
                display: none;
            }
            
            .container {
                padding: 0 15px;
            }
            
            .grid {
                grid-template-columns: 1fr;
            }
            
            h1 { font-size: 2rem; }
            h2 { font-size: 1.75rem; }
            h3 { font-size: 1.5rem; }
            
            section {
                padding: 60px 0;
            }
            
            .btn {
                display: block;
                width: 100%;
                margin: 10px 0;
                padding: 14px 20px;
            }
        }
        
        @media (max-width: 480px) {
            .container {
                padding: 0 10px;
            }
            
            h1 { font-size: 1.75rem; }
            h2 { font-size: 1.5rem; }
            
            section {
                padding: 40px 0;
            }
        }
        
        /* Touch device optimizations */
        @media (hover: none) and (pointer: coarse) {
            .btn {
                padding: 14px 28px;
                min-height: 48px;
            }
            
            a, button {
                min-height: 44px;
                min-width: 44px;
            }
        }
        
        /* Landscape mobile optimizations */
        @media (max-width: 768px) and (orientation: landscape) {
            section {
                padding: 40px 0;
            }
            
            h1 { font-size: 1.8rem; }
        }
EOF
        
        # Insert styles before closing head tag
        sed -i '' '/</head>/i\
    <style>' "$file"
        sed -i '' '/</head>/i\
'"$(cat /tmp/mobile-styles.css)"'' "$file"
        sed -i '' '/</head>/i\
    </style>' "$file"
        
        rm /tmp/mobile-styles.css
        log "Added mobile optimization CSS to $file"
    fi
    
    # Add mobile menu JavaScript before closing body tag
    if grep -q "</body>" "$file"; then
        cat << 'EOF' > /tmp/mobile-script.js
        // Mobile menu functionality
        document.addEventListener('DOMContentLoaded', function() {
            const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
            const mobileNav = document.querySelector('.mobile-nav');
            
            if (mobileMenuToggle && mobileNav) {
                mobileMenuToggle.addEventListener('click', function() {
                    mobileNav.classList.toggle('active');
                });
                
                // Close mobile menu when clicking on a link
                document.querySelectorAll('.mobile-nav a').forEach(function(link) {
                    link.addEventListener('click', function() {
                        mobileNav.classList.remove('active');
                    });
                });
                
                // Close mobile menu when clicking outside
                document.addEventListener('click', function(e) {
                    if (!mobileMenuToggle.contains(e.target) && !mobileNav.contains(e.target)) {
                        mobileNav.classList.remove('active');
                    }
                });
            }
        });
EOF
        
        # Insert script before closing body tag
        sed -i '' '/</body>/i\
    <script>' "$file"
        sed -i '' '/</body>/i\
'"$(cat /tmp/mobile-script.js)"'' "$file"
        sed -i '' '/</body>/i\
    </script>' "$file"
        
        rm /tmp/mobile-script.js
        log "Added mobile menu JavaScript to $file"
    fi
}

# Function to optimize Jekyll _config.yml
optimize_jekyll_config() {
    local config_file="$1"
    
    if file_exists "$config_file"; then
        log "Optimizing Jekyll config: $config_file"
        
        # Add mobile-friendly plugins if not present
        if ! grep -q "jekyll-responsive-image" "$config_file"; then
            echo "" >> "$config_file"
            echo "# Mobile optimization plugins" >> "$config_file"
            echo "plugins:" >> "$config_file"
            echo "  - jekyll-responsive-image" >> "$config_file"
            echo "  - jekyll-seo-tag" >> "$config_file"
            echo "  - jekyll-sitemap" >> "$config_file"
            echo "" >> "$config_file"
            echo "# Mobile-friendly settings" >> "$config_file"
            echo "responsive_image:" >> "$config_file"
            echo "  template: _includes/responsive-image.html" >> "$config_file"
            echo "  default_quality: 85" >> "$config_file"
            echo "  sizes:" >> "$config_file"
            echo "    - width: 480" >> "$config_file"
            echo "    - width: 800" >> "$config_file"
            echo "    - width: 1200" >> "$config_file"
            
            log "Added mobile optimization settings to Jekyll config"
        fi
    fi
}

# Function to process a single repository
process_repository() {
    local repo_path="$1"
    local repo_name=$(basename "$repo_path")
    
    log "Processing repository: $repo_name"
    
    # Skip if not a directory
    if ! dir_exists "$repo_path"; then
        warn "Skipping $repo_name - not a directory"
        return 0
    fi
    
    # Skip if no web content
    if ! ls "$repo_path"/*.html "$repo_path"/docs/*.html "$repo_path"/index.* 2>/dev/null | head -1; then
        warn "Skipping $repo_name - no web content found"
        return 0
    fi
    
    # Process HTML files
    find "$repo_path" -name "*.html" -not -path "*/node_modules/*" -not -path "*/.git/*" | while read -r html_file; do
        optimize_html_file "$html_file" "$repo_name"
    done
    
    # Process Jekyll config files
    find "$repo_path" -name "_config.yml" -not -path "*/.git/*" | while read -r config_file; do
        optimize_jekyll_config "$config_file"
    done
    
    # Create mobile optimization indicator file
    echo "Mobile optimization applied on $(date)" > "$repo_path/.mobile-optimized"
    
    log "✅ Completed optimization for $repo_name"
}

# Main execution
main() {
    log "Starting mobile optimization deployment..."
    
    # Check if base directory exists
    if ! dir_exists "$BASE_DIR"; then
        error "Base directory not found: $BASE_DIR"
        exit 1
    fi
    
    # Get list of all repositories
    local repos=()
    while IFS= read -r -d '' repo; do
        repos+=("$repo")
    done < <(find "$BASE_DIR" -maxdepth 1 -type d -name "tiation-*" -print0)
    
    log "Found ${#repos[@]} repositories to process"
    
    # Process each repository
    for repo in "${repos[@]}"; do
        process_repository "$repo"
    done
    
    log "🎉 Mobile optimization deployment completed successfully!"
    log "📱 All repositories are now mobile-optimized with:"
    log "   • Responsive navigation with hamburger menu"
    log "   • Mobile-first responsive breakpoints"
    log "   • Touch-friendly interactions"
    log "   • Viewport meta tags"
    log "   • Mobile-specific CSS optimizations"
    log "   • Accessibility improvements"
    
    echo ""
    echo "Next steps:"
    echo "1. Test each site on mobile devices"
    echo "2. Validate with Google Mobile-Friendly Test"
    echo "3. Check performance with PageSpeed Insights"
    echo "4. Commit and push changes to GitHub"
}

# Run main function
main "$@"
