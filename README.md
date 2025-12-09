# Modern CLI MCP Server

[![CI](https://github.com/hellst0rm/modern-cli-mcp/actions/workflows/ci.yml/badge.svg)](https://github.com/hellst0rm/modern-cli-mcp/actions/workflows/ci.yml)

MCP server exposing modern CLI tools for AI/LLM agents. Provides structured access to tools like `eza`, `bat`, `fd`, `rg`, `delta`, `jq`, and 20+ more utilities.

## Quick Start

### Option 1: Using Nix (Recommended)

```json
{
  "mcpServers": {
    "modern-cli": {
      "command": "nix",
      "args": ["run", "github:hellst0rm/modern-cli-mcp", "--"]
    }
  }
}
```

### Option 2: Using Docker

```json
{
  "mcpServers": {
    "modern-cli": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "ghcr.io/hellst0rm/modern-cli-mcp"]
    }
  }
}
```

### Option 3: Pre-built Binary

Download from [Releases](https://github.com/hellst0rm/modern-cli-mcp/releases) and add to your MCP config:

```json
{
  "mcpServers": {
    "modern-cli": {
      "command": "/path/to/modern-cli-mcp"
    }
  }
}
```

## Available Tools

### Filesystem
- `eza` - Modern ls replacement with icons and git integration
- `bat` - Cat with syntax highlighting
- `fd` - Fast find alternative
- `duf` - Disk usage viewer
- `dust` - Directory size analyzer
- `trash_put/list/empty` - Safe file deletion

### Search
- `rg` - Ripgrep for fast content search
- `fzf_filter` - Fuzzy filtering
- `ast_grep` - AST-based code search

### Text Processing
- `jq` - JSON processor
- `yq` - YAML/JSON/XML processor
- `xsv` - CSV toolkit
- `sd` - Find and replace
- `hck` - Field extraction

### System
- `procs` - Process viewer
- `tokei` - Code statistics
- `hyperfine` - Benchmarking
- `system_info` - Resource usage

### Network
- `http` - HTTP requests (xh)
- `dns` - DNS lookups (doggo)
- `usql` - Universal SQL client

### Diff/Git
- `delta` - Syntax-highlighted diffs
- `difft` - Structural diff
- `git_diff` - Git diff with highlighting

### Utilities
- `tldr` - Command cheatsheets
- `grex` - Regex generator
- `navi` - Cheatsheet search
- `ouch_compress/decompress/list` - Archive handling
- `pueue_add/status/log` - Task queue

## Installation

### From Source (Cargo)

```bash
cargo install --git https://github.com/hellst0rm/modern-cli-mcp
```

### From Source (Nix)

```bash
# Run directly
nix run github:hellst0rm/modern-cli-mcp

# Install to profile
nix profile install github:hellst0rm/modern-cli-mcp

# Development shell
nix develop github:hellst0rm/modern-cli-mcp
```

### Docker

```bash
docker pull ghcr.io/hellst0rm/modern-cli-mcp
docker run --rm -i ghcr.io/hellst0rm/modern-cli-mcp
```

## Development

### With Nix (Recommended)

```bash
# Enter dev shell
nix develop

# Available commands (run 'menu' for full list)
build         # Build release binary
run           # Run the server
test          # Run tests
check         # Cargo check
clippy        # Lint with clippy
fmt           # Format code
flake-check   # Nix flake checks
```

### Without Nix

```bash
# Requires Rust toolchain and CLI tools installed separately
cargo build --release
cargo run
cargo test
```

## Architecture

```
src/
├── main.rs           # Entry point, MCP server setup
└── tools/
    ├── mod.rs        # Tool registration and routing
    └── executor.rs   # Tool execution logic
```

The server wraps CLI tools with structured JSON input/output. Each tool:
1. Validates parameters via JSON Schema
2. Constructs the appropriate command
3. Executes and captures output
4. Returns structured results

## Configuration

The Nix package bundles all CLI tools. When running via cargo, ensure tools are in PATH.

Environment variables:
- `RUST_LOG` - Logging level (default: `info`)

## License

MIT
