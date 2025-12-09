# scripts/tools.nix
{ pkgs, pog }:

pog.pog {
  name = "tools";
  version = "1.0.0";
  description = "List available CLI tools and their versions";

  flags = [
    {
      name = "json";
      short = "j";
      bool = true;
      description = "output as JSON";
    }
    {
      name = "category";
      short = "c";
      description = "filter by category (filesystem, search, text, system, network, diff, test, reference, archive, queue)";
      argument = "CATEGORY";
      default = "";
    }
  ];

  runtimeInputs = with pkgs; [
    coreutils
    jq
    # CLI tools to check
    eza
    bat
    fd
    duf
    dust
    ripgrep
    fzf
    ast-grep
    sd
    yq-go
    procs
    tokei
    hyperfine
    xh
    doggo
    delta
    difftastic
    bats
    tealdeer
    grex
    sad
    navi
    ouch
    pueue
  ];

  script = helpers: ''
    # Tool definitions: name:category:command
    TOOLS=(
      "eza:filesystem:eza --version"
      "bat:filesystem:bat --version"
      "fd:filesystem:fd --version"
      "duf:filesystem:duf --version"
      "dust:filesystem:dust --version"
      "rg:search:rg --version"
      "fzf:search:fzf --version"
      "ast-grep:search:sg --version"
      "sd:text:sd --version"
      "jq:text:jq --version"
      "yq:text:yq --version"
      "procs:system:procs --version"
      "tokei:system:tokei --version"
      "hyperfine:system:hyperfine --version"
      "xh:network:xh --version"
      "doggo:network:doggo --version"
      "delta:diff:delta --version"
      "difft:diff:difft --version"
      "bats:test:bats --version"
      "tldr:reference:tldr --version"
      "grex:reference:grex --version"
      "sad:reference:sad --version"
      "navi:reference:navi --version"
      "ouch:archive:ouch --version"
      "pueue:queue:pueue --version"
    )

    # Filter by category if specified
    filter_category() {
      if ${helpers.var.notEmpty "category"}; then
        echo "$1" | grep ":$category:"
      else
        echo "$1"
      fi
    }

    # Get version for a tool
    get_version() {
      local cmd="$1"
      eval "$cmd" 2>/dev/null | head -1 || echo "not found"
    }

    if ${helpers.flag "json"}; then
      # JSON output
      echo "["
      first=true
      for tool_def in "''${TOOLS[@]}"; do
        IFS=':' read -r name cat cmd <<< "$tool_def"
        if ${helpers.var.notEmpty "category"} && [ "$cat" != "$category" ]; then
          continue
        fi
        version=$(get_version "$cmd")
        if [ "$first" = true ]; then
          first=false
        else
          echo ","
        fi
        printf '  {"name": "%s", "category": "%s", "version": "%s"}' "$name" "$cat" "$version"
      done
      echo ""
      echo "]"
    else
      # Table output
      printf "%-12s %-12s %s\n" "TOOL" "CATEGORY" "VERSION"
      printf "%-12s %-12s %s\n" "----" "--------" "-------"
      for tool_def in "''${TOOLS[@]}"; do
        IFS=':' read -r name cat cmd <<< "$tool_def"
        if ${helpers.var.notEmpty "category"} && [ "$cat" != "$category" ]; then
          continue
        fi
        version=$(get_version "$cmd")
        printf "%-12s %-12s %s\n" "$name" "$cat" "$version"
      done
    fi
  '';
}
