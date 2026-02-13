# Troubleshooting Guide

## Common Issues and Solutions

### Issue 1: "Could not auto-detect Chrome bookmarks file"

**Symptoms**: Script says it can't find Chrome bookmarks

**Solutions**:

1. **Specify the file manually**:
   ```bash
   python3 scripts/clean_bookmark_optimizer.py -i /path/to/Bookmarks
   ```

2. **Find Chrome bookmarks location**:
   - **macOS**: `~/Library/Application Support/Google/Chrome/Default/Bookmarks`
   - **Linux**: `~/.config/google-chrome/Default/Bookmarks`
   - **Windows**: `%LOCALAPPDATA%\Google\Chrome\User Data\Default\Bookmarks`

3. **Check if Chrome is installed**:
   ```bash
   # macOS
   ls ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks

   # Linux
   ls ~/.config/google-chrome/Default/Bookmarks
   ```

---

### Issue 2: "Permission denied" error

**Symptoms**: Cannot read or write bookmark files

**Solutions**:

1. **Check file permissions**:
   ```bash
   ls -l ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
   ```

2. **Grant read access**:
   ```bash
   chmod +r ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
   ```

3. **Run with appropriate permissions**:
   - Don't use `sudo` unless absolutely necessary
   - Make sure your user account owns the files

---

### Issue 3: Bookmarks not showing in Chrome after import

**Symptoms**: Imported file but bookmarks don't appear

**Solutions**:

1. **Close Chrome completely**:
   ```bash
   # macOS
   killall "Google Chrome"

   # Linux
   killall chrome

   # Windows
   taskkill /F /IM chrome.exe
   ```

2. **Verify file was copied correctly**:
   ```bash
   ls -lh ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
   ```

3. **Check JSON validity**:
   ```bash
   python3 -m json.tool Bookmarks_clean_optimized_*.json > /dev/null
   ```
   If this shows errors, the JSON is malformed.

4. **Restore backup and try again**:
   ```bash
   cp bookmarks_backup/Bookmarks_backup_*.json \
      ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
   ```

---

### Issue 4: Chrome Sync overwrites clean bookmarks

**Symptoms**: After restart, old bookmarks are back

**Solutions**:

1. **Disable Chrome Sync temporarily**:
   - Chrome Settings → Sync and Google Services
   - Turn off "Bookmarks" sync

2. **Clear Chrome sync data**:
   - Visit https://myaccount.google.com/sync
   - Clear "Bookmarks" data
   - Re-enable sync to upload clean bookmarks

3. **Use offline mode**:
   ```bash
   open -a "Google Chrome" --args --disable-sync
   ```

---

### Issue 5: Low classification accuracy

**Symptoms**: Many bookmarks in "Uncategorized"

**Solutions**:

1. **Use custom classification rules**:
   ```bash
   cp examples/category_rules.json ./my_rules.json
   # Edit my_rules.json with better keywords
   python3 scripts/clean_bookmark_optimizer.py -c my_rules.json
   ```

2. **Add domain-specific keywords**:
   - Analyze uncategorized bookmarks in the report
   - Add their domains to appropriate categories
   - Re-run the optimizer

3. **Check your keywords**:
   - Use lowercase keywords
   - Include both domain names and general terms
   - Add variations (e.g., "tech", "technology", "technical")

---

### Issue 6: Duplicates not removed

**Symptoms**: Still seeing duplicate bookmarks

**Solutions**:

1. **Check if URLs are exactly the same**:
   - Some duplicates may have slight URL differences
   - Example: `http://` vs `https://`
   - Example: `www.example.com` vs `example.com`

2. **Manually review duplicates**:
   - The report shows which duplicates were removed
   - Check if the remaining "duplicates" are actually different pages

3. **Re-run after manual cleanup**:
   ```bash
   python3 scripts/clean_bookmark_optimizer.py
   ```

---

### Issue 7: Python version error

**Symptoms**: "SyntaxError" or "python3 not found"

**Solutions**:

1. **Check Python version**:
   ```bash
   python3 --version
   ```
   Should be 3.6 or higher.

2. **Install Python 3**:
   ```bash
   # macOS
   brew install python3

   # Linux
   sudo apt-get install python3
   ```

3. **Use full path**:
   ```bash
   /usr/bin/python3 scripts/clean_bookmark_optimizer.py
   ```

---

### Issue 8: "File not found" after running script

**Symptoms**: Output file wasn't created

**Solutions**:

1. **Check for errors in output**:
   - Review the script output for error messages
   - Look for red error text

2. **Check disk space**:
   ```bash
   df -h .
   ```

3. **Verify write permissions**:
   ```bash
   touch test_write.txt && rm test_write.txt
   ```

4. **Run with explicit output path**:
   ```bash
   python3 scripts/clean_bookmark_optimizer.py -o ~/Desktop/clean_bookmarks.json
   ```

---

## Getting Help

If your issue isn't covered here:

1. **Check existing issues**:
   - Visit https://github.com/magicexia/chrome-bookmark-organizer/issues
   - Search for similar problems

2. **Gather information**:
   - Operating system and version
   - Python version (`python3 --version`)
   - Chrome version
   - Complete error message
   - Steps to reproduce

3. **Open a new issue**:
   - Include all information from step 2
   - Attach relevant log files
   - DO NOT include your actual bookmarks (privacy!)

4. **Community support**:
   - Check the project wiki
   - Ask in discussions

---

## Debug Mode

For detailed debugging:

```bash
# Run with Python's verbose mode
python3 -v scripts/clean_bookmark_optimizer.py

# Or with debugging enabled
python3 -m pdb scripts/clean_bookmark_optimizer.py
```

---

## Recovery

### Restore Original Bookmarks

If something goes wrong:

```bash
# 1. Close Chrome
killall "Google Chrome"

# 2. Restore from backup (choose the most recent)
cp bookmarks_backup/Bookmarks_backup_YYYYMMDD_HHMMSS.json \
   ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks

# 3. Restart Chrome
open -a "Google Chrome"
```

### Start Fresh

To reset and start over:

```bash
# 1. Remove all generated files
rm Bookmarks_clean_optimized_*.json
rm bookmark_organization_report_*.txt

# 2. Clear backups (optional)
rm -rf bookmarks_backup/

# 3. Run again
python3 scripts/clean_bookmark_optimizer.py
```

---

## Still Having Issues?

Contact: [Open an issue on GitHub](https://github.com/magicexia/chrome-bookmark-organizer/issues/new)
