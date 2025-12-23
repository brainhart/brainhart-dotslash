#!/bin/bash
set -euo pipefail

# Validates that all patches apply cleanly without modifying files
# Uses quilt's dry-run capability

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

echo "Validating patches against $UPSTREAM_DIR..."

# Count patches
patch_count=$(grep -cv '^#\|^$' "$PATCHES_DIR/series" 2>/dev/null || echo 0)

if [ "$patch_count" -eq 0 ]; then
    echo "No patches to validate."
    exit 0
fi

# Try applying all patches
if quilt push -a --dry-run > /dev/null 2>&1; then
    echo "All $patch_count patch(es) validated successfully."
    exit 0
else
    echo "Patch validation failed. Run 'quilt push -a' to see details."
    exit 1
fi
