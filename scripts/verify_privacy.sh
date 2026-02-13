#!/bin/bash
#
# Privacy Verification Script
# Checks the project for any personal/private information before publishing
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo ""
    echo "=========================================================================="
    echo "$1"
    echo "=========================================================================="
    echo ""
}

print_result() {
    local status=$1
    local message=$2

    if [[ "$status" == "PASS" ]]; then
        echo -e "${GREEN}✓ PASS${NC}: $message"
    elif [[ "$status" == "WARN" ]]; then
        echo -e "${YELLOW}⚠ WARN${NC}: $message"
    else
        echo -e "${RED}✗ FAIL${NC}: $message"
    fi
}

ISSUES=0
WARNINGS=0

print_header "🔍 Privacy Verification for GitHub Publishing"

# Check 1: No actual bookmark files
echo "Checking for bookmark files..."
if find . -name "Bookmarks" -o -name "Bookmarks.bak" -o -name "*bookmark*.json" | grep -v "examples/" | grep -v ".git" | grep -q .; then
    print_result "FAIL" "Found bookmark files that should be excluded"
    find . -name "Bookmarks" -o -name "Bookmarks.bak" -o -name "*bookmark*.json" | grep -v "examples/" | grep -v ".git"
    ((ISSUES++))
else
    print_result "PASS" "No bookmark files found (good!)"
fi

# Check 2: No backup directories with data
echo ""
echo "Checking for backup directories..."
if [[ -d "bookmarks_backup" ]] && [[ -n "$(ls -A bookmarks_backup 2>/dev/null)" ]]; then
    print_result "FAIL" "bookmarks_backup/ directory contains files"
    ls -lh bookmarks_backup/
    ((ISSUES++))
else
    print_result "PASS" "No backup data found"
fi

# Check 3: No report files
echo ""
echo "Checking for report files..."
if ls bookmark_organization_report_*.txt 2>/dev/null | grep -q .; then
    print_result "FAIL" "Found report files that should be excluded"
    ls -lh bookmark_organization_report_*.txt
    ((ISSUES++))
else
    print_result "PASS" "No report files found"
fi

# Check 4: No user-specific paths
echo ""
echo "Checking for hardcoded user paths..."
if grep -r "/Users/[^/]*" --include="*.py" --include="*.sh" --include="*.md" . | grep -v ".git" | grep -v "verify_privacy.sh" | grep -q .; then
    print_result "WARN" "Found potential user-specific paths:"
    grep -r "/Users/[^/]*" --include="*.py" --include="*.sh" --include="*.md" . | grep -v ".git" | grep -v "verify_privacy.sh"
    ((WARNINGS++))
else
    print_result "PASS" "No hardcoded user paths found"
fi

# Check 5: No personal email addresses
echo ""
echo "Checking for email addresses..."
if grep -r -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" --include="*.py" --include="*.sh" --include="*.md" . | grep -v ".git" | grep -v "verify_privacy" | grep -v "noreply@" | grep -q .; then
    print_result "WARN" "Found email addresses (check if personal):"
    grep -r -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" --include="*.py" --include="*.sh" --include="*.md" . | grep -v ".git" | grep -v "verify_privacy" | grep -v "noreply@"
    ((WARNINGS++))
else
    print_result "PASS" "No personal email addresses found"
fi

# Check 6: No Chinese/personal category names in code
echo ""
echo "Checking for personal category names in code..."
if grep -r -E "(ACG|化学|NJU|观点|设计|工具|影片|图书)" --include="*.py" . | grep -v ".git" | grep -q .; then
    print_result "FAIL" "Found personal Chinese category names in code"
    grep -r -E "(ACG|化学|NJU|观点|设计|工具|影片|图书)" --include="*.py" . | grep -v ".git"
    ((ISSUES++))
else
    print_result "PASS" "No personal category names in code"
fi

# Check 7: Verify .gitignore exists and is correct
echo ""
echo "Checking .gitignore..."
if [[ ! -f ".gitignore" ]]; then
    print_result "FAIL" ".gitignore file not found"
    ((ISSUES++))
else
    if grep -q "*.json" .gitignore && grep -q "bookmarks_backup/" .gitignore; then
        print_result "PASS" ".gitignore properly configured"
    else
        print_result "WARN" ".gitignore may be incomplete"
        ((WARNINGS++))
    fi
fi

# Check 8: Verify README uses generic examples
echo ""
echo "Checking README for generic content..."
if [[ -f "README.md" ]]; then
    if grep -q "yourusername\|your-org\|example" README.md; then
        print_result "PASS" "README uses generic placeholders"
    else
        print_result "WARN" "README may need more generic examples"
        ((WARNINGS++))
    fi
else
    print_result "FAIL" "README.md not found"
    ((ISSUES++))
fi

# Check 9: Verify LICENSE exists
echo ""
echo "Checking for LICENSE file..."
if [[ -f "LICENSE" ]]; then
    print_result "PASS" "LICENSE file exists"
else
    print_result "WARN" "LICENSE file not found"
    ((WARNINGS++))
fi

# Check 10: Verify documentation exists
echo ""
echo "Checking documentation..."
REQUIRED_DOCS=("docs/installation.md" "docs/usage.md" "docs/troubleshooting.md" "docs/customization.md")
for doc in "${REQUIRED_DOCS[@]}"; do
    if [[ -f "$doc" ]]; then
        print_result "PASS" "$doc exists"
    else
        print_result "WARN" "$doc not found"
        ((WARNINGS++))
    fi
done

# Check 11: Verify examples directory
echo ""
echo "Checking examples..."
if [[ -f "examples/category_rules.json" ]]; then
    print_result "PASS" "Example configuration exists"
else
    print_result "WARN" "Example configuration not found"
    ((WARNINGS++))
fi

# Check 12: Verify scripts are executable
echo ""
echo "Checking script permissions..."
for script in scripts/*.sh scripts/*.py; do
    if [[ -f "$script" ]]; then
        if [[ -x "$script" ]]; then
            print_result "PASS" "$script is executable"
        else
            print_result "WARN" "$script is not executable (chmod +x needed)"
            ((WARNINGS++))
        fi
    fi
done

# Summary
print_header "📊 Verification Summary"

echo -e "${RED}Critical Issues: $ISSUES${NC}"
echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
echo ""

if [[ $ISSUES -gt 0 ]]; then
    echo -e "${RED}❌ FAILED: Please fix critical issues before publishing${NC}"
    echo ""
    echo "Actions required:"
    echo "  1. Remove any private bookmark files"
    echo "  2. Remove personal category names from code"
    echo "  3. Ensure .gitignore is properly configured"
    echo "  4. Add missing required files (README, LICENSE, etc.)"
    echo ""
    exit 1
elif [[ $WARNINGS -gt 0 ]]; then
    echo -e "${YELLOW}⚠️  PASSED with warnings${NC}"
    echo ""
    echo "Consider addressing warnings before publishing:"
    echo "  • Review any found user paths or emails"
    echo "  • Ensure documentation is complete"
    echo "  • Make scripts executable with: chmod +x scripts/*.sh scripts/*.py"
    echo ""
    echo "Project is safe to publish, but improvements recommended."
    exit 0
else
    echo -e "${GREEN}✅ PERFECT! No issues found${NC}"
    echo ""
    echo "Project is ready for GitHub publishing!"
    echo ""
    echo "Next steps:"
    echo "  1. Review the code one final time"
    echo "  2. Create GitHub repository"
    echo "  3. git add ."
    echo "  4. git commit -m 'Initial commit'"
    echo "  5. git push origin main"
    echo ""
    exit 0
fi
