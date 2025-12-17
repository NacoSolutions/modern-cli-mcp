---
title: system-patterns
type: note
permalink: system-patterns
tags:
- architecture
- patterns
- decisions
---

# System Patterns: modern-cli-mcp

## Architecture

```
┌─────────────────────────────────────────┐
│           MCP Client (Claude)           │
└────────────────────┬────────────────────┘
                     │ stdio
┌────────────────────▼────────────────────┐
│         modern-cli-mcp server           │
│  ┌─────────────────────────────────┐    │
│  │    rmcp framework (Rust)        │    │
│  │  - Tool registration            │    │
│  │  - JSON schema generation       │    │
│  │  - Request/response handling    │    │
│  └─────────────────────────────────┘    │
│  ┌─────────────────────────────────┐    │
│  │    StateManager (SQLite)        │    │
│  │  - Auth state caching           │    │
│  │  - Tool result cache (TTL)      │    │
│  │  - Task tracking                │    │
│  │  - Context key-value store      │    │
│  └─────────────────────────────────┘    │
│  ┌─────────────────────────────────┐    │
│  │    CommandExecutor              │    │
│  │  - Spawns CLI processes         │    │
│  │  - Captures stdout/stderr       │    │
│  │  - Timeout + env support        │    │
│  └─────────────────────────────────┘    │
└────────────────────┬────────────────────┘
                     │ subprocess
┌────────────────────▼────────────────────┐
│         CLI Tools (in PATH)             │
│  eza, bat, fd, rg, jq, yq, gh, kubectl  │
│  bash, zsh, fish, nu, nix develop       │
└─────────────────────────────────────────┘
```

## Virtual Tool Groups

```
┌─────────────────────────────────────────────────────────────────┐
│                     TOOL EXPOSURE LAYER                         │
├─────────────────────────────────────────────────────────────────┤
│  Server Instructions (profile-aware):                           │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐           │
│  │filesystem│ │  search  │ │   git    │ │  github  │ ...       │
│  │  (17)    │ │   (6)    │ │   (8)    │ │  (10)    │           │
│  └────┬─────┘ └────┬─────┘ └────┬─────┘ └────┬─────┘           │
│       │            │            │            │                  │
│  ┌────▼────────────▼────────────▼────────────▼────────────┐    │
│  │              expand_tools meta-tool                     │    │
│  │  Returns tool list for requested group                  │    │
│  └─────────────────────────────────────────────────────────┘    │
│                              │                                  │
│  ┌───────────────────────────▼─────────────────────────────┐   │
│  │           ALL TOOLS REGISTERED (104 total)              │   │
│  │  eza, bat, fd, rg, jq, gh_pr, kubectl_get, ...          │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘

Agent Profiles (--profile flag):
┌─────────────┬───────┬─────────────────────────────────────────┐
│ Profile     │ Tools │ Pre-expanded Groups                     │
├─────────────┼───────┼─────────────────────────────────────────┤
│ explore     │  31   │ filesystem, search, git                 │
│ architect   │  26   │ filesystem, search, reference           │
│ review      │  16   │ git, search, diff                       │
│ test        │  18   │ file_ops, search, system                │
│ generator   │  26   │ file_ops, search, git, system           │
│ dev-deploy  │  39   │ kubernetes, container, git, github      │
│ full        │ 104   │ ALL groups                              │
└─────────────┴───────┴─────────────────────────────────────────┘
```

## Memory Architecture

```
┌─────────────────────────────────────────┐
│  OPERATIONAL STATE (SQLite internal)    │
│  ~/.local/share/modern-cli-mcp/state.db │
│  ├── auth_state   - forge auth cache    │
│  ├── tool_cache   - TTL-based cache     │
│  ├── tasks        - session tracking    │
│  └── context      - key-value store     │
├─────────────────────────────────────────┤
│  KNOWLEDGE (basic-memory MCP external)  │
│  ~/.agent-memory/ - global patterns     │
│  ./.agent-memory/ - project context     │
└─────────────────────────────────────────┘
```

