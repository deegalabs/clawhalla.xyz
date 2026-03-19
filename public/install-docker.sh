#!/bin/bash
# =============================================================================
# ClawHalla Docker-only installer
# Usage: curl -fsSL https://clawhalla.xyz/install-docker.sh | bash
# =============================================================================

set -euo pipefail

echo "[INFO] Checking Docker..."
command -v docker >/dev/null 2>&1 || { echo "[ERROR] Docker not found"; exit 1; }
docker compose version >/dev/null 2>&1 || { echo "[ERROR] Docker Compose not found"; exit 1; }

echo "[INFO] Cloning repository..."
if [ ! -d "$HOME/clawhalla" ]; then
  git clone https://github.com/deegalabs/clawhalla.git "$HOME/clawhalla"
fi

cd "$HOME/clawhalla"
cp -n .env.example .env || true

echo "[INFO] Starting Docker stack..."
docker compose up -d --build

echo "[OK] Done. Run onboard manually:"
echo "     docker compose exec clawhalla bash"
echo "     openclaw onboard"
