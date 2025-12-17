# pkgs.nix
{ pkgs }:
let
  # MCP Publisher - tool for publishing to MCP registry
  mcp-publisher = pkgs.stdenv.mkDerivation rec {
    pname = "mcp-publisher";
    version = "latest";

    src = pkgs.fetchurl {
      url = "https://github.com/modelcontextprotocol/registry/releases/latest/download/mcp-publisher_linux_amd64.tar.gz";
      sha256 = "sha256-xLQCtDqFFmw/hAZByhyebeW/oc9TPCJXbWY8y9oHEbs=";
    };

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/bin
      cp mcp-publisher $out/bin/
      chmod +x $out/bin/mcp-publisher
    '';

    meta = with pkgs.lib; {
      description = "CLI tool for publishing MCP servers to the registry";
      homepage = "https://github.com/modelcontextprotocol/registry";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  rustTools = with pkgs; [
    # Rust toolchain
    rust-bin.stable.latest.default
    rust-analyzer
    pkg-config
    openssl

    # Nix tools
    nixfmt-rfc-style
  ];

  webTools = with pkgs; [
    # Runtime
    bun

    # Node ecosystem (for compatibility)
    nodejs_22

    # Formatting/Linting
    biome
  ];

  cliTools = with pkgs; [
    # Filesystem
    eza
    bat
    fd
    duf
    dust
    rm-improved # rip - safer rm with graveyard

    # Search
    ripgrep
    fzf
    ast-grep

    # Text processing
    sd
    jq
    yq-go
    qsv
    hck

    # Data transformation (AI-optimized)
    gron # JSON→greppable, JSON output
    htmlq # jq for HTML
    pup # CSS selectors for HTML
    miller # Multi-format processor (JSON/CSV/etc)
    dasel # Universal data selector

    # System
    procs
    tokei
    hyperfine

    # Network
    xh
    doggo
    usql
    curlie # curl with better output

    # Web search
    ddgr # DuckDuckGo CLI with JSON output

    # Git forges
    gh # GitHub CLI
    glab # GitLab CLI

    # Containers
    podman # Rootless containers
    podman-compose # Multi-container orchestration
    docker # Docker daemon + compose v2 plugin
    buildah # OCI image builder
    docker-buildx # Multi-platform builds
    dive # Image layer analysis
    skopeo # Registry operations
    crane # Low-level registry tool
    trivy # Security scanner

    # Kubernetes
    kubectl # K8s CLI
    kubernetes-helm # Helm charts
    stern # Multi-pod logs
    kustomize # Manifest building

    # Diff/Git
    delta
    git
    difftastic
    gnupatch # For file_patch tool

    # Testing
    bats

    # Utility
    file

    # Reference
    tealdeer
    grex
    sad
    navi

    # Archives
    ouch

    # Task queue
    pueue
  ];

  # Development/publishing tools
  devTools = [
    mcp-publisher
  ];

  # Export mcp-publisher for CI
  inherit mcp-publisher;
}
