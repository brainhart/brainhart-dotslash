# brainhart-dotslash

Custom patches for [facebook/dotslash](https://github.com/facebook/dotslash) using [quilt](https://linux.die.net/man/1/quilt).

## Quick Start

```bash
# 1. Fetch upstream source
./utils/fetch_upstream.sh

# 2. Apply patches
./utils/apply_patches.sh

# 3. Build
cd upstream && cargo build --release
```

## Structure

```
.
├── .github/workflows/
│   ├── build.yml        # CI: build/test/clippy on push/PR
│   └── release.yml      # Release: multi-platform builds on tag
├── utils/
│   ├── fetch_upstream.sh    # Downloads dotslash source at pinned commit
│   ├── apply_patches.sh     # Applies patches using quilt
│   └── validate_patches.sh  # Validates patches apply cleanly
├── patches/
│   └── series               # Ordered list of patches to apply
└── upstream/                # (gitignored) Fetched source with .pc/ state
```

## Creating Patches with Quilt

```bash
# 1. Fetch upstream and apply existing patches
./utils/fetch_upstream.sh
./utils/apply_patches.sh

# 2. Create a new patch
cd upstream
export QUILT_PATCHES=../patches
quilt new 0001-my-change.patch

# 3. Register files you'll modify
quilt edit src/some_file.rs

# 4. Make your changes (use any editor)

# 5. Save the patch
quilt refresh

# 6. Add metadata (optional but recommended)
quilt header -e --dep3

# 7. Verify
quilt pop -a   # Unapply all
quilt push -a  # Reapply all - should succeed
```

## Editing Existing Patches

```bash
cd upstream
export QUILT_PATCHES=../patches

# Apply up to the patch you want to edit
quilt push patch-name.patch

# Make changes
quilt edit src/file.rs
# ... edit ...

# Update the patch
quilt refresh
```

## Updating Upstream

```bash
# 1. Update DEFAULT_COMMIT in utils/fetch_upstream.sh
# 2. Re-fetch
./utils/fetch_upstream.sh

# 3. Try applying patches
./utils/apply_patches.sh

# 4. If patches fail, fix them:
cd upstream
export QUILT_PATCHES=../patches
quilt push -f           # Force apply, creates .rej files
# ... fix conflicts ...
quilt refresh           # Update the patch
quilt push              # Continue to next patch
```

## CI/CD

- **Build workflow**: Runs on every push/PR - fetches upstream, applies patches, builds and tests
- **Release workflow**: Triggered by `v*` tags - builds for macOS, Linux (glibc/musl), Windows and uploads to GitHub Releases

## Current Upstream

- **Repo:** https://github.com/facebook/dotslash
- **Commit:** `dd5fc02536367fcc1edb077375c3fd2841c1ea22`

## References

- [Debian Quilt Guide](https://wiki.debian.org/UsingQuilt)
- [Quilt Tutorial by Raphaël Hertzog](https://raphaelhertzog.com/2012/08/08/how-to-use-quilt-to-manage-patches-in-debian-packages/)
