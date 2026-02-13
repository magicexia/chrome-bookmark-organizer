# Customization Guide

This guide shows you how to customize the Chrome Bookmark Organizer to fit your specific needs.

## Custom Categories

### Creating Your Own Categories

The organizer uses keyword matching to classify bookmarks. You can create your own categories and keywords.

#### Step 1: Copy the Example Config

```bash
cp examples/category_rules.json ./my_categories.json
```

#### Step 2: Edit Your Categories

Open `my_categories.json` in your favorite text editor:

```json
{
  "Work": [
    "jira", "confluence", "slack", "zoom", "office365",
    "company-name", "work-related-domain"
  ],

  "Personal Finance": [
    "bank", "credit-card", "investment", "401k", "ira",
    "mint", "personalcapital", "robinhood"
  ],

  "Recipes": [
    "recipe", "cooking", "food", "allrecipes", "foodnetwork",
    "ingredients", "meal", "dinner"
  ]
}
```

#### Step 3: Use Your Custom Config

```bash
python3 scripts/clean_bookmark_optimizer.py -c my_categories.json
```

---

## Keyword Strategy

### Best Practices

1. **Use lowercase**: All matching is case-insensitive, but keep config lowercase for consistency

2. **Include domain names**: Add the main part of URLs you frequently bookmark
   ```json
   "Photography": ["flickr", "500px", "unsplash", "photography"]
   ```

3. **Add variations**: Include different forms of the same concept
   ```json
   "Technology": ["tech", "technology", "technical", "computing"]
   ```

4. **Be specific**: More specific keywords reduce misclassification
   ```json
   "Machine Learning": ["pytorch", "tensorflow", "keras", "ml", "neural"]
   ```

5. **Use TLDs for academic sites**: Many universities use `.edu`
   ```json
   "Academic": [".edu", "scholar", "arxiv", "jstor", "pubmed"]
   ```

---

## Category Design Patterns

### By Interest Area

Organize by your hobbies and interests:

```json
{
  "Photography": ["camera", "lens", "photography", "photo"],
  "Woodworking": ["woodworking", "tools", "lumber", "diy"],
  "Gaming": ["steam", "gaming", "game", "xbox", "playstation"]
}
```

### By Professional Role

Organize by work-related categories:

```json
{
  "Frontend Development": ["react", "vue", "angular", "css", "html"],
  "Backend Development": ["node", "python", "django", "flask", "api"],
  "DevOps": ["docker", "kubernetes", "aws", "terraform", "jenkins"],
  "Design": ["figma", "sketch", "adobe", "design", "ui", "ux"]
}
```

### By Project

Organize by specific projects you're working on:

```json
{
  "Project Alpha": ["alpha", "client-name", "specific-api"],
  "Side Project Beta": ["beta", "hobby-project", "github.com/you/beta"],
  "Research Paper": ["arxiv", "scholar", "research-topic"]
}
```

### Mixed Approach

Combine different strategies:

```json
{
  "Daily Tools": ["gmail", "calendar", "drive", "dropbox"],
  "Learning Resources": ["course", "tutorial", "documentation"],
  "Entertainment": ["youtube", "netflix", "gaming"],
  "Work - Current Sprint": ["jira-sprint-123", "confluence-project"]
}
```

---

## Advanced Customization

### Multi-word Keywords

Use phrases for more precise matching:

```json
{
  "Data Science": [
    "data science", "machine learning", "data analysis",
    "jupyter", "pandas", "numpy", "sklearn"
  ]
}
```

Note: Spaces work fine in keywords - they'll match anywhere in the URL or bookmark name.

### Domain-Specific Rules

Create highly specific rules for your most common sites:

```json
{
  "Google Services": [
    "docs.google", "drive.google", "mail.google",
    "calendar.google", "sheets.google"
  ],

  "GitHub Projects": [
    "github.com/myusername", "github.com/myorg"
  ],

  "AWS Console": [
    "console.aws.amazon", "s3.console", "ec2.console"
  ]
}
```

### Handling Overlaps

When keywords might overlap, order matters. More specific categories should come first:

```json
{
  "Machine Learning Papers": [
    "arxiv.org/abs", "openreview", "neurips", "icml", "cvpr"
  ],

  "General Papers": [
    "paper", "pdf", "research"
  ]
}
```

---

## Testing Your Configuration

### 1. Run with Your Config

```bash
python3 scripts/clean_bookmark_optimizer.py -c my_categories.json
```

### 2. Review the Report

Check the generated report to see classification accuracy:

```bash
cat bookmark_organization_report_*.txt
```

Look for:
- **High Uncategorized count**: Add more keywords
- **Categories with very few bookmarks**: Consider merging or removing
- **Unexpected classifications**: Refine your keywords

### 3. Iterate

Based on the report, adjust your keywords:

1. Check which bookmarks are uncategorized
2. Add relevant keywords to capture them
3. Re-run the organizer
4. Verify improvements

---

## Example: Building Custom Config from Scratch

### Step 1: Analyze Your Bookmarks

Run the organizer with default settings first:

```bash
python3 scripts/clean_bookmark_optimizer.py
```

### Step 2: Review Uncategorized