## Observations
- [decision] Use rmcp crate for MCP protocol implementation
- [decision] Wrap binary with Nix makeWrapper to inject tool PATH
- [decision] Async executor with tokio for concurrent tool calls
- [decision] Schemars for automatic JSON schema generation
- [decision] Tool categories: filesystem, search, git-forges, containers, kubernetes, data-transform, network, system, diff, utilities
- [decision] JSON output preferred for AI/LLM consumption (vs JSONL)
- [decision] TUI tools excluded - require interactive terminals
- [decision] Virtual tools: informational grouping, all tools remain callable
- [decision] Agent profiles: pre-expand relevant groups in server instructions
- [pattern] Tool Handler: #[tool(description)] async fn with Parameters<T>
- [pattern] Executor: CommandExecutor wraps tokio::process::Command
- [pattern] Nix: buildRustPackage + symlinkJoin + wrapProgram
- [pattern] JSON Helper: parse_*_to_json functions for CLI output conversion
- [pattern] StateManager: Arc<Mutex<Connection>> for thread-safe SQLite access
- [pattern] ToolGroup: enum with static tool name arrays and descriptions
- [pattern] AgentProfile: enum with pre_expanded_groups() returning HashSet<ToolGroup>
- [pattern] expand_tools: meta-tool returns formatted list of tools in a group
- [pattern] Profile-aware instructions: get_info() builds instructions based on profile
- [pattern] Safe overwrite: check exists → rip to graveyard → perform operation
- [pattern] Backup for edits: copy to {file}.bak.{timestamp} before modifying
- [decision] Hybrid memory: SQLite for ephemeral/operational, basic-memory for knowledge
- [decision] Shell tools support multiple shells: bash, zsh, fish, nushell (nu), dash
- [decision] Pretty tool names use "Category - Action (tool)" format for AI/LLM clarity
- [research] GitHub Copilot: 2-5% benchmark improvement, 400ms latency reduction with tool clustering
## Relations

- extracted_to [[patterns/MCP Internal State Pattern]]
- extracted_to [[patterns/Safe Filesystem Operations Pattern]]
- uses [[rmcp Crate]]
- uses [[Nix makeWrapper]]
- implements [[MCP Tool Protocol]]
- uses [[ElysiaJS]]
- uses [[HTMX]]
- publishes_to [[MCP Registry]]
- publishes_to [[GitHub Releases]]


## Dual-Response Pattern

Architecture for returning both human-readable summaries and raw structured data:

```
┌─────────────────────────────────────────────────────────┐
│              MCP Tool Response                          │
├─────────────────────────────────────────────────────────┤
│  Content[0]: Text (human summary)                       │
│  Content[1]: EmbeddedResource (raw JSON/JSONL)          │
└─────────────────────────────────────────────────────────┘
```

**Helper Method**: `build_response(&self, summary, raw_data, uri)`
- Returns single text block in normal mode
- Returns text + embedded resource in dual-response mode

**Summary Formatters**: `src/format.rs`
- Per-tool-category formatters (eza, fd, git, etc.)
- Parse JSON output, extract key metrics
- Generate concise human-readable summaries

**URI Scheme**: `data://<tool>/<filename>`
- Examples: `data://eza/listing.json`, `data://git/status.json`

**MIME Types**:
- JSON: `application/json`
- JSONL: `application/x-ndjson`

## Future Consideration: Nix Rust Tooling

**Evaluated**: nix-community/fenix + nix-community/crate2nix
- fenix: Pure Rust toolchains, rust-analyzer nightly, granular components
- crate2nix: Per-crate Nix derivations, granular caching

**Decision**: Stay with oxalica/rust-overlay + rustPlatform.buildRustPackage
- Current build times acceptable (~48 crates)
- Simpler maintenance (no generated Cargo.nix)
- crate2nix overhead not justified for project size

**Revisit if**:
- Build times become problematic
- Need nightly Rust features
- Workspace grows to 100+ crates
- CI cache limits become an issue

## CI/CD Pipeline

```
Tag Push (v*)
    │
    ▼
┌─────────────────────────────────────────────────────────┐
│                  publish.yml workflow                    │
├─────────────────────────────────────────────────────────┤
│  create-release ──► softprops/action-gh-release         │
│                                                          │
│  build ──────────► nix build .#full                     │
│                    └── artifacts: binary, SBOMs          │
│                                                          │
│  appimage ───────► nix bundle (nix-appimage)            │
│                    └── artifact: .AppImage               │
│                                                          │
│  release-assets ─► gh release upload (--clobber)        │
│                                                          │
│  mcp-registry ───► mcp-publisher publish                │
│                    └── registry.modelcontextprotocol.io  │
└─────────────────────────────────────────────────────────┘
```

**Caching**: Cachix (nacosolutions cache)
- `cachix/install-nix-action@v30` + `cachix/cachix-action@v15`
- skipPush on pull_request events

**MCP Registry Requirements**:
- `name`: Must match OIDC claim case (`io.github.NacoSolutions/...`)
- `description`: ≤100 characters
- `packages`: Empty array (no supported registryType for Nix)

**Release Assets**:
- `modern-cli-mcp-linux-x86_64` - static binary
- `modern-cli-mcp-x86_64.AppImage` - portable bundle (~800MB with Nix deps)
- `sbom-cargo.txt` - Cargo dependencies
- `sbom-nix-closure.txt` - Nix closure paths

