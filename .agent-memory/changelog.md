---
title: changelog
type: note
permalink: changelog
tags:
- changelog
- history
- versions
---

# Changelog: modern-cli-mcp

## [0.6.0] - 2025-12-17

### Added
- Dual-response mode complete for all 104+ tools
  - `--dual-response` flag / `MCP_DUAL_RESPONSE=1` env var
  - Normal mode: Returns raw JSON/text data (single content block)
  - Dual mode: Returns summary text + embedded resource with raw data
- Helper methods: `build_response()`, `build_cmd_response()`, `build_error()`
- Summary formatters in `src/format.rs`

### Changed
- All tools now use `build_response()` pattern for consistent output
- Tool responses include human-readable summaries in dual mode

## [0.5.0] - 2025-12-16

### Added
- Busybox-style CLI execution (`modern-cli-mcp eza -la`)
- install.sh script with --user/--system and --full/--binary options
- Dual-response mode foundation (`--dual-response` flag)

## [0.4.0] - 2025-12-16

### Added
- Dynamic Toolsets Mode (beta):
  - `--dynamic-toolsets` flag to start with only meta-tools
  - `--toolsets` flag to pre-enable specific groups
  - `MCP_DYNAMIC_TOOLSETS` / `MCP_TOOLSETS` environment variables
  - `list_available_toolsets`, `get_toolset_tools`, `enable_toolset` meta-tools
- Extended batch operations:
  - `fs_mkdir` - create multiple directories at once
  - `fs_stat` - get stats for multiple paths
  - `fs_exists` - check multiple paths in one call
  - `file_edit` - apply same replacement across multiple files
- Container tools: compose (podman-compose + docker compose v2), buildx, buildah

### Changed
- All 104+ tools now have consistent "Category - Name (tool)" pretty names
- Batch operations return JSON with summary counts and per-item results
- Git tools path parameter clarified: uses `git -C <path>` behavior
- trash, copy, move tools now accept space-separated paths

### Fixed
- Tool name consistency across groups.rs and tool definitions

## [0.3.0] - 2025-12-12

### Added
- Safe filesystem operations with graveyard backup:
  - `fs_symlink`, `fs_hardlink` - new tools with safe_overwrite option
  - `safe_overwrite` option for fs_move, fs_copy, file_write (rips dest to graveyard)
  - `backup` option for file_edit, file_patch (creates .bak.{timestamp} copies)
- Git primitives: git_status, git_add, git_commit, git_branch, git_checkout, git_log, git_stash
- Code intelligence: symbols (ast-grep), references (ripgrep)
- file_patch tool for applying unified diffs
- trash_restore tool (rip --unbury) for graveyard recovery

### Changed
- Replaced trash-cli with rip (rm-improved) for graveyard-based safe delete
- All 90+ tools now have pretty names ("Category - Action (tool)" format)
- system_info uses sysinfo crate instead of shell commands
- fs_copy uses native tokio::fs instead of cp command
- Removed legacy tool fallbacks (curl, dig, coreutils)

### Fixed
- Symlink detection now checks both exists() and is_symlink()

## [0.2.0] - 2025-12-09
### Added
- 31 new tools (70+ total):
  - Git Forges: gh_repo, gh_issue, gh_pr, gh_search, gh_release, gh_workflow, gh_run, gh_api, glab_issue, glab_mr, glab_pipeline
  - Containers: podman, dive, skopeo, crane, trivy
  - Kubernetes: kubectl_get, kubectl_describe, kubectl_logs, kubectl_apply, kubectl_delete, kubectl_exec, stern, helm, kustomize
  - Data Transform: gron, htmlq, pup, miller, dasel
- web_search tool using ddgr (DuckDuckGo CLI with native --json)
- JSON output helpers in executor.rs: parse_eza_to_json, parse_fd_to_json, parse_diff_to_json, parse_trash_list_to_json, parse_file_to_json, parse_fzf_to_json, parse_dust_to_json
- GitHub workflows: ci.yml, publish.yml (binaries, Docker, FlakeHub, SBOM), claude.yml, pages.yml
- .claude/ directory: settings.json, commands/release.md, agents/rust-mcp-expert.md, agents/cli-tools-expert.md
- RELEASE_NOTES.md and RELEASE_WORKFLOW.md
- Static website: index.html, tools.html, docs.html, styles.css (htmx/hyperscript/UnoCSS)

### Changed
- All tools now output JSON where it makes sense for AI/LLM consumption
- Tools converted to JSON output: eza, fd, dust, trash_list, fzf_filter, delta, file_type, ast_grep
- ast_grep now always outputs JSON (removed optional flag)
- Website converted from Bun/ElysiaJS to static HTML (GitHub Pages compatible)
- README.md updated with 70+ tools in table format
- CI paths-ignore: docs, .agent-memory, .claude/, website, scripts
- Updated .gitignore, .editorconfig, .dockerignore
### Added
- 31 new tools (70+ total):
  - Git Forges: gh_repo, gh_issue, gh_pr, gh_search, gh_release, gh_workflow, gh_run, gh_api, glab_issue, glab_mr, glab_pipeline
  - Containers: podman, dive, skopeo, crane, trivy
  - Kubernetes: kubectl_get, kubectl_describe, kubectl_logs, kubectl_apply, kubectl_delete, kubectl_exec, stern, helm, kustomize
  - Data Transform: gron, htmlq, pup, miller, dasel
- GitHub workflows: ci.yml, publish.yml (binaries, Docker, FlakeHub, SBOM), claude.yml
- .claude/ directory: settings.json, commands/release.md, agents/rust-mcp-expert.md, agents/cli-tools-expert.md
- RELEASE_NOTES.md and RELEASE_WORKFLOW.md
- Website scaffold: Bun/ElysiaJS/HTMX/Hyperscript/UnoCSS

### Changed
- All tools default to JSON output for AI/LLM consumption
- README.md updated with 70+ tools in table format
- CI paths-ignore: docs, .agent-memory, .claude/, website, scripts
- Updated .gitignore, .editorconfig, .dockerignore

## [0.1.0] - 2025-12-09

### Added
- MCP server exposing 30+ modern CLI tools
- Nix flake with three package variants (default, full, server-only)
- numtide/devshell development environment
- pog scripts for tooling (tools script)
- Pre-commit hooks (nixfmt, deadnix, statix, rustfmt, clippy)
- Flake checks (formatCheck, deadnixCheck, statixCheck, rustfmtCheck)
- GitHub Actions CI (test, nix, docker jobs)
- GitHub Actions release workflow
- Dockerfile for container builds
- README with installation and usage docs
- CLAUDE.md for AI assistant context
- MIT License

### Fixed
- CI workflow: corrected rust-toolchain action name
- deadnix: removed unused pkgs argument in githooks.nix
- Formatting: applied nixfmt-rfc-style and cargo fmt

## Relations

- documents [[Project History]]