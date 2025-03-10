# gh-coauthor

A GitHub CLI extension to easily add co-authors to your latest commit.

## Overview

`gh-coauthor` is a command-line tool that makes it easy to add GitHub users as co-authors to your most recent Git commit. It automatically fetches user information from GitHub API and formats the co-authored-by trailer according to Git standards.

## Installation

### Prerequisites

- [Git](https://git-scm.com/)
- [GitHub CLI](https://cli.github.com/)

### Installing as a GitHub CLI extension

```bash
gh extension install hsbt/gh-coauthor
```

### Manual Installation

1. Clone this repository
   ```bash
   git clone https://github.com/hsbt/gh-coauthor.git
   ```

2. Make the script executable
   ```bash
   chmod +x gh-coauthor/gh-coauthor
   ```

3. Add the script to your PATH

## Usage

Add a GitHub user as co-author to your most recent commit:

```bash
gh coauthor <username>
```

Show the tool version:

```bash
gh coauthor version
```

Display help information:

```bash
gh coauthor --help
```

Enable shell completion:

```bash
source <(gh coauthor completion)
```

### Examples

```bash
# Add GitHub user 'pocke' as co-author to the latest commit
gh coauthor pocke

# Show version information
gh coauthor version
```

## Environment Variables

- `COAUTHOR_DEBUG=1` - Enable debug output

## How it works

`gh-coauthor` automatically:

1. Retrieves user details from the GitHub API
2. Tries to find the user's email using various methods:
   - From GitHub API (if public)
   - From existing git history
   - Falls back to GitHub's noreply email format
3. Amends the most recent commit to add the co-author trailer

## Acknowledgments

The original script for this tool was created by [pocke](https://github.com/pocke) and is available at [https://gist.github.com/pocke/c54be87893aefa2be76abe1b2a4cdca5](https://gist.github.com/pocke/c54be87893aefa2be76abe1b2a4cdca5).

The command structure and organization were inspired by [gh-signoff](https://github.com/basecamp/gh-signoff) from Basecamp.

## License

[MIT](LICENSE)
