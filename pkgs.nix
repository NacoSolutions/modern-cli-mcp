# pkgs.nix
{ pkgs }:
{
  devTools = with pkgs; [
    # Rust toolchain
    rust-bin.stable.latest.default
    rust-analyzer
    pkg-config
    openssl

    # Nix tools
    nixfmt-rfc-style
  ];

  cliTools = with pkgs; [
    # Filesystem
    eza
    bat
    fd
    duf
    dust
    trash-cli

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

    # System
    procs
    tokei
    hyperfine

    # Network
    xh
    doggo
    usql

    # Diff/Git
    delta
    git
    difftastic

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
}
