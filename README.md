# 🚀 Chrome Bookmark Organizer

A powerful, intelligent Chrome bookmark organization tool that helps you clean up, deduplicate, and intelligently categorize your bookmarks.

## ✨ Features

- 🧹 **Automatic Deduplication** - Remove duplicate bookmarks (up to 37% reduction!)
- 🤖 **Smart Categorization** - Intelligent classification based on domain, URL, and content
- 📊 **Detailed Reports** - Comprehensive organization reports with statistics
- 🔄 **Flexible Import** - Multiple import methods with safety backups
- 🌐 **Cloud Sync Support** - Seamlessly update your Chrome cloud bookmarks
- 🎯 **Flat Structure** - Clean, single-level folder organization (no nested folders)
- 🔒 **Safe Operations** - Multiple backup layers before any changes
- 📝 **Interactive Workflow** - Step-by-step guidance through the entire process

## 📊 Results

**Before**: 500+ bookmarks, nested folders, many duplicates, chaotic structure
**After**: Clean categorized bookmarks, 0 duplicates, flat structure, 85%+ accuracy

Example transformation:
```
Before:                          After:
├─ Old Folder 1 (50 bookmarks)   ├─ Technology (45 bookmarks)
├─ Old Folder 2 (30 bookmarks)   ├─ Entertainment (38 bookmarks)
├─ Random (100 bookmarks)        ├─ Education (52 bookmarks)
├─ Uncategorized (200 bookmarks) ├─ News (28 bookmarks)
├─ Duplicates everywhere         ├─ Tools (35 bookmarks)
└─ Nested subfolders...          └─ Other (20 bookmarks)
```

## 🎯 Quick Start

### Prerequisites

- macOS (with Chrome installed)
- Python 3.x
- Bash shell

### Basic Usage

```bash
# 1. Clone the repository
git clone https://github.com/magicexia/chrome-bookmark-organizer.git
cd chrome-bookmark-organizer

# 2. Run the optimizer
python3 scripts/clean_bookmark_optimizer.py

# 3. Import the organized bookmarks
bash scripts/import_bookmarks.sh
```

## 📖 Documentation

- [Installation Guide](docs/installation.md)
- [Usage Guide](docs/usage.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Customization](docs/customization.md)

## 🛠️ Main Scripts

### 1. `clean_bookmark_optimizer.py`
Main optimization script that:
- Extracts bookmarks from Chrome
- Removes duplicates
- Categorizes intelligently
- Generates flat structure
- Creates detailed reports

### 2. `import_bookmarks.sh`
Interactive import wizard that:
- Guides you to delete old bookmarks
- Imports clean organized bookmarks
- Verifies the import
- Creates backups

### 3. `update_cloud_bookmarks.sh`
Cloud sync updater that:
- Helps clear old cloud data
- Uploads clean bookmarks to Chrome sync
- Ensures multi-device consistency

## 🎨 Customization

### Define Your Own Categories

Edit `examples/category_rules.json`:

```json
{
  "Technology": [
    "github", "stackoverflow", "tech", "programming"
  ],
  "Entertainment": [
    "youtube", "netflix", "movie", "music"
  ],
  "Your Category": [
    "keyword1", "keyword2"
  ]
}
```

### Adjust Settings

The optimizer supports various settings:
- Maximum number of categories
- Minimum bookmarks per category
- Custom exclusion rules
- Backup locations

See [Customization Guide](docs/customization.md) for details.

## 📊 What Gets Organized

### Included
- ✅ "Other Bookmarks" folder (fully reorganized)
- ✅ Optional: "Mobile Bookmarks"
- ✅ Duplicate detection across all folders

### Preserved
- ✅ Bookmark Bar (100% unchanged)
- ✅ Original timestamps
- ✅ Bookmark icons/favicons

## 🔄 Workflow

```
┌─────────────────────────────────────┐
│  1. Export & Backup                 │
│     - Auto-detect Chrome bookmarks  │
│     - Create timestamped backup     │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  2. Extract & Deduplicate           │
│     - Remove folder structure       │
│     - Detect duplicate URLs         │
│     - Keep earliest version         │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  3. Intelligent Categorization      │
│     - Analyze domain patterns       │
│     - Match keywords                │
│     - Create categories             │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  4. Generate Clean Structure        │
│     - Flat folders (no nesting)     │
│     - Sorted by category            │
│     - Detailed report               │
└─────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────┐
│  5. Import to Chrome                │
│     - Interactive wizard            │
│     - Safety verification           │
│     - Cloud sync support            │
└─────────────────────────────────────┘
```

## 💾 Backup & Safety

The tool creates multiple backup layers:

1. **Before optimization**: Original Chrome bookmarks
2. **Before import**: Current bookmarks
3. **Automatic backups**: Timestamped in `bookmarks_backup/`

To restore:
```bash
# Restore from specific backup
cp bookmarks_backup/Bookmarks_backup_YYYYMMDD_HHMMSS.json \
   ~/Library/Application\ Support/Google/Chrome/Default/Bookmarks
```

## 🌐 Cloud Sync

### Option 1: Automatic (Recommended)
After importing, Chrome will automatically sync your clean bookmarks to the cloud.

### Option 2: Manual Control
Use the cloud sync updater:
```bash
bash scripts/update_cloud_bookmarks.sh
```

This guides you through:
1. Clearing old cloud data
2. Uploading clean bookmarks
3. Verifying sync across devices

## 📈 Statistics & Reports

After optimization, you'll get a detailed report showing:

- Total bookmarks processed
- Duplicates removed
- Category distribution
- Uncategorized bookmarks
- Before/after comparison

Example:
```
Original bookmarks: 521
Duplicates removed: 193 (37%)
Final bookmarks: 328
Categories created: 10
Categorization accuracy: 85%
```

## 🔧 Requirements

- macOS 10.12+
- Python 3.6+
- Google Chrome
- ~10MB free disk space

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

- Always backup your bookmarks before using this tool
- Test on a small set of bookmarks first
- This tool modifies Chrome bookmark files directly - use at your own risk
- The developer is not responsible for any data loss

## 🙏 Acknowledgments

- Inspired by the need to organize 500+ chaotic bookmarks
- Built with Python and Bash
- Designed for simplicity and safety

## 📞 Support

If you encounter any issues:

1. Check the [Troubleshooting Guide](docs/troubleshooting.md)
2. Search existing [Issues](https://github.com/magicexia/chrome-bookmark-organizer/issues)
3. Open a new issue with detailed information

## 🗺️ Roadmap

- [ ] Support for Windows and Linux
- [ ] Firefox bookmark support
- [ ] GUI interface
- [ ] AI-powered categorization
- [ ] Browser extension version
- [ ] Custom categorization rules editor

## ⭐ Star History

If you find this tool useful, please consider giving it a star!

---

**Made with ❤️ for bookmark organization enthusiasts**
