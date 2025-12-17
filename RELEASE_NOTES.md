# Modern CLI MCP: v0.6.8 Release Notes - CI/CD Cleanup & Documentation

## Overview

Modern CLI MCP v0.6.8 removes blocked MCP registry publishing and improves documentation for all installation methods.

## Changes in v0.6.8

### 📚 Documentation Improvements

- **Configuration docs for all install methods** - AppImage, Nix Run, Nix Profile, Binary
- **Tabbed UI** for switching between config examples
- **Updated Profiles & Dynamic Toolsets sections** with multi-method examples

### 🔧 CI/CD Changes

- **Removed MCP registry publishing** - Registry requires npm/pypi/oci packages or HTTP remotes; Nix stdio servers not supported
- **Retained server.json** for future use when registry adds Nix support
- **Fixed GitHub Pages workflow** - Configured for Actions deployment

### 📝 Housekeeping

- Updated RELEASE_WORKFLOW.md to remove Docker references
- Simplified devshell (removed mcp-publisher)

---

# Modern CLI MCP: v0.4.0 Release Notes - Dynamic Toolsets & Batch Operations

## Overview

Modern CLI MCP v0.4.0 introduces Dynamic Toolsets Mode for reduced cognitive load, consistent pretty names across all 104+ tools, and comprehensive batch operation support for multi-file workflows.

## Changes in v0.4.0

### 🚀 Dynamic Toolsets Mode (Beta)

New CLI flags for on-demand tool activation:
- **`--dynamic-toolsets`** - Start with only meta-tools, enable groups on demand
- **`--toolsets`** - Pre-enable specific groups (e.g., `--toolsets=filesystem,git`)
- **`MCP_DYNAMIC_TOOLSETS`** / **`MCP_TOOLSETS`** - Environment variable support

Meta-tools for runtime management:
- **`list_available_toolsets`** - Show all toolsets and their status
- **`get_toolset_tools`** - Preview tools in a toolset before enabling
- **`enable_toolset`** - Activate a toolset (use "all" for everything)

### 🔧 Batch Operations

Extended batch support for multi-file workflows:
- **Filesystem - Trash/Copy/Move** - Space-separated paths with per-item results
- **Filesystem - Mkdir** - Create multiple directories at once
- **Filesystem - Stat/Exists** - Check multiple paths in one call
- **File - Edit** - Apply same replacement across multiple files

All batch operations return JSON with summary counts and per-item success/error status.

### ✨ Pretty Names for All Tools

Consistent "Category - Name (tool)" format across all 104+ tools:
- `file_read` → "File - Read"
- `ast_grep` → "Search - AST (ast-grep)"
- `jq` → "Text - JSON (jq)"
- `kubectl_get` → "Kubernetes - Get"
- And 10 more tools standardized

### 🐳 Container Improvements

- **Container - Compose** - Supports both podman-compose and docker compose v2
- **Container - Buildx** - Multi-platform builds
- **Container - Build (buildah)** - OCI image builder

### 📦 Additional Improvements

- Git tools path parameter clarified: uses `git -C <path>` behavior
- .agentignore support for tool-specific ignore patterns
- Web search via DuckDuckGo (ddgr) with native JSON
- 15 virtual tool groups with agent profiles

## Installation

```bash
# Nix (recommended)
nix run github:NacoSolutions/modern-cli-mcp

# With dynamic toolsets
nix run github:NacoSolutions/modern-cli-mcp -- --dynamic-toolsets

# Docker
docker pull ghcr.io/nacosolutions/modern-cli-mcp:0.4.0
```

## Configuration

```json
{
  "mcpServers": {
    "modern-cli": {
      "command": "nix",
      "args": ["run", "github:NacoSolutions/modern-cli-mcp", "--", "--dynamic-toolsets"]
    }
  }
}
```

---

# Modern CLI MCP: v0.2.0 Release Notes - Tool Expansion

## Overview

Modern CLI MCP v0.2.0 massively expands the tool collection with Git forge integrations, container/Kubernetes tools, and data transformation utilities optimized for AI/LLM consumption.

## Changes in v0.2.0

### 🚀 New Tool Categories

#### Git Forges (11 tools)
- **gh_repo, gh_issue, gh_pr, gh_search, gh_release, gh_workflow, gh_run, gh_api** - Full GitHub CLI coverage with JSON output
- **glab_issue, glab_mr, glab_pipeline** - GitLab CI/CD operations

#### Data Transformation (5 tools)
- **gron** - Transform JSON to greppable format for deep searching
- **htmlq** - jq for HTML with CSS selectors
- **pup** - HTML parser with display filters and JSON output
- **miller** - Multi-format data processor (CSV, JSON, etc.)
- **dasel** - Universal selector for JSON/YAML/TOML/XML

#### Containers (5 tools)
- **podman** - Full container operations with JSON output
- **dive** - Image layer analysis and efficiency scoring
- **skopeo** - Registry operations without pulling images
- **crane** - Low-level registry tool for manifests/digests
- **trivy** - Security vulnerability scanner with JSON reports

#### Kubernetes (10 tools)
- **kubectl_get, kubectl_describe, kubectl_logs, kubectl_apply, kubectl_delete, kubectl_exec** - Core K8s operations
- **stern** - Multi-pod log aggregation with JSON output
- **helm** - Chart management with JSON for list/status
- **kustomize** - Manifest building

### 🔧 AI/LLM Optimization

- All tools default to JSON output where supported
- Consistent output formats for reliable parsing
- Tool descriptions document output format expectations

### 📦 Total Tools

**70 tools** now available covering:
- Filesystem, search, text processing
- Git forges (GitHub, GitLab)
- Containers and registries
- Kubernetes cluster management
- Data transformation and parsing

## Installation

```bash
# Nix (recommended)
nix run github:NacoSolutions/modern-cli-mcp

# Docker
docker pull ghcr.io/nacosolutions/modern-cli-mcp:0.2.0
```

## Configuration

Add to Claude Desktop config:
```json
{
  "mcpServers": {
    "modern-cli": {
      "command": "nix",
      "args": ["run", "github:NacoSolutions/modern-cli-mcp"]
    }
  }
}
```

---

# Modern CLI MCP: v0.1.0 Release Notes - Initial Release

## Overview

Modern CLI MCP is an MCP server that exposes modern command-line utilities to AI/LLM agents. It bundles 40+ CLI tools and provides structured JSON-RPC access to them.

## Features

### Core Tools
- **eza, bat, fd, dust, duf** - Modern filesystem utilities
- **ripgrep, fzf, ast-grep** - Powerful search tools
- **jq, yq, sd, hck, qsv** - Data processing
- **git, delta, difftastic** - Version control
- **xh, doggo** - Network utilities
- **procs, tokei, hyperfine** - System tools

### Architecture
- Built with Rust and rmcp for high performance
- Nix-based distribution bundles all dependencies
- Stateless operation - no caching layer

## Installation

```bash
nix run github:NacoSolutions/modern-cli-mcp
```
