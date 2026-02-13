#!/bin/bash
#
# Chrome Bookmark Import Wizard
# Guides users through safely importing organized bookmarks
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect Chrome bookmarks path
detect_chrome_path() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        echo "$HOME/.config/google-chrome/Default/Bookmarks"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows
        echo "$LOCALAPPDATA/Google/Chrome/User Data/Default/Bookmarks"
    else
        echo ""
    fi
}

# Print colored message
print_msg() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

# Print header
print_header() {
    echo ""
    echo "=========================================================================="
    echo "$1"
    echo "=========================================================================="
    echo ""
}

# Check if Chrome is running
check_chrome_running() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        pgrep -x "Google Chrome" > /dev/null && return 0 || return 1
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        pgrep -x "chrome" > /dev/null && return 0 || return 1
    else
        # Windows - assume not running for now
        return 1
    fi
}

# Close Chrome
close_chrome() {
    print_msg "$YELLOW" "Closing Chrome..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        killall "Google Chrome" 2>/dev/null || true
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        killall chrome 2>/dev/null || true
    else
        print_msg "$RED" "Please close Chrome manually on Windows"
        read -p "Press Enter when Chrome is closed..."
    fi

    sleep 2
    print_msg "$GREEN" "✓ Chrome closed"
}

# Main script
main() {
    print_header "📚 Chrome Bookmark Import Wizard"

    # Detect Chrome bookmarks path
    CHROME_BOOKMARKS=$(detect_chrome_path)

    if [[ -z "$CHROME_BOOKMARKS" ]]; then
        print_msg "$RED" "❌ Could not detect Chrome bookmarks location"
        echo "Please specify the path manually:"
        read -p "Chrome Bookmarks path: " CHROME_BOOKMARKS
    fi

    print_msg "$BLUE" "Chrome Bookmarks: $CHROME_BOOKMARKS"
    echo ""

    # Find organized bookmark files
    ORGANIZED_FILES=$(ls -t Bookmarks_clean_optimized_*.json 2>/dev/null | head -1)

    if [[ -z "$ORGANIZED_FILES" ]]; then
        print_msg "$RED" "❌ No organized bookmark files found"
        echo "Please run the organizer first:"
        echo "  python3 scripts/clean_bookmark_optimizer.py"
        exit 1
    fi

    print_msg "$GREEN" "✓ Found organized bookmarks: $ORGANIZED_FILES"
    echo ""

    # Show file info
    print_msg "$BLUE" "File information:"
    ls -lh "$ORGANIZED_FILES" | awk '{print "  Size: " $5 ", Modified: " $6 " " $7 " " $8}'
    echo ""

    # Important warning
    print_header "⚠️  IMPORTANT: Delete Old Bookmarks First"

    cat << EOF
Before importing, you need to DELETE your old bookmarks in Chrome to avoid
duplication and sync conflicts.

${YELLOW}Step-by-step instructions:${NC}

${GREEN}Option 1: Delete All at Once (Fastest)${NC}
  1. Open Chrome Bookmark Manager:
     • macOS: Press Cmd + Shift + O
     • Windows/Linux: Press Ctrl + Shift + O

  2. In the Bookmark Manager, look at the left sidebar

  3. Click on "Other Bookmarks" folder

  4. ${RED}⚠️  DO NOT select "Bookmarks bar" - leave it unchanged!${NC}

  5. In the right pane, select all bookmarks under "Other Bookmarks":
     • macOS: Press Cmd + A
     • Windows/Linux: Press Ctrl + A

  6. Press Delete (or Backspace) to remove all selected items

  7. Confirm the deletion

${GREEN}Option 2: Delete Individual Folders${NC}
  1. Open Chrome Bookmark Manager (Cmd+Shift+O or Ctrl+Shift+O)

  2. In "Other Bookmarks", you'll see your old folders

  3. Right-click each folder → "Delete"

  4. Repeat for all folders you want to replace

${BLUE}Important Notes:${NC}
  • Your Bookmarks Bar will NOT be affected
  • You can undo with Cmd+Z (or Ctrl+Z) immediately after deletion
  • This step is crucial to avoid duplicates and sync conflicts

EOF

    read -p "Have you deleted your old bookmarks? (y/N): " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_msg "$YELLOW" "Please delete old bookmarks first, then run this script again."
        exit 0
    fi

    print_msg "$GREEN" "✓ Old bookmarks deleted"
    echo ""

    # Import method selection
    print_header "📥 Import Method"

    cat << EOF
Choose import method:

${GREEN}1. Direct File Replacement (Recommended)${NC}
   - Fastest method
   - Replaces Chrome bookmarks file directly
   - Requires Chrome to be closed

${BLUE}2. Manual Import via Chrome UI${NC}
   - Slower but more visual
   - Import through Chrome's Bookmark Manager
   - Adds to existing bookmarks (make sure you deleted old ones!)

EOF

    read -p "Choose method (1 or 2): " -n 1 -r
    echo ""
    echo ""

    case $REPLY in
        1)
            # Direct replacement
            print_header "🔄 Direct File Replacement"

            # Check if Chrome is running
            if check_chrome_running; then
                print_msg "$YELLOW" "Chrome is running. It needs to be closed for safe import."
                read -p "Close Chrome now? (y/N): " -n 1 -r
                echo ""

                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    close_chrome
                else
                    print_msg "$RED" "Please close Chrome manually, then run this script again."
                    exit 0
                fi
            else
                print_msg "$GREEN" "✓ Chrome is not running"
            fi

            # Create backup
            print_msg "$YELLOW" "Creating backup of current bookmarks..."
            BACKUP_DIR="$HOME/bookmarks_backup"
            mkdir -p "$BACKUP_DIR"
            TIMESTAMP=$(date +%Y%m%d_%H%M%S)
            BACKUP_FILE="$BACKUP_DIR/Bookmarks_before_import_$TIMESTAMP.json"

            if [[ -f "$CHROME_BOOKMARKS" ]]; then
                cp "$CHROME_BOOKMARKS" "$BACKUP_FILE"
                print_msg "$GREEN" "✓ Backup created: $BACKUP_FILE"
            else
                print_msg "$YELLOW" "⚠️  No existing bookmarks file found (fresh install?)"
            fi

            # Replace bookmarks file
            print_msg "$YELLOW" "Copying organized bookmarks to Chrome..."
            cp "$ORGANIZED_FILES" "$CHROME_BOOKMARKS"
            print_msg "$GREEN" "✓ Bookmarks file replaced"

            # Open Chrome
            echo ""
            print_msg "$BLUE" "Starting Chrome..."

            if [[ "$OSTYPE" == "darwin"* ]]; then
                open -a "Google Chrome"
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                google-chrome &
            else
                print_msg "$YELLOW" "Please open Chrome manually"
            fi

            print_msg "$GREEN" "✓ Import complete!"
            ;;

        2)
            # Manual import
            print_header "📂 Manual Import Instructions"

            cat << EOF
