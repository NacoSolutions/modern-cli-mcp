#!/bin/sh
# modern-cli-mcp/install.sh
# Install modern-cli-mcp binary or AppImage
set -e

VERSION="${VERSION:-latest}"
BUNDLE="full"   # full (AppImage) or binary
SCOPE="user"    # user (~/.local/bin) or system (/usr/local/bin)

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --binary|-b) BUNDLE="binary" ;;
    --full|-f) BUNDLE="full" ;;
    --system|-s) SCOPE="system" ;;
    --user|-u) SCOPE="user" ;;
    --help|-h)
      echo "Install modern-cli-mcp"
      echo ""
      echo "Usage: install.sh [OPTIONS]"
      echo ""
      echo "Bundle options:"
      echo "  --full, -f     Install AppImage with bundled CLI tools (default)"
      echo "  --binary, -b   Install Rust binary only (requires tools in PATH)"
      echo ""
      echo "Scope options:"
      echo "  --user, -u     Install to ~/.local/bin (default)"
      echo "  --system, -s   Install to /usr/local/bin (requires sudo)"
      echo ""
      echo "Environment variables:"
      echo "  VERSION        Release version (default: latest)"
      echo "  INSTALL_DIR    Custom install directory (overrides scope)"
      echo ""
      echo "Examples:"
      echo "  # Default: AppImage to ~/.local/bin"
      echo "  curl -fsSL https://raw.githubusercontent.com/NacoSolutions/modern-cli-mcp/main/install.sh | sh"
      echo ""
      echo "  # System-wide AppImage"
      echo "  curl -fsSL .../install.sh | sh -s -- --system"
      echo ""
      echo "  # Binary only (you have CLI tools installed)"
      echo "  curl -fsSL .../install.sh | sh -s -- --binary"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Run with --help for usage"
      exit 1
      ;;
  esac
done

# Determine install directory
if [ -n "$INSTALL_DIR" ]; then
  DIR="$INSTALL_DIR"
elif [ "$SCOPE" = "system" ]; then
  DIR="/usr/local/bin"
else
  DIR="$HOME/.local/bin"
fi

# Determine download URL
REPO="NacoSolutions/modern-cli-mcp"
if [ "$VERSION" = "latest" ]; then
  BASE_URL="https://github.com/$REPO/releases/latest/download"
else
  BASE_URL="https://github.com/$REPO/releases/download/$VERSION"
fi

if [ "$BUNDLE" = "binary" ]; then
  URL="$BASE_URL/modern-cli-mcp-linux-x86_64"
  echo "Installing binary to $DIR/modern-cli-mcp..."
else
  URL="$BASE_URL/modern-cli-mcp-x86_64.AppImage"
  echo "Installing AppImage to $DIR/modern-cli-mcp..."
fi

# Create directory and download
if [ "$SCOPE" = "system" ]; then
  sudo mkdir -p "$DIR"
  curl -fsSL "$URL" | sudo tee "$DIR/modern-cli-mcp" > /dev/null
  sudo chmod +x "$DIR/modern-cli-mcp"
else
  mkdir -p "$DIR"
  curl -fsSL "$URL" -o "$DIR/modern-cli-mcp"
  chmod +x "$DIR/modern-cli-mcp"
fi

echo "Installed to $DIR/modern-cli-mcp"

# Verify installation
if [ -x "$DIR/modern-cli-mcp" ]; then
  echo ""
  if [ "$BUNDLE" = "full" ]; then
    echo "AppImage installed with 60+ bundled CLI tools."
  else
    echo "Binary installed. Requires CLI tools (eza, fd, rg, etc.) in PATH."
  fi
fi

# PATH reminder for user installs
if [ "$SCOPE" = "user" ]; then
  case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *)
      echo ""
      echo "Add to PATH (add to ~/.bashrc or ~/.zshrc):"
      echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
      ;;
  esac
fi

echo ""
echo "Configure your MCP client:"
echo "  {\"command\": \"$DIR/modern-cli-mcp\", \"args\": []}"
