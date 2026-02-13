#!/usr/bin/env python3
"""
Chrome Bookmark Organizer
A tool to clean, deduplicate, and intelligently organize Chrome bookmarks
"""

import json
import os
import time
import sys
import argparse
from datetime import datetime
from urllib.parse import urlparse
from collections import defaultdict
from pathlib import Path

# Default classification rules (can be overridden with config file)
DEFAULT_CLASSIFICATION_RULES = {
    'Technology': [
        'github', 'stackoverflow', 'tech', 'programming', 'code', 'dev',
        'python', 'javascript', 'java', 'api', 'docker', 'kubernetes'
    ],
    'Entertainment': [
        'youtube', 'netflix', 'movie', 'video', 'music', 'spotify',
        'gaming', 'game', 'steam', 'twitch'
    ],
    'News': [
        'news', 'bbc', 'cnn', 'nytimes', 'medium', 'blog', 'article'
    ],
    'Education': [
        'learn', 'course', 'tutorial', 'mooc', 'coursera', 'edx',
        'education', 'study', 'university', '.edu'
    ],
    'Tools': [
        'tool', 'utility', 'converter', 'generator', 'extension',
        'chrome', 'productivity'
    ],
    'Shopping': [
        'amazon', 'ebay', 'shop', 'store', 'buy', 'shopping',
        'alibaba', 'etsy'
    ],
    'Social': [
        'facebook', 'twitter', 'instagram', 'linkedin', 'reddit',
        'social', 'community', 'forum'
    ],
    'Books': [
        'book', 'library', 'reading', 'goodreads', 'kindle',
        'ebook', 'pdf', 'literature'
    ]
}

# Sensitive content keywords (optional filtering)
SENSITIVE_KEYWORDS = [
    'adult', 'nsfw', '18+', 'xxx'
]


def get_chrome_bookmarks_path():
    """Auto-detect Chrome bookmarks file location"""
    home = Path.home()

    # macOS
    mac_path = home / 'Library/Application Support/Google/Chrome/Default/Bookmarks'
    if mac_path.exists():
        return str(mac_path)

    # Linux
    linux_path = home / '.config/google-chrome/Default/Bookmarks'
    if linux_path.exists():
        return str(linux_path)

    # Windows
    if os.name == 'nt':
        win_path = home / 'AppData/Local/Google/Chrome/User Data/Default/Bookmarks'
        if win_path.exists():
            return str(win_path)

    return None


def load_classification_rules(config_file=None):
    """Load classification rules from config file or use defaults"""
    if config_file and os.path.exists(config_file):
        try:
            with open(config_file, 'r', encoding='utf-8') as f:
                rules = json.load(f)
            print(f"✓ Loaded custom classification rules from {config_file}")
            return rules
        except Exception as e:
            print(f"⚠️  Failed to load config file: {e}")
            print("Using default classification rules...")

    return DEFAULT_CLASSIFICATION_RULES


