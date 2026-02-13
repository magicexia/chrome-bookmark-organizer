# Usage Guide

## Quick Start

The simplest way to use the tool:

```bash
cd chrome-bookmark-organizer
python3 scripts/clean_bookmark_optimizer.py
```

This will:
1. Auto-detect your Chrome bookmarks
2. Create a backup
3. Organize your bookmarks
4. Generate a clean output file
5. Create a detailed report

## Step-by-Step Guide

### Step 1: Run the Optimizer

```bash
python3 scripts/clean_bookmark_optimizer.py
```

**What happens**:
- The script finds your Chrome bookmarks automatically
- Creates a backup in `bookmarks_backup/`
- Extracts all bookmarks from "Other Bookmarks"
- Removes duplicates
- Categorizes based on URL and name
- Generates a clean file with flat folder structure

**Output files**:
- `Bookmarks_clean_optimized_TIMESTAMP.json` - Your organized bookmarks
- `bookmark_organization_report_TIMESTAMP.txt` - Detailed report
- `bookmarks_backup/Bookmarks_backup_TIMESTAMP.json` - Safety backup

### Step 2: Review the Report

Open the generated report file:

```bash
cat bookmark_organization_report_*.txt
```

Check:
- How many bookmarks were processed
- How many duplicates were removed
- Category distribution
- Classification accuracy

### Step 3: Import to Chrome

**Option A: Using Chrome's Import Function** (Safe, Recommended for first time)

1. Open Chrome
2. Press `Cmd + Shift + O` (macOS) or `Ctrl + Shift + O` (Windows/Linux)
3. Click the ⋮ menu → "Import bookmarks"
4. Select the `Bookmarks_clean_optimized_*.json` file
5. Done!

Note: This will ADD bookmarks to your existing ones. You may want to delete old bookmarks first.

**Option B: Direct File Replacement** (After testing)

```bash
# 1. Close Chrome completely
killall "Google Chrome"  # macOS
# or
taskkill /F /IM chrome.exe  # Windows

# 2. Backup current bookmarks (just in case)
cp ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks \
   ~/Desktop/Bookmarks_original_backup.json

# 3. Replace with organized version
cp Bookmarks_clean_optimized_*.json \
   ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks

# 4. Restart Chrome
open -a "Google Chrome"  # macOS
```

### Step 4: Verify Results

In Chrome Bookmark Manager (Cmd+Shift+O):

Check that:
- ✅ Bookmark Bar is unchanged
- ✅ "Other Bookmarks" has clean categories
- ✅ No duplicate bookmarks
- ✅ Folders are organized logically

## Advanced Usage

### Specify Input File

```bash
python3 scripts/clean_bookmark_optimizer.py -i /path/to/bookmarks.json
```

### Specify Output File

```bash
python3 scripts/clean_bookmark_optimizer.py -o my_clean_bookmarks.json
```

### Use Custom Categories

```bash
# 1. Create custom config
cp examples/category_rules.json ./my_categories.json

# 2. Edit my_categories.json with your categories

# 3. Run with custom config
python3 scripts/clean_bookmark_optimizer.py -c my_categories.json
```

### Change Backup Directory

```bash
python3 scripts/clean_bookmark_optimizer.py --backup-dir ~/my_backups
```

### Disable Sensitive Content Filter

```bash
python3 scripts/clean_bookmark_optimizer.py --no-sensitive-filter
```

## Command-Line Options

```
usage: clean_bookmark_optimizer.py [-h] [-i INPUT] [-o OUTPUT] [-c CONFIG]
                                   [--backup-dir BACKUP_DIR]
                                   [--no-sensitive-filter]

options:
  -h, --help            Show help message and exit
  -i INPUT, --input INPUT
                        Input bookmarks file (auto-detected if not specified)
  -o OUTPUT, --output OUTPUT
                        Output file (default: Bookmarks_clean_optimized_TIMESTAMP.json)
  -c CONFIG, --config CONFIG
                        Custom classification rules JSON file
  --backup-dir BACKUP_DIR
                        Backup directory (default: ./bookmarks_backup)
  --no-sensitive-filter
                        Disable sensitive content filtering
```

## Common Workflows

### Workflow 1: First-Time User

```bash
# 1. Run optimizer with defaults
python3 scripts/clean_bookmark_optimizer.py

# 2. Review the report
cat bookmark_organization_report_*.txt

# 3. Test import (safe method)
# Open Chrome → Bookmarks Manager → Import
# Select the generated file

# 4. If satisfied, delete old bookmarks manually
# Then import again for clean slate
```

### Workflow 2: Custom Categories

```bash
# 1. Copy example config
cp examples/category_rules.json ./my_rules.json

# 2. Edit my_rules.json
nano my_rules.json

# 3. Run with custom rules
python3 scripts/clean_bookmark_optimizer.py -c my_rules.json

# 4. Import to Chrome
```

### Workflow 3: Process Exported Bookmarks

```bash
# 1. Export bookmarks from Chrome
# Chrome → Bookmarks → Bookmark Manager → Export

# 2. Run optimizer on exported file
python3 scripts/clean_bookmark_optimizer.py -i ~/Downloads/bookmarks_exported.html

# 3. Import the cleaned version
```

## Tips & Best Practices

### Before Running

- ✅ Close unnecessary Chrome windows
- ✅ Make sure you have 10+ minutes
- ✅ Review default categories in the script

### After Running

- ✅ Always review the report first
- ✅ Test with Chrome's import function before direct replacement
- ✅ Keep the backup files for at least a week
- ✅ Verify bookmarks in Chrome before deleting backups

### Customization

- ✅ Add domain-specific keywords for better accuracy
- ✅ Create categories that match your workflow
- ✅ Keep category names short and clear
- ✅ Use both domain names and general keywords

### Maintenance

- ✅ Run the optimizer monthly to remove new duplicates
- ✅ Update category rules as your interests change
- ✅ Archive old reports after verification

## Troubleshooting

If you encounter issues, see the [Troubleshooting Guide](troubleshooting.md).

Common issues:
- Chrome bookmarks file not found → Specify with `-i`
- Permission denied → Check file permissions
- Import doesn't work → Make sure Chrome is closed for direct replacement

## Next Steps

- Learn about [Customization](customization.md)
- Set up [Cloud Sync](cloud-sync.md) (coming soon)
- Explore advanced features in [Advanced Usage](advanced.md) (coming soon)
