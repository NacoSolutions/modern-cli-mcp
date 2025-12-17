# Release Workflow Guide

## Overview

This guide explains the release process for Modern CLI MCP.

## CI/CD Features

1. **Documentation-only changes skip tests**: Changes to *.md, .agent-memory/, .claude/, docs/, website/ don't trigger builds
2. **Release publishing**: Tags trigger binary and AppImage builds

## Release Process

### 1. Prepare Release

```bash
# Check current version
grep '^version = ' Cargo.toml

# Review changes since last release
git log $(git tag --sort=-version:refname | head -1)..HEAD --oneline
```

### 2. Update Version

Edit `Cargo.toml`:
```toml
version = "X.Y.Z"
```

Version bump guidelines:
- **Patch** (x.y.Z): Bug fixes, docs, CI improvements
- **Minor** (x.Y.0): New tools, backward-compatible features
- **Major** (X.0.0): Breaking changes to tool schemas

### 3. Update Release Notes

Add new section at top of `RELEASE_NOTES.md` following the existing format.

### 4. Commit and Tag

```bash
git add Cargo.toml Cargo.lock RELEASE_NOTES.md
git commit -m "chore: release vX.Y.Z"
git push

git tag -a vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

### 5. Create GitHub Release

```bash
gh release create vX.Y.Z \
  --title "vX.Y.Z: [Brief Title]" \
  --notes-file - << 'NOTES'
## Overview

[1-2 sentence description]

## Highlights
- 🚀 [New feature]
- 🔧 [Improvement]

## Installation
```bash
nix run github:NacoSolutions/modern-cli-mcp@vX.Y.Z
```

See [RELEASE_NOTES.md](RELEASE_NOTES.md) for full changelog.
NOTES
```

### 6. Verify Deployments

```bash
# Monitor workflow
gh run list --workflow=publish.yml --limit 3

# Verify Nix
nix run github:NacoSolutions/modern-cli-mcp@vX.Y.Z
```

## Artifacts Generated

Each release produces:
- `modern-cli-mcp-linux-x86_64` - Static binary
- `modern-cli-mcp-x86_64.AppImage` - Portable bundle with dependencies
- `sbom-cargo.txt` - Cargo dependency tree
- `sbom-nix-closure.txt` - Full Nix closure

## Troubleshooting

**Workflow fails**: Check logs with `gh run view <RUN_ID> --log-failed`

**Tag exists**: Delete with:
```bash
git tag -d vX.Y.Z
git push origin :refs/tags/vX.Y.Z
```
