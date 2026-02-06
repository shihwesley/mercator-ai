#!/bin/bash
# release.sh — Bump version, commit, tag, push, and create GitHub release.
#
# Usage:
#   ./scripts/release.sh patch    # 1.0.0 → 1.0.1 (bug fix)
#   ./scripts/release.sh minor    # 1.0.0 → 1.1.0 (new feature)
#   ./scripts/release.sh major    # 1.0.0 → 2.0.0 (breaking change)
#
# What it does:
#   1. Reads current version from plugin.json
#   2. Bumps version according to semver type
#   3. Updates plugin.json and marketplace.json
#   4. Commits, tags, pushes
#   5. Creates a GitHub release (prompts for release notes)
#
# Requirements: jq, gh (GitHub CLI)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PLUGIN_JSON="$ROOT_DIR/.claude-plugin/plugin.json"
MARKETPLACE_JSON="$ROOT_DIR/.claude-plugin/marketplace.json"

# --- Validate ---

if [ $# -lt 1 ]; then
  echo "Usage: $0 <patch|minor|major> [release notes]"
  echo ""
  echo "Examples:"
  echo "  $0 patch                          # 1.0.0 → 1.0.1"
  echo "  $0 minor                          # 1.0.0 → 1.1.0"
  echo "  $0 major                          # 1.0.0 → 2.0.0"
  echo "  $0 minor 'Added new --watch flag' # with inline release notes"
  exit 1
fi

BUMP_TYPE="$1"
RELEASE_NOTES="${2:-}"

if [[ "$BUMP_TYPE" != "patch" && "$BUMP_TYPE" != "minor" && "$BUMP_TYPE" != "major" ]]; then
  echo "Error: bump type must be patch, minor, or major"
  exit 1
fi

command -v jq >/dev/null 2>&1 || { echo "Error: jq is required. Install with: brew install jq"; exit 1; }
command -v gh >/dev/null 2>&1 || { echo "Error: gh (GitHub CLI) is required. Install with: brew install gh"; exit 1; }

# --- Check clean working tree ---

cd "$ROOT_DIR"
if [ -n "$(git status --porcelain)" ]; then
  echo "Error: working tree is not clean. Commit or stash changes first."
  git status --short
  exit 1
fi

# --- Read current version ---

CURRENT_VERSION=$(jq -r '.version' "$PLUGIN_JSON")
echo "Current version: $CURRENT_VERSION"

# --- Bump version ---

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

case "$BUMP_TYPE" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version:     $NEW_VERSION"
echo ""

# --- Confirm ---

read -p "Release v$NEW_VERSION? [y/N] " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# --- Update version in plugin.json ---

jq --arg v "$NEW_VERSION" '.version = $v' "$PLUGIN_JSON" > "$PLUGIN_JSON.tmp" && mv "$PLUGIN_JSON.tmp" "$PLUGIN_JSON"

# --- Update version in marketplace.json ---

jq --arg v "$NEW_VERSION" '
  .metadata.version = $v |
  .plugins[0].version = $v
' "$MARKETPLACE_JSON" > "$MARKETPLACE_JSON.tmp" && mv "$MARKETPLACE_JSON.tmp" "$MARKETPLACE_JSON"

echo "Updated plugin.json and marketplace.json → v$NEW_VERSION"

# --- Get release notes ---

if [ -z "$RELEASE_NOTES" ]; then
  echo ""
  echo "Enter release notes (what changed). Press Ctrl+D when done:"
  RELEASE_NOTES=$(cat)
fi

# --- Commit, tag, push ---

git add "$PLUGIN_JSON" "$MARKETPLACE_JSON"
git commit -m "v$NEW_VERSION — $RELEASE_NOTES"
git tag -a "v$NEW_VERSION" -m "v$NEW_VERSION"
git push && git push --tags

echo ""
echo "Pushed v$NEW_VERSION to origin."

# --- Create GitHub release ---

gh release create "v$NEW_VERSION" \
  --title "Mercator AI v$NEW_VERSION" \
  --notes "$RELEASE_NOTES"

echo ""
echo "Done! Release live at:"
gh release view "v$NEW_VERSION" --json url -q '.url'
echo ""
echo "Users update with:"
echo "  /plugin marketplace update mercator-ai"
echo "  /plugin update mercator-ai@mercator-ai"
