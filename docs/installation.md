# Installation Guide

## Prerequisites

### System Requirements

- **Operating System**: macOS 10.12+ (Sierra or later)
  - Linux and Windows support coming soon
- **Python**: Version 3.6 or higher
- **Google Chrome**: Any recent version
- **Disk Space**: ~10MB for backups and generated files

### Check Your Python Version

```bash
python3 --version
```

You should see something like `Python 3.x.x`. If not, install Python 3:

**macOS** (using Homebrew):
```bash
brew install python3
```

**Linux**:
```bash
sudo apt-get install python3  # Debian/Ubuntu
sudo yum install python3      # RedHat/CentOS
```

## Installation

### Method 1: Clone from GitHub (Recommended)

```bash
# Clone the repository
git clone https://github.com/magicexia/chrome-bookmark-organizer.git

# Navigate to the project directory
cd chrome-bookmark-organizer

# Make scripts executable
chmod +x scripts/*.py scripts/*.sh
```

### Method 2: Download ZIP

1. Download the ZIP file from [GitHub Releases](https://github.com/magicexia/chrome-bookmark-organizer/releases)
2. Extract the ZIP file
3. Open Terminal and navigate to the extracted folder:
   ```bash
   cd ~/Downloads/chrome-bookmark-organizer
   ```
4. Make scripts executable:
   ```bash
   chmod +x scripts/*.py scripts/*.sh
   ```

## Verify Installation

Run the optimizer with the help flag:

```bash
python3 scripts/clean_bookmark_optimizer.py --help
```

You should see the help message showing available options.

## Optional: Custom Classification Rules

If you want to customize the categories:

1. Copy the example configuration:
   ```bash
   cp examples/category_rules.json ./category_rules.json
   ```

2. Edit `category_rules.json` with your preferred categories and keywords

3. Use the custom config when running:
   ```bash
   python3 scripts/clean_bookmark_optimizer.py -c category_rules.json
   ```

## Project Structure

After installation, you should have:

```
chrome-bookmark-organizer/
├── README.md                     # Main documentation
├── LICENSE                       # MIT License
├── .gitignore                    # Git ignore rules
├── scripts/
│   ├── clean_bookmark_optimizer.py  # Main optimization script
│   ├── import_bookmarks.sh          # Import wizard (coming soon)
│   └── update_cloud_bookmarks.sh    # Cloud sync helper (coming soon)
├── docs/
│   ├── installation.md              # This file
│   ├── usage.md                     # Usage guide
│   ├── troubleshooting.md           # Troubleshooting guide
│   └── customization.md             # Customization guide
├── examples/
│   └── category_rules.json          # Example configuration
└── bookmarks_backup/                # Created automatically for backups
```

## Next Steps

- Read the [Usage Guide](usage.md) to learn how to use the tool
- Review [Customization Guide](customization.md) to tailor categories to your needs
- Check [Troubleshooting Guide](troubleshooting.md) if you encounter issues

## Uninstallation

To remove the tool:

```bash
# Navigate to parent directory
cd ..

# Remove the project folder
rm -rf chrome-bookmark-organizer
```

Your Chrome bookmarks are not affected by uninstalling this tool. All backups created by the tool will also be removed, so make sure to save any important backups elsewhere before uninstalling.
