#!/bin/bash
# =============================================================================
# ClawHalla Installer
# https://clawhalla.xyz
#
# Usage: curl -fsSL https://clawhalla.xyz/install.sh | bash
# =============================================================================

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

CHECK="✓"
CROSS="✗"
ARROW="→"

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok() { echo -e "${GREEN}[${CHECK}]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[${CROSS}]${NC} $1"; exit 1; }

echo ""
echo -e "${YELLOW}"
echo "   _____ _                _    _       _ _       "
echo "  / ____| |              | |  | |     | | |      "
echo " | |    | | __ ___      _| |__| | __ _| | | __ _ "
echo " | |    | |/ _\` \\ \\ /\\ / /  __  |/ _\` | | |/ _\` |"
echo " | |____| | (_| |\\ V  V /| |  | | (_| | | | (_| |"
echo "  \\_____|_|\\__,_| \\_/\\_/ |_|  |_|\\__,_|_|_|\\__,_|"
echo -e "${NC}"
echo -e "${BOLD}Your AI Agent's Hall of Glory${NC}"
echo ""

OS="$(uname -s)"
case "$OS" in
  Linux*) OS_TYPE="linux" ;;
  Darwin*) OS_TYPE="macos" ;;
  *) error "Unsupported OS: $OS. ClawHalla supports macOS and Linux." ;;
esac

info "Detected OS: $OS_TYPE"

if ! command -v docker >/dev/null 2>&1; then
  error "Docker is not installed. Install it first: https://docs.docker.com/get-docker/"
fi
ok "Docker is installed"

if ! docker compose version >/dev/null 2>&1; then
  error "Docker Compose is not available. Install Docker Desktop or docker-compose-plugin."
fi
ok "Docker Compose is available"

DEFAULT_DIR="$HOME/clawhalla"
read -r -p "Installation directory [$DEFAULT_DIR]: " INSTALL_DIR
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_DIR}"
INSTALL_DIR="${INSTALL_DIR/#\~/$HOME}"

if [ -d "$INSTALL_DIR" ] && [ ! -d "$INSTALL_DIR/.git" ]; then
  warn "Directory exists and is not a git checkout: $INSTALL_DIR"
fi

if [ -d "$INSTALL_DIR/.git" ]; then
  info "Updating existing installation..."
  cd "$INSTALL_DIR"
  git pull origin main
  ok "Repository updated"
else
  info "Cloning ClawHalla..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone https://github.com/deegalabs/clawhalla.git "$INSTALL_DIR"
  ok "Repository cloned"
fi

cd "$INSTALL_DIR"
if [ ! -f .env ]; then
  cp .env.example .env
  ok "Created .env from template"
fi

info "Building and starting ClawHalla..."
docker compose up -d --build

ok "Installation complete"
echo -e "${ARROW} Next: cd $INSTALL_DIR && docker compose exec clawhalla bash && openclaw onboard"