${GREEN}Follow these steps:${NC}

1. Open Chrome (if not already open)

2. Open Bookmark Manager:
   • macOS: Press Cmd + Shift + O
   • Windows/Linux: Press Ctrl + Shift + O

3. Click the three-dot menu (⋮) in the top right

4. Select "Import bookmarks"

5. Browse to and select this file:
   ${BLUE}$ORGANIZED_FILES${NC}

6. Click "Open" or "Import"

7. Verify your bookmarks in the Bookmark Manager

${YELLOW}Note: This will ADD bookmarks to your current ones. Make sure you
deleted old bookmarks first!${NC}

EOF

            read -p "Press Enter to open the file location in Finder/Explorer..."

            if [[ "$OSTYPE" == "darwin"* ]]; then
                open -R "$ORGANIZED_FILES"
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                xdg-open "$(dirname "$ORGANIZED_FILES")"
            fi

            print_msg "$GREEN" "✓ Ready to import manually"
            ;;

        *)
            print_msg "$RED" "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    # Final verification
    echo ""
    print_header "✅ Verification Checklist"

    cat << EOF
Please verify in Chrome Bookmark Manager:

  □ Bookmark Bar is unchanged
  □ "Other Bookmarks" has new organized folders
  □ No duplicate bookmarks
  □ All bookmarks are accessible
  □ Categories make sense

${BLUE}Troubleshooting:${NC}
  • If something went wrong, see docs/troubleshooting.md
  • To restore backup: cp $BACKUP_FILE "$CHROME_BOOKMARKS"

${GREEN}Next steps:${NC}
  • Review the classification report
  • Customize categories if needed (docs/customization.md)
  • Keep backups for at least a week

EOF

    print_msg "$GREEN" "🎉 Import process complete!"
    echo ""
}

# Run main function
main
