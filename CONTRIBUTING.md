# Contributing to Chrome Bookmark Organizer

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you encounter a bug or have a feature request:

1. **Search existing issues** to avoid duplicates
2. **Create a new issue** with a clear title and description
3. **Include details**:
   - Operating system and version
   - Python version (`python3 --version`)
   - Chrome version
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
4. **DO NOT include your actual bookmarks** (privacy!)

### Suggesting Enhancements

We welcome suggestions for improvements:

- New classification categories or keywords
- Better algorithms for bookmark organization
- UI/UX improvements
- Performance optimizations
- Additional platform support (Windows, Linux)

## Development Setup

### Prerequisites

- Python 3.6+
- Google Chrome
- Git

### Setting Up Development Environment

```bash
# Clone the repository
git clone https://github.com/magicexia/chrome-bookmark-organizer.git
cd chrome-bookmark-organizer

# Make scripts executable
chmod +x scripts/*.py scripts/*.sh

# Test the script
python3 scripts/clean_bookmark_optimizer.py --help
```

### Testing Your Changes

Before submitting a pull request:

1. **Test on your own bookmarks** (create backups first!)
2. **Verify all features work**:
   ```bash
   # Test basic functionality
   python3 scripts/clean_bookmark_optimizer.py -i test_bookmarks.json -o test_output.json

   # Test custom categories
   python3 scripts/clean_bookmark_optimizer.py -c examples/category_rules.json

   # Test privacy verification
   bash scripts/verify_privacy.sh
   ```

3. **Check for privacy leaks**:
   ```bash
   # Run privacy verification
   bash scripts/verify_privacy.sh
   ```

4. **Ensure code quality**:
   ```bash
   # Check Python syntax
   python3 -m py_compile scripts/clean_bookmark_optimizer.py

   # Check shell script syntax
   bash -n scripts/import_bookmarks.sh
   ```

## Coding Guidelines

### Python Code Style

- Follow PEP 8 style guide
- Use meaningful variable names
- Add docstrings to functions
- Keep functions focused and modular
- Handle errors gracefully

Example:
```python
def classify_bookmark(url, name, classification_rules):
    """
    Classify bookmark based on URL and name

    Args:
        url (str): Bookmark URL
        name (str): Bookmark name
        classification_rules (dict): Category keywords

    Returns:
        tuple: (category_name, matched_keyword) or (None, None)
    """
    # Implementation...
```

### Shell Script Style

- Use `set -e` to exit on errors
- Add comments for complex sections
- Use functions for reusable code
- Provide clear user feedback
- Handle different platforms (macOS, Linux, Windows)

### Documentation

- Update README.md if adding features
- Add usage examples to docs/usage.md
- Add troubleshooting entries to docs/troubleshooting.md
- Keep documentation clear and beginner-friendly

## Pull Request Process

### Before Submitting

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Make your changes**:
   - Write clear, focused commits
   - Add tests if applicable
   - Update documentation

3. **Test thoroughly**:
   - Test on your own bookmarks
   - Run privacy verification
   - Check for regressions

4. **Privacy check**:
   ```bash
   bash scripts/verify_privacy.sh
   ```

5. **Commit with clear messages**:
   ```bash
   git commit -m "Add support for Safari bookmarks

   - Implement Safari bookmark detection
   - Add Safari-specific parsing
   - Update documentation
   "
   ```

### Submitting Pull Request

1. **Push to your fork**:
   ```bash
   git push origin feature/my-new-feature
   ```

2. **Create pull request** on GitHub

3. **Fill out PR template**:
   - Description of changes
   - Related issue number (if applicable)
   - Testing performed
   - Screenshots (if UI changes)

4. **Wait for review**:
   - Address feedback promptly
   - Update PR as needed
   - Be patient and respectful

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Documentation updated (if needed)
- [ ] Tests pass
- [ ] Privacy verification passes
- [ ] No personal data in commits
- [ ] Commit messages are clear
- [ ] PR description is complete

## Types of Contributions

### Bug Fixes

- Fix reported issues
- Add tests to prevent regressions
- Update documentation if behavior changes

### New Features

Discuss major features in an issue first:

- **Classification improvements**: Better algorithms, ML-based classification
- **Platform support**: Windows, Linux, Safari, Firefox
- **Export formats**: HTML, CSV, different JSON formats
- **Visualization**: Statistics, graphs, analysis tools
- **Automation**: Scheduled runs, cloud sync helpers

### Documentation

- Fix typos and grammar
- Add examples and tutorials
- Improve clarity
- Add screenshots or diagrams
- Translate to other languages

### Example Configurations

Share your category configurations:

```bash
# Add to examples/ directory
cp my_awesome_categories.json examples/categories_developer.json
```

Include a comment describing the use case:
```json
{
  "_comment": "Optimized for web developers with focus on frontend technologies",
  "_author": "GitHub username",
  "Frontend": ["react", "vue", "angular"],
  ...
}
```

## Community Guidelines

### Be Respectful

- Be kind and courteous
- Respect different opinions
- Focus on constructive feedback
- Help newcomers

### Privacy First

- **Never** commit actual bookmark files
- **Never** include personal information
- **Always** use generic examples
- Use `verify_privacy.sh` before committing

### Communication

- Use clear, professional language
- Provide context in issues and PRs
- Respond to feedback constructively
- Ask questions if unclear

## Development Roadmap

Interested in major features? Check these areas:

### Short-term (v1.x)

- [ ] Windows and Linux testing
- [ ] Safari bookmark support
- [ ] Firefox bookmark support
- [ ] HTML export format
- [ ] Better duplicate detection (URL normalization)

### Medium-term (v2.x)

- [ ] GUI application (Electron or web-based)
- [ ] Machine learning classification
- [ ] Bookmark analysis and statistics
- [ ] Chrome extension
- [ ] Cloud sync improvements

### Long-term (v3.x)

- [ ] Cross-browser sync
- [ ] Collaborative bookmark collections
- [ ] AI-powered recommendations
- [ ] Mobile app support

## Questions?

- **Documentation**: Check [docs/](docs/) directory
- **Issues**: Search [existing issues](https://github.com/magicexia/chrome-bookmark-organizer/issues)
- **Discussions**: Use [GitHub Discussions](https://github.com/magicexia/chrome-bookmark-organizer/discussions)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Chrome Bookmark Organizer! 🎉
