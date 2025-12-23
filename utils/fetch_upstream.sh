#!/bin/bash
set -euo pipefail

# Get project root (parent of utils/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Configuration
UPSTREAM_REPO="https://github.com/facebook/dotslash.git"
UPSTREAM_DIR="$PROJECT_ROOT/upstream"
DEFAULT_COMMIT="dd5fc02536367fcc1edb077375c3fd2841c1ea22"

# Allow overriding the commit via argument or environment variable
COMMIT="${1:-${DOTSLASH_COMMIT:-$DEFAULT_COMMIT}}"

echo "Fetching dotslash upstream @ $COMMIT..."

if [ -d "$UPSTREAM_DIR" ]; then
    echo "Removing existing upstream directory..."
    rm -rf "$UPSTREAM_DIR"
fi

echo "Cloning $UPSTREAM_REPO..."
git clone --quiet "$UPSTREAM_REPO" "$UPSTREAM_DIR"

cd "$UPSTREAM_DIR"
git checkout --quiet "$COMMIT"
cd ..

# Remove .git from upstream (we don't want nested git repos)
rm -rf "$UPSTREAM_DIR/.git"

echo "Upstream source ready at $UPSTREAM_DIR (commit: $COMMIT)"