def load_bookmarks(file_path):
    """Load bookmarks from JSON file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"❌ Error loading bookmarks: {e}")
        sys.exit(1)


def save_bookmarks(bookmarks, file_path):
    """Save bookmarks to JSON file"""
    try:
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(bookmarks, f, ensure_ascii=False, indent=2)
    except Exception as e:
        print(f"❌ Error saving bookmarks: {e}")
        sys.exit(1)


def extract_all_bookmarks(node, path=""):
    """Recursively extract all bookmarks, removing folder structure"""
    bookmarks = []

    if 'children' not in node:
        return bookmarks

    for item in node['children']:
        if item.get('type') == 'url':
            bookmarks.append({
                'item': item,
                'original_path': path
            })
        elif item.get('type') == 'folder':
            folder_name = item.get('name', 'Unknown')
            bookmarks.extend(extract_all_bookmarks(
                item,
                f"{path}/{folder_name}" if path else folder_name
            ))

    return bookmarks


def is_sensitive_content(url, name):
    """Check if bookmark contains sensitive content"""
    text = f"{url} {name}".lower()
    for keyword in SENSITIVE_KEYWORDS:
        if keyword.lower() in text:
            return True
    return False


def classify_bookmark(url, name, classification_rules):
    """
    Classify bookmark based on URL and name
    Returns: (category_name, matched_keyword) or (None, None)
    """
    text = f"{url} {name}".lower()

    # Check for sensitive content first
    if is_sensitive_content(url, name):
        return 'Sensitive', 'sensitive_content'

    # Try to match classification rules
    for category, keywords in classification_rules.items():
        for keyword in keywords:
            if keyword.lower() in text:
                return category, keyword

    return None, None


def remove_duplicates(bookmarks):
    """Remove duplicate bookmarks, keeping the earliest"""
    seen_urls = {}
    unique_bookmarks = []
    duplicates = []

    for bm in bookmarks:
        url = bm['item'].get('url', '')
        if not url:
            unique_bookmarks.append(bm)
            continue

        if url in seen_urls:
            duplicates.append(bm)
        else:
            seen_urls[url] = True
            unique_bookmarks.append(bm)

    return unique_bookmarks, duplicates


def create_folder(name, children=None):
    """Create a new bookmark folder"""
    timestamp = int(time.time() * 1000000) + 13000000000000000
    folder = {
        "children": children or [],
        "date_added": str(timestamp),
        "date_last_used": "0",
        "date_modified": str(timestamp),
        "guid": f"{name.lower().replace(' ', '-')}-{int(time.time())}",
        "id": str(int(time.time() * 1000)),
        "name": name,
        "type": "folder"
    }
    return folder


def main():
    parser = argparse.ArgumentParser(
        description='Chrome Bookmark Organizer - Clean and organize your bookmarks'
    )
    parser.add_argument(
        '-i', '--input',
        help='Input bookmarks file (auto-detected if not specified)'
    )
    parser.add_argument(
        '-o', '--output',
        help='Output file (default: Bookmarks_clean_optimized_TIMESTAMP.json)'
    )
    parser.add_argument(
        '-c', '--config',
        help='Custom classification rules JSON file'
    )
    parser.add_argument(
        '--backup-dir',
        default='./bookmarks_backup',
        help='Backup directory (default: ./bookmarks_backup)'
    )
    parser.add_argument(
        '--no-sensitive-filter',
        action='store_true',
        help='Disable sensitive content filtering'
    )

    args = parser.parse_args()

    print("=" * 80)
    print("🚀 Chrome Bookmark Organizer")
    print("=" * 80)
    print()

    # Determine input file
    if args.input:
        input_file = args.input
    else:
        input_file = get_chrome_bookmarks_path()
        if not input_file:
            print("❌ Could not auto-detect Chrome bookmarks file")
            print("Please specify input file with -i option")
            sys.exit(1)

    if not os.path.exists(input_file):
        print(f"❌ Input file not found: {input_file}")
        sys.exit(1)

    print(f"📂 Input file: {input_file}")

    # Create backup
    backup_dir = Path(args.backup_dir)
    backup_dir.mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = backup_dir / f"Bookmarks_backup_{timestamp}.json"

    import shutil
    shutil.copy2(input_file, backup_file)
    print(f"✓ Backup created: {backup_file}")

    # Load classification rules
    classification_rules = load_classification_rules(args.config)
    print(f"✓ Using {len(classification_rules)} categories")

    # Load bookmarks
    print("\n📦 Loading bookmarks...")
    original_data = load_bookmarks(input_file)

    # Extract bookmarks from "Other Bookmarks"
    other_bookmarks = original_data['roots']['other']
    all_bookmarks = extract_all_bookmarks(other_bookmarks)
    print(f"✓ Extracted {len(all_bookmarks)} bookmarks")

    # Remove duplicates
    print("\n🔍 Removing duplicates...")
    unique_bookmarks, duplicates = remove_duplicates(all_bookmarks)
    print(f"✓ Original: {len(all_bookmarks)}")
    print(f"✓ Duplicates: {len(duplicates)}")
    print(f"✓ Unique: {len(unique_bookmarks)}")

    # Classify bookmarks
    print("\n🎯 Classifying bookmarks...")
    classified = defaultdict(list)

    for bm in unique_bookmarks:
        url = bm['item'].get('url', '')
        name = bm['item'].get('name', '')

        category, keyword = classify_bookmark(url, name, classification_rules)

        if category:
            classified[category].append(bm['item'])
        else:
            classified['Uncategorized'].append(bm['item'])

    # Display classification results
    print("\n✅ Classification complete:")
    total_classified = 0
    for cat in sorted(classification_rules.keys()):
        count = len(classified.get(cat, []))
        if count > 0:
            total_classified += count
            print(f"  • {cat:20s}: {count:3d} bookmarks")

    if not args.no_sensitive_filter:
        sensitive_count = len(classified.get('Sensitive', []))
        if sensitive_count > 0:
            print(f"  • {'Sensitive':20s}: {sensitive_count:3d} bookmarks")

    uncategorized_count = len(classified.get('Uncategorized', []))
    print(f"  • {'Uncategorized':20s}: {uncategorized_count:3d} bookmarks")

    accuracy = (total_classified / len(unique_bookmarks) * 100) if unique_bookmarks else 0
    print(f"\n📊 Classification accuracy: {accuracy:.1f}%")

    # Create new bookmark structure
    print("\n🔨 Creating clean bookmark structure...")
    new_other_children = []

    # Create folders for each category
    for category in sorted(classification_rules.keys()):
        if category in classified and len(classified[category]) > 0:
            folder = create_folder(category, classified[category])
            new_other_children.append(folder)
            print(f"  ✓ Created [{category}] folder: {len(classified[category])} bookmarks")

    # Handle sensitive content
    if not args.no_sensitive_filter and len(classified.get('Sensitive', [])) > 0:
        # Create as subfolder under Uncategorized
        uncategorized_children = classified.get('Uncategorized', []).copy()
        sensitive_folder = create_folder('Sensitive', classified['Sensitive'])
        uncategorized_children.append(sensitive_folder)

        uncategorized_folder = create_folder('Uncategorized', uncategorized_children)
        new_other_children.append(uncategorized_folder)
        print(f"  ✓ Created [Uncategorized] with Sensitive subfolder")
    elif len(classified.get('Uncategorized', [])) > 0:
        uncategorized_folder = create_folder('Uncategorized', classified['Uncategorized'])
        new_other_children.append(uncategorized_folder)
        print(f"  ✓ Created [Uncategorized] folder: {uncategorized_count} bookmarks")

    # Create new bookmarks data
    new_bookmarks_data = {
        "checksum": original_data.get("checksum", ""),
        "roots": {
            "bookmark_bar": original_data['roots']['bookmark_bar'],
            "other": {
                "children": new_other_children,
                "date_added": original_data['roots']['other'].get('date_added'),
                "date_last_used": "0",
                "date_modified": str(int(time.time() * 1000000) + 13000000000000000),
                "guid": original_data['roots']['other'].get('guid', 'other_bookmark_folder'),
                "id": original_data['roots']['other'].get('id', '2'),
                "name": "Other Bookmarks",
                "type": "folder"
            },
            "synced": original_data['roots'].get('synced', {
                "children": [],
                "date_added": "0",
                "id": "3",
                "name": "Mobile Bookmarks",
                "type": "folder"
            })
        },
        "version": original_data.get("version", 1)
    }

    # Determine output file
    if args.output:
        output_file = args.output
    else:
        output_file = f"Bookmarks_clean_optimized_{timestamp}.json"

    # Save
    save_bookmarks(new_bookmarks_data, output_file)
    print(f"\n💾 Saved clean bookmarks: {output_file}")

    # Generate report
    report_file = f"bookmark_organization_report_{timestamp}.txt"
    with open(report_file, 'w', encoding='utf-8') as f:
        f.write("=" * 80 + "\n")
        f.write("Chrome Bookmark Organization Report\n")
        f.write("=" * 80 + "\n")
        f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write("=" * 80 + "\n\n")

        f.write("📊 Statistics\n")
        f.write("-" * 80 + "\n")
        f.write(f"Original bookmarks: {len(all_bookmarks)}\n")
        f.write(f"Duplicates removed: {len(duplicates)}\n")
        f.write(f"Unique bookmarks: {len(unique_bookmarks)}\n")
        f.write(f"Categories created: {len([c for c in classification_rules.keys() if c in classified])}\n")
        f.write(f"Classification accuracy: {accuracy:.1f}%\n\n")

        f.write("📁 Categories\n")
        f.write("-" * 80 + "\n")
        for category in sorted(classification_rules.keys()):
            if category in classified:
                count = len(classified[category])
                f.write(f"{category}: {count} bookmarks\n")

        if 'Uncategorized' in classified:
            f.write(f"Uncategorized: {len(classified['Uncategorized'])} bookmarks\n")

        f.write("\n" + "=" * 80 + "\n")

    print(f"📊 Report generated: {report_file}")

    # Summary
    print("\n" + "=" * 80)
    print("🎉 Organization complete!")
    print("=" * 80)
    print(f"\n📂 Output file: {output_file}")
    print(f"📊 Report: {report_file}")
    print(f"💾 Backup: {backup_file}")
    print()
    print("Next steps:")
    print("  1. Review the generated report")
    print("  2. Import bookmarks using the import script")
    print("  3. Verify in Chrome bookmark manager")
    print()


if __name__ == '__main__':
    main()
