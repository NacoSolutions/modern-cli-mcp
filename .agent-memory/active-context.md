---
title: active-context
type: note
permalink: active-context
tags:
- active
- current
- focus
---

# Active Context: modern-cli-mcp

## Current Focus
v0.6.8 released - CI/CD cleanup and documentation improvements
- Removed MCP registry publishing (blocked - Nix not supported)
- Added configuration docs for all install methods (AppImage, Nix Run, Nix Profile, Binary)
- Fixed GitHub Pages workflow for Actions deployment

## Recent Events (Last 10)
1. [2025-12-18] Released v0.6.8 - CI/CD cleanup, documentation improvements
2. [2025-12-17] Added config docs for all install methods (AppImage, Nix Run, Nix Profile, Binary)
3. [2025-12-17] Removed MCP registry publishing - Nix stdio servers not supported
4. [2025-12-17] Fixed GitHub Pages workflow - configured for Actions deployment
5. [2025-12-17] Released v0.6.7 - Unified publish workflow
6. [2025-12-17] Migrated from FlakeHub to GitHub URLs, Determinate Nix to Cachix
7. [2025-12-17] Removed Docker builds from CI (AppImage is portable alternative)
8. [2025-12-17] Released v0.6.0 - Dual-response mode complete
9. [2025-12-16] Released v0.5.0 - Busybox-style CLI execution
10. [2025-12-14] Released v0.4.0 - Dynamic Toolsets & Batch Operations

## Observations
- [decision] Cachix (nacosolutions) for Nix binary caching in GitHub Actions
- [decision] Standard GitHub URLs for flake inputs (no FlakeHub dependency)
- [decision] AppImage as portable distribution (replaces Docker for single-binary use)
- [decision] .agentignore respected instead of .gitignore (different use cases)
- [decision] Memory bank uses kebab-case and .agent-memory/ to align with global conventions
- [blocked] MCP registry requires packages (npm/pypi/oci) or remotes - Nix not supported
- [pattern] CI: cachix/install-nix-action + cachix/cachix-action
- [pattern] Publish workflow: tag push → create-release → build/appimage → release-assets
- [architecture] Global memory: ~/.agent-memory/, Project memory: ./.agent-memory/
- [important] Wrapped binary required for CLI tools - `nix build .#default` includes all tools in PATH

## Next Steps
- Add `tools/list_changed` notification when toolsets are enabled (requires rmcp peer access)
- Consider adding disable_toolset for symmetry
- Document that MCP config must use wrapped binary (`nix build .#default`) for CLI tools in PATH

## Relations

- tracks [[CI Pipeline]]
- tracks [[GitHub Release]]

- [architecture] Dynamic Toolsets: DynamicToolsetConfig with RwLock<HashSet<ToolGroup>> for thread-safe runtime group management
- [pattern] Tool filtering: Manual ServerHandler::list_tools implementation checks enabled_groups against tool_to_group reverse lookup
- [decision] Meta-tools (expand_tools, list_tool_groups, list_available_toolsets, etc.) always visible in dynamic mode