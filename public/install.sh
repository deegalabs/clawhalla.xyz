#!/usr/bin/env bash
# =============================================================================
# ClawHalla Installer v0.1.1
# https://clawhalla.xyz
#
# Usage: curl -fsSL https://clawhalla.xyz/install.sh | bash
# =============================================================================

set -euo pipefail

# =============================================================================
# COLORS AND FORMATTING
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Icons
CHECK="✓"
CROSS="✗"
ARROW="→"
WARN="⚠"

# =============================================================================
# LOGGING FUNCTIONS
# =============================================================================
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
ok() { echo -e "${GREEN}[${CHECK}]${NC} $1"; }
warn() { echo -e "${YELLOW}[${WARN}]${NC} $1"; }
error() { echo -e "${RED}[${CROSS}]${NC} $1"; exit 1; }
ask() { echo -e "${CYAN}[?]${NC} $1"; }

# =============================================================================
# BANNER
# =============================================================================
show_banner() {
    echo ""
    echo -e "${YELLOW}"
    cat << 'EOF'
   _____ _                _    _       _ _       
  / ____| |              | |  | |     | | |      
 | |    | | __ ___      _| |__| | __ _| | | __ _ 
 | |    | |/ _` \ \ /\ / /  __  |/ _` | | |/ _` |
 | |____| | (_| |\ V  V /| |  | | (_| | | | (_| |
  \_____|_|\__,_| \_/\_/ |_|  |_|\__,_|_|_|\__,_|
EOF
    echo -e "${NC}"
    echo -e "${BOLD}Your AI Agent's Hall of Glory${NC}"
    echo -e "Version 0.1.1 | https://clawhalla.xyz"
    echo ""
}

# =============================================================================
# SYSTEM DETECTION
# =============================================================================
detect_os() {
    local os_name
    os_name="$(uname -s)"
    
    case "${os_name}" in
        Linux*)  OS_TYPE="linux" ;;
        Darwin*) OS_TYPE="macos" ;;
        MINGW*|MSYS*|CYGWIN*) 
            error "Windows detected. Please use WSL2 to run ClawHalla."
            ;;
        *)
            error "Unsupported OS: ${os_name}. ClawHalla supports macOS and Linux."
            ;;
    esac
    
    info "Detected OS: ${OS_TYPE}"
}

# =============================================================================
# PREREQUISITE CHECKS
# =============================================================================
check_command() {
    local cmd="$1"
    local name="$2"
    local install_url="$3"
    
    if command -v "${cmd}" &> /dev/null; then
        ok "${name} is installed"
        return 0
    else
        warn "${name} is not installed"
        echo -e "   ${ARROW} Install it from: ${BLUE}${install_url}${NC}"
        return 1
    fi
}

check_docker() {
    if ! check_command "docker" "Docker" "https://docs.docker.com/get-docker/"; then
        echo ""
        error "Docker is required. Please install Docker and run this script again."
    fi
    
    # Check if Docker daemon is running
    if docker info &> /dev/null; then
        ok "Docker daemon is running"
    else
        warn "Docker is installed but the daemon is not running"
        echo ""
        echo -e "   ${ARROW} On Linux: ${BLUE}sudo systemctl start docker${NC}"
        echo -e "   ${ARROW} On macOS: Start Docker Desktop from Applications"
        echo ""
        error "Please start Docker and run this script again."
    fi
}

check_docker_compose() {
    # Check for docker compose (v2) or docker-compose (v1)
    if docker compose version &> /dev/null; then
        ok "Docker Compose v2 is available"
        COMPOSE_CMD="docker compose"
    elif command -v docker-compose &> /dev/null; then
        ok "Docker Compose v1 is available"
        COMPOSE_CMD="docker-compose"
    else
        error "Docker Compose is not available. Please install Docker Desktop or docker-compose-plugin."
    fi
}

check_git() {
    if ! check_command "git" "Git" "https://git-scm.com/downloads"; then
        error "Git is required. Please install Git and run this script again."
    fi
}

check_curl() {
    if ! check_command "curl" "curl" "https://curl.se/download.html"; then
        # curl is usually available, but check anyway
        warn "curl not found, but you're running this script so it should be fine..."
    fi
}

run_prerequisite_checks() {
    echo ""
    echo -e "${BOLD}Checking prerequisites...${NC}"
    echo ""
    
    check_docker
    check_docker_compose
    check_git
    
    echo ""
    ok "All prerequisites met!"
}

# =============================================================================
# INTERACTIVE CONFIGURATION
# =============================================================================
ask_install_directory() {
    local default_dir="${HOME}/clawhalla"
    
    echo ""
    echo -e "${BOLD}Installation Directory${NC}"
    echo -e "Where do you want to install ClawHalla?"
    echo -e "This is where Docker files and your agent data will be stored."
    echo ""
    
    read -r -p "$(echo -e "${CYAN}[?]${NC} Directory [${default_dir}]: ")" user_input
    
    # Use default if empty
    INSTALL_DIR="${user_input:-${default_dir}}"
    
    # Expand ~ to home directory
    INSTALL_DIR="${INSTALL_DIR/#\~/${HOME}}"
    
    # Check if directory exists
    if [[ -d "${INSTALL_DIR}" ]]; then
        if [[ -d "${INSTALL_DIR}/.git" ]]; then
            warn "ClawHalla is already installed at: ${INSTALL_DIR}"
            echo ""
            read -r -p "$(echo -e "${CYAN}[?]${NC} Update existing installation? (Y/n): ")" update_choice
            if [[ "${update_choice}" =~ ^[Nn]$ ]]; then
                info "Installation cancelled."
                exit 0
            fi
            UPDATE_MODE=true
        else
            warn "Directory exists but is not a ClawHalla installation: ${INSTALL_DIR}"
            read -r -p "$(echo -e "${CYAN}[?]${NC} Use this directory anyway? (y/N): ")" use_anyway
            if [[ ! "${use_anyway}" =~ ^[Yy]$ ]]; then
                info "Please choose a different directory."
                ask_install_directory
                return
            fi
            UPDATE_MODE=false
        fi
    else
        UPDATE_MODE=false
    fi
    
    ok "Installation directory: ${INSTALL_DIR}"
}

ask_workspace_directory() {
    local default_workspace="${INSTALL_DIR}/volumes/openclaw"
    
    echo ""
    echo -e "${BOLD}OpenClaw Workspace Directory${NC}"
    echo -e "This is where your agent configurations, sessions, and data will be stored."
    echo -e "You can edit these files with your favorite IDE and changes will sync to the container."
    echo ""
    
    read -r -p "$(echo -e "${CYAN}[?]${NC} Workspace [${default_workspace}]: ")" user_input
    
    WORKSPACE_DIR="${user_input:-${default_workspace}}"
    WORKSPACE_DIR="${WORKSPACE_DIR/#\~/${HOME}}"
    
    ok "Workspace directory: ${WORKSPACE_DIR}"
}

ask_api_key() {
    echo ""
    echo -e "${BOLD}API Configuration${NC}"
    echo -e "ClawHalla uses OpenClaw which requires an AI provider API key."
    echo -e "Get your Anthropic API key at: ${BLUE}https://console.anthropic.com${NC}"
    echo ""
    
    read -r -p "$(echo -e "${CYAN}[?]${NC} Enter ANTHROPIC_API_KEY (or press Enter to skip): ")" api_key
    
    if [[ -n "${api_key}" ]]; then
        ANTHROPIC_API_KEY="${api_key}"
        ok "API key configured"
    else
        ANTHROPIC_API_KEY=""
        warn "Skipped API key. You'll need to add it to .env before running onboard."
    fi
}

ask_start_now() {
    echo ""
    read -r -p "$(echo -e "${CYAN}[?]${NC} Start ClawHalla now? (Y/n): ")" start_choice
    
    if [[ "${start_choice}" =~ ^[Nn]$ ]]; then
        START_NOW=false
    else
        START_NOW=true
    fi
}

# =============================================================================
# INSTALLATION
# =============================================================================
clone_repository() {
    echo ""
    
    if [[ "${UPDATE_MODE}" == true ]]; then
        info "Updating existing installation..."
        cd "${INSTALL_DIR}"
        git pull origin main
        ok "Repository updated"
    else
        info "Cloning ClawHalla repository..."
        
        # Create parent directory if needed
        mkdir -p "$(dirname "${INSTALL_DIR}")"
        
        git clone https://github.com/deegalabs/clawhalla.git "${INSTALL_DIR}"
        ok "Repository cloned to ${INSTALL_DIR}"
    fi
}

configure_workspace() {
    cd "${INSTALL_DIR}"
    
    # Check if workspace is different from default
    local default_workspace="${INSTALL_DIR}/volumes/openclaw"
    
    if [[ "${WORKSPACE_DIR}" != "${default_workspace}" ]]; then
        info "Configuring custom workspace directory..."
        
        # Create workspace directory
        mkdir -p "${WORKSPACE_DIR}"
        
        # Update docker-compose.yml to use custom path
        if [[ "${OS_TYPE}" == "macos" ]]; then
            sed -i '' "s|./volumes/openclaw|${WORKSPACE_DIR}|g" docker-compose.yml
        else
            sed -i "s|./volumes/openclaw|${WORKSPACE_DIR}|g" docker-compose.yml
        fi
        
        ok "Workspace configured at: ${WORKSPACE_DIR}"
    else
        # Ensure default workspace exists
        mkdir -p "${WORKSPACE_DIR}"
        ok "Using default workspace: ${WORKSPACE_DIR}"
    fi
}

configure_environment() {
    cd "${INSTALL_DIR}"
    
    if [[ ! -f ".env" ]]; then
        cp .env.example .env
        ok "Created .env from template"
    else
        ok "Existing .env found, keeping it"
    fi
    
    # Update API key if provided
    if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
        if [[ "${OS_TYPE}" == "macos" ]]; then
            sed -i '' "s|^ANTHROPIC_API_KEY=.*|ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}|" .env
        else
            sed -i "s|^ANTHROPIC_API_KEY=.*|ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}|" .env
        fi
        ok "API key saved to .env"
    fi
}

start_clawhalla() {
    if [[ "${START_NOW}" != true ]]; then
        info "Skipping container start as requested."
        return
    fi
    
    cd "${INSTALL_DIR}"
    
    info "Building and starting ClawHalla..."
    echo ""
    
    ${COMPOSE_CMD} up -d --build
    
    echo ""
    info "Waiting for container to be ready..."
    sleep 5
    
    if ${COMPOSE_CMD} ps | grep -q "clawhalla.*running\|clawhalla.*Up"; then
        ok "ClawHalla is running!"
    else
        warn "Container may still be starting. Check with: docker compose ps"
    fi
}

# =============================================================================
# FINAL INSTRUCTIONS
# =============================================================================
show_success() {
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}  Installation Complete!  ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo -e "${BOLD}Installation Details:${NC}"
    echo -e "  ${ARROW} Install directory: ${BLUE}${INSTALL_DIR}${NC}"
    echo -e "  ${ARROW} Workspace:         ${BLUE}${WORKSPACE_DIR}${NC}"
    echo ""
    
    echo -e "${BOLD}Next Steps:${NC}"
    echo ""
    
    if [[ "${START_NOW}" == true ]]; then
        echo -e "  1. Enter the container:"
        echo -e "     ${BLUE}cd ${INSTALL_DIR}${NC}"
        echo -e "     ${BLUE}docker compose exec clawhalla bash${NC}"
        echo ""
        echo -e "  2. Run the OpenClaw onboard wizard:"
        echo -e "     ${BLUE}openclaw onboard${NC}"
    else
        echo -e "  1. Navigate to the installation:"
        echo -e "     ${BLUE}cd ${INSTALL_DIR}${NC}"
        echo ""
        echo -e "  2. Configure your API key in .env (if not done):"
        echo -e "     ${BLUE}nano .env${NC}"
        echo ""
        echo -e "  3. Start ClawHalla:"
        echo -e "     ${BLUE}bash scripts/start.sh${NC}"
        echo ""
        echo -e "  4. Enter the container and run onboard:"
        echo -e "     ${BLUE}docker compose exec clawhalla bash${NC}"
        echo -e "     ${BLUE}openclaw onboard${NC}"
    fi
    
    echo ""
    echo -e "${BOLD}Useful Commands:${NC}"
    echo -e "  ${ARROW} Stop:    ${BLUE}bash scripts/stop.sh${NC}"
    echo -e "  ${ARROW} Start:   ${BLUE}bash scripts/start.sh${NC}"
    echo -e "  ${ARROW} Reset:   ${BLUE}bash scripts/reset.sh${NC}"
    echo -e "  ${ARROW} Logs:    ${BLUE}docker compose logs -f clawhalla${NC}"
    echo ""
    echo -e "${BOLD}Edit your agent:${NC}"
    echo -e "  ${ARROW} Open ${BLUE}${WORKSPACE_DIR}${NC} in your favorite IDE"
    echo -e "  ${ARROW} Changes to .md files sync automatically to the container"
    echo ""
    echo -e "${BOLD}Documentation:${NC} ${BLUE}https://clawhalla.xyz/docs${NC}"
    echo -e "${BOLD}GitHub:${NC}        ${BLUE}https://github.com/deegalabs/clawhalla${NC}"
    echo ""
}

# =============================================================================
# MAIN
# =============================================================================
main() {
    # Initialize variables
    INSTALL_DIR=""
    WORKSPACE_DIR=""
    ANTHROPIC_API_KEY=""
    UPDATE_MODE=false
    START_NOW=true
    COMPOSE_CMD="docker compose"
    OS_TYPE=""

    # Check if we have a terminal for interactive input
    # This is needed when running via: curl ... | bash
    if [[ ! -t 0 ]]; then
        if [[ -e /dev/tty ]]; then
            exec < /dev/tty
        else
            echo -e "${RED}[✗]${NC} No terminal available for interactive input."
            echo "    Please download and run the script manually:"
            echo "    curl -fsSL https://clawhalla.xyz/install.sh -o install.sh"
            echo "    bash install.sh"
            exit 1
        fi
    fi
    
    # Run installer
    show_banner
    detect_os
    run_prerequisite_checks
    
    # Interactive configuration
    ask_install_directory
    ask_workspace_directory
    ask_api_key
    ask_start_now
    
    # Installation
    clone_repository
    configure_workspace
    configure_environment
    start_clawhalla
    
    # Done
    show_success
}

# Run main function
main "$@"
