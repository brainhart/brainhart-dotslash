#!/bin/bash
set -euo pipefail

# Get project root (parent of utils/)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

UPSTREAM_DIR="$PROJECT_ROOT/upstream"
PATCHES_DIR="$PROJECT_ROOT/patches"

if [ ! -d "$UPSTREAM_DIR" ]; then
    echo "Error: Upstream directory '$UPSTREAM_DIR' not found."
    echo "Run ./utils/fetch_upstream.sh first."
    exit 1
fi

if [ ! -f "$PATCHES_DIR/series" ]; then
    echo "Error: Series file '$PATCHES_DIR/series' not found."
    exit 1
fi

export QUILT_PATCHES="$PATCHES_DIR"

cd "$UPSTREAM_DIR"

# Check if patches are already applied
if quilt applied > /dev/null 2>&1; then
    echo "Some patches already applied. Run 'quilt pop -a' first to reset."
    exit 1
fi

echo "Applying patches to $UPSTREAM_DIR..."
quilt push -a || {
    if [ $? -eq 2 ]; then
        echo "No patches to apply."
        exit 0
    fi
    exit 1
}
