---
title: active-context
type: note
permalink: active-context
tags:
- active
- current
- focus
---

- [2025-12-17] Released v0.6.7 - Unified publish workflow, MCP registry publishing working
- [2025-12-17] Added mcp-publisher v1.4.0 to devshell for local MCP registry operations
- [2025-12-17] Migrated CI from FlakeHub/Determinate Nix to Cachix (nacosolutions cache)
- [2025-12-17] Removed Docker builds, unified release.yml + publish.yml workflows

# Active Context: modern-cli-mcp

## Current Focus
v0.6.7 released with complete CI/CD pipeline:
- Single publish.yml workflow handles: tag → release → build → AppImage → upload → MCP registry
- mcp-publisher available in devshell for local testing
- Published to MCP registry at registry.modelcontextprotocol.io

## Recent Events (Last 10)
1. [2025-12-17] Released v0.6.7 - Unified publish workflow + MCP registry publishing
2. [2025-12-17] Added mcp-publisher v1.4.0 to devshell (custom Nix derivation)
3. [2025-12-17] Merged release.yml into publish.yml (single workflow on tag push)
4. [2025-12-17] Fixed MCP registry: name case, description ≤100 chars, empty packages
5. [2025-12-17] Migrated from FlakeHub to GitHub URLs, Determinate Nix to Cachix
6. [2025-12-17] Removed Docker builds from CI (simplified, AppImage is portable alternative)
7. [2025-12-17] Fixed AppImage build: package name match, cp -L for symlinks
8. [2025-12-17] Evaluated fenix+crate2nix - documented as future consideration
9. [2025-12-17] Released v0.6.0 - Dual-response mode complete
10. [2025-12-16] Released v0.5.0 - Busybox-style CLI execution

## Observations
- [decision] Cachix (nacosolutions) for Nix binary caching in GitHub Actions
- [decision] Standard GitHub URLs for flake inputs (no FlakeHub dependency)
- [decision] AppImage as portable distribution (replaces Docker for single-binary use)
- [decision] .agentignore respected instead of .gitignore (different use cases)
- [decision] Memory bank uses kebab-case and .agent-memory/ to align with global conventions
- [pattern] CI: cachix/install-nix-action + cachix/cachix-action
- [pattern] Publish workflow: tag push → create-release → build/appimage → release-assets → mcp-registry
- [pattern] mcp-publisher requires: name case match OIDC, description ≤100 chars
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