Look at the "Uncategorized" bookmarks in Chrome after import. Identify common themes.

### Step 3: Create Categories

Based on your analysis, create categories:

```json
{
  "Category1": ["keyword1", "keyword2"],
  "Category2": ["keyword3", "keyword4"]
}
```

### Step 4: Add Keywords Incrementally

Start with obvious keywords, then add more specific ones:

```json
{
  "Web Development": [
    // Start with obvious ones
    "html", "css", "javascript",

    // Add frameworks
    "react", "vue", "angular",

    // Add common domains
    "mdn", "w3schools", "css-tricks",

    // Add specific resources
    "codepen", "jsfiddle", "codesandbox"
  ]
}
```

### Step 5: Test and Refine

Re-run with your config and check the classification accuracy. Aim for 85%+.

---

## Tips & Tricks

### Tip 1: Use Bookmark Analysis

Before creating custom rules, analyze your bookmark patterns:

```bash
# Extract domains from your bookmarks
python3 scripts/clean_bookmark_optimizer.py 2>&1 | grep "Uncategorized"
```

### Tip 2: Balance Category Count

- **Too many categories** (20+): Hard to navigate
- **Too few categories** (3-5): Hard to find specific bookmarks
- **Sweet spot**: 8-15 categories

### Tip 3: Periodic Review

Update your categories every few months:

1. Run the organizer
2. Check uncategorized bookmarks
3. Add new keywords for emerging interests
4. Remove outdated categories

### Tip 4: Keep a Keywords Journal

When you discover a useful keyword, add it to a notes file:

```
Keywords to add:
- "kaggle" → Data Science
- "leetcode" → Coding Practice
- "dribbble" → Design Inspiration
```

Then update your config periodically.

### Tip 5: Share Configs

If you work in a team, share your category configs:

```bash
# Export your config
cp my_categories.json team_bookmarks_config.json

# Share via git
git add team_bookmarks_config.json
git commit -m "Add team bookmark categories"
```

---

## Troubleshooting Classification

### Problem: Too Many Uncategorized Bookmarks

**Solution**: Add more keywords, especially domain names

```bash
# Check what domains are uncategorized
# Look at the report file
grep -A 50 "Uncategorized" bookmark_organization_report_*.txt
```

### Problem: Wrong Category Assignment

**Solution**: Make keywords more specific

```bash
# If "amazon" matches both Shopping and AWS:
{
  "Cloud Services": ["aws", "console.aws", "ec2", "s3"],
  "Shopping": ["amazon.com/gp", "amazon.com/dp"]
}
```

### Problem: Categories Too Broad

**Solution**: Split into subcategories

```bash
# Before:
"Technology": ["all", "tech", "keywords"]

# After:
"Web Development": ["frontend", "javascript", "css"],
"Data Science": ["python", "jupyter", "pandas"],
"Cloud & DevOps": ["aws", "docker", "kubernetes"]
```

---

## Advanced: Programmatic Generation

For power users: generate configs programmatically

```python
import json
from collections import Counter
from urllib.parse import urlparse

# Analyze your bookmarks
with open('Bookmarks', 'r') as f:
    data = json.load(f)

# Extract domains
domains = []
# ... extract logic ...

# Find most common domains
common_domains = Counter(domains).most_common(50)

# Generate config
config = {
    'Top Sites': [domain for domain, count in common_domains if count > 5]
}

with open('auto_categories.json', 'w') as f:
    json.dump(config, f, indent=2)
```

---

## Example Configs

### Minimalist (5 categories)

```json
{
  "Work": ["work", "office", "company"],
  "Learning": ["course", "tutorial", "learn", "education"],
  "Entertainment": ["youtube", "netflix", "game", "music"],
  "Tools": ["tool", "utility", "productivity"],
  "Reference": ["docs", "api", "documentation", "wiki"]
}
```

### Detailed (15 categories)

```json
{
  "Web Dev Frontend": ["react", "vue", "css", "html", "javascript"],
  "Web Dev Backend": ["node", "python", "django", "api", "database"],
  "Mobile Dev": ["ios", "android", "swift", "kotlin", "flutter"],
  "Data Science": ["jupyter", "pandas", "ml", "tensorflow", "kaggle"],
  "DevOps": ["docker", "kubernetes", "aws", "terraform", "jenkins"],
  "Design": ["figma", "sketch", "design", "ui", "ux"],
  "Learning": ["course", "tutorial", "mooc", "education"],
  "News": ["news", "blog", "article", "medium"],
  "Entertainment": ["youtube", "netflix", "game", "music"],
  "Shopping": ["amazon", "ebay", "shop", "store"],
  "Social": ["twitter", "linkedin", "reddit", "forum"],
  "Tools": ["tool", "utility", "productivity", "chrome"],
  "Finance": ["bank", "invest", "crypto", "trading"],
  "Health": ["health", "fitness", "medical", "wellness"],
  "Travel": ["travel", "hotel", "flight", "airbnb"]
}
```

---

## Next Steps

- Experiment with different category structures
- Share your configs with the community
- Contribute example configs via GitHub pull requests

For more help, see:
- [Usage Guide](usage.md)
- [Troubleshooting Guide](troubleshooting.md)
