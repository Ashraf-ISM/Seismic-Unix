#!/bin/bash

#===============================================================================
# Seismic Unix Installation Script
# Version: 2.0
# Description: Automated installation script for Seismic Unix (SU) 
# Author: Ashraf
# Date: September 17, 2025
# License: MIT
#===============================================================================

set -euo pipefail  # Enable strict error handling

# Color codes for better output formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Configuration
readonly SCRIPT_VERSION="2.0"
readonly SU_VERSION="44R26"
readonly DEFAULT_CWPROOT="${HOME}/SeismicUnix"
readonly DEFAULT_SHELL_CONFIG="${HOME}/.bashrc"

#===============================================================================
# Utility Functions
#===============================================================================

print_header() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                      Seismic Unix Installation Script                        ║${NC}"
    echo -e "${CYAN}║                              Version ${SCRIPT_VERSION}                                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo
}

print_step() {
    echo -e "${BLUE}┌─ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ ERROR: $1${NC}" >&2
}

print_info() {
    echo -e "${WHITE}ℹ $1${NC}"
}

show_progress() {
    local current=$1
    local total=$2
    local step_name=$3
    local percentage=$((current * 100 / total))
    
    printf "\r${PURPLE}Progress: [%3d%%] %s${NC}" "$percentage" "$step_name"
    if [ "$current" -eq "$total" ]; then
        echo
    fi
}

#===============================================================================
# Validation Functions
#===============================================================================

check_prerequisites() {
    print_step "Checking prerequisites"
    
    local missing_tools=()
    
    # Check for required tools
    for tool in wget tar gcc make; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        print_error "Missing required tools: ${missing_tools[*]}"
        print_info "Please install missing tools and run the script again"
        print_info "Ubuntu/Debian: sudo apt install -y ${missing_tools[*]}"
        exit 1
    fi
    
    # Check if running on supported system
    if ! grep -qi "ubuntu\|debian" /etc/os-release 2>/dev/null; then
        print_warning "This script is optimized for Ubuntu/Debian systems"
        print_info "Continue? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
    
    print_success "All prerequisites satisfied"
}

validate_path() {
    local path="$1"
    local path_type="$2"
    
    # Check for spaces in path
    if [[ "$path" =~ [[:space:]] ]]; then
        print_error "Path cannot contain spaces: $path"
        return 1
    fi
    
    # Check if parent directory exists and is writable
    local parent_dir
    parent_dir=$(dirname "$path")
    if [ ! -d "$parent_dir" ] || [ ! -w "$parent_dir" ]; then
        print_error "$path_type parent directory is not accessible: $parent_dir"
        return 1
    fi
    
    return 0
}

#===============================================================================
# Configuration Functions
#===============================================================================

configure_installation_path() {
    print_step "Configuring installation path"
    
    echo -e "${WHITE}Seismic Unix will be installed to:${NC}"
    echo -e "${CYAN}${DEFAULT_CWPROOT}${NC}"
    echo
    echo "Options:"
    echo " • Press ENTER to use default location"
    echo " • Type a different path"
    echo " • Press CTRL+C to abort"
    echo
    
    while true; do
        printf "[%s] >>> " "${DEFAULT_CWPROOT}"
        read -r selected_dir
        
        if [ -z "$selected_dir" ]; then
            CWPROOT="$DEFAULT_CWPROOT"
            break
        else
            if validate_path "$selected_dir" "Installation directory"; then
                CWPROOT="$selected_dir"
                break
            fi
        fi
        print_warning "Please enter a valid path"
    done
    
    print_success "Installation path set to: $CWPROOT"
}

configure_shell_config() {
    print_step "Configuring shell environment"
    
    # Auto-detect shell configuration file
    local detected_config="$DEFAULT_SHELL_CONFIG"
    case "$SHELL" in
        */zsh) detected_config="${HOME}/.zshrc" ;;
        */fish) detected_config="${HOME}/.config/fish/config.fish" ;;
        */bash) detected_config="${HOME}/.bashrc" ;;
    esac
    
    echo -e "${WHITE}Shell configuration file:${NC}"
    echo -e "${CYAN}${detected_config}${NC}"
    echo
    echo "Options:"
    echo " • Press ENTER to use detected file"
    echo " • Type a different path"
    echo " • Press CTRL+C to abort"
    echo
    
    while true; do
        printf "[%s] >>> " "$detected_config"
        read -r selected_path
        
        if [ -z "$selected_path" ]; then
            SHELL_CONFIG_FILE="$detected_config"
            break
        else
            if validate_path "$selected_path" "Shell configuration file"; then
                SHELL_CONFIG_FILE="$selected_path"
                break
            fi
        fi
        print_warning "Please enter a valid path"
    done
    
    print_success "Shell config file set to: $SHELL_CONFIG_FILE"
}

#===============================================================================
# Installation Functions
#===============================================================================

create_installation_directory() {
    print_step "Creating installation directory"
    
    if ! mkdir -p "$CWPROOT"; then
        print_error "Could not create directory: $CWPROOT"
        exit 1
    fi
    
    print_success "Installation directory created"
}

install_dependencies() {
    print_step "Installing system dependencies"
    
    local packages=(
        # General development tools
        "gcc" "make" "libc6-dev" "build-essential"
        # X11 libraries
        "libx11-dev" "libxt-dev"
        # Fortran compiler
        "gfortran"
        # OpenGL/Mesa libraries
        "libglu1-mesa-dev" "freeglut3-dev" "libxmu-dev" "libxmu-headers" "libxi-dev"
        # Motif libraries
        "libxt6" "libmotif-dev"
        # Additional utilities
        "curl" "unzip"
    )
    
    print_info "Installing packages: ${packages[*]}"
    
    if ! sudo apt update; then
        print_error "Failed to update package lists"
        exit 1
    fi
    
    if ! sudo apt install -y "${packages[@]}"; then
        print_error "Failed to install dependencies"
        exit 1
    fi
    
    print_success "Dependencies installed successfully"
}

download_seismic_unix() {
    print_step "Downloading Seismic Unix $SU_VERSION"
    
    local download_url='https://nextcloud.seismic-unix.org/s/LZpzc8jMzbWG9BZ/download?path=%2F&files=cwp_su_all_44R26.tgz&downloadStartSecret=d0kkx4lkunp'
    local tarball_name="cwp_su_all_${SU_VERSION}.tgz"
    
    if [ -f "$tarball_name" ]; then
        print_info "Tarball already exists, skipping download"
    else
        if ! wget --progress=dot:giga "$download_url" -O "$tarball_name"; then
            print_error "Failed to download Seismic Unix"
            exit 1
        fi
    fi
    
    print_success "Download completed"
}

extract_tarball() {
    print_step "Extracting Seismic Unix"
    
    local tarball_name="cwp_su_all_${SU_VERSION}.tgz"
    
    if ! tar -xzf "$tarball_name" -C "$CWPROOT"; then
        print_error "Failed to extract tarball"
        exit 1
    fi
    
    print_success "Extraction completed"
}

download_makefile_config() {
    print_step "Downloading pre-configured Makefile"
    
    local makefile_url="https://gist.githubusercontent.com/botoseis/b6fc908ebf96fd19b092dda59e52abd2/raw/3b436dec519c6acd0eb7fb1442a387395406b2a5/Makefile.config"
    local makefile_path="${CWPROOT}/src/Makefile.config"
    
    if ! wget "$makefile_url" -O "$makefile_path"; then
        print_error "Failed to download Makefile.config"
        exit 1
    fi
    
    print_success "Makefile configuration downloaded"
}

compile_seismic_unix() {
    print_step "Compiling Seismic Unix (this may take a while...)"
    
    cd "${CWPROOT}/src" || exit 1
    export CWPROOT
    
    local build_targets=(
        "install:General programs"
        "xtinstall:X-toolkit applications" 
        "finstall:Fortran codes"
        "mglinstall:Mesa/OpenGL programs"
        "utils:Utilities"
        "xminstall:Motif programs"
        "sfinstall:Improved SEGDREAD"
    )
    
    local total_targets=${#build_targets[@]}
    local current_target=1
    
    for target_info in "${build_targets[@]}"; do
        IFS=':' read -r target description <<< "$target_info"
        show_progress $current_target $total_targets "Building $description"
        
        if ! make "$target" >/dev/null 2>&1; then
            echo
            print_warning "Failed to build $description (non-critical)"
        fi
        
        ((current_target++))
    done
    
    echo
    print_success "Compilation completed"
}

setup_environment() {
    print_step "Setting up environment variables"
    
    # Create backup of shell config
    if [ -f "$SHELL_CONFIG_FILE" ]; then
        cp "$SHELL_CONFIG_FILE" "${SHELL_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backup created: ${SHELL_CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Add environment variables
    {
        echo ""
        echo "# Seismic Unix Environment Variables (added by installer)"
        echo "export CWPROOT='${CWPROOT}'"
        echo 'export PATH="${PATH}:${CWPROOT}/bin"'
        echo ""
    } >> "$SHELL_CONFIG_FILE"
    
    print_success "Environment variables configured"
}

cleanup() {
    print_step "Cleaning up temporary files"
    
    local tarball_name="cwp_su_all_${SU_VERSION}.tgz"
    if [ -f "$tarball_name" ]; then
        rm -f "$tarball_name"
        print_info "Removed temporary tarball"
    fi
    
    print_success "Cleanup completed"
}

#===============================================================================
# Main Installation Process
#===============================================================================

main() {
    print_header
    
    # Trap to ensure cleanup on exit
    trap 'echo -e "\n${RED}Installation interrupted${NC}"; exit 1' INT TERM
    
    check_prerequisites
    configure_installation_path  
    configure_shell_config
    create_installation_directory
    install_dependencies
    download_seismic_unix
    extract_tarball
    download_makefile_config
    compile_seismic_unix
    setup_environment
    cleanup
    
    # Final success message
    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    🎉 Installation Completed Successfully! 🎉                ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${WHITE}Next steps:${NC}"
    echo -e "${YELLOW}1.${NC} Reload your shell environment:"
    echo -e "   ${CYAN}source $SHELL_CONFIG_FILE${NC}"
    echo
    echo -e "${YELLOW}2.${NC} Test the installation:"
    echo -e "   ${CYAN}suplane | suximage${NC}"
    echo
    echo -e "${WHITE}Installation Details:${NC}"
    echo -e "• Install Path: ${CYAN}$CWPROOT${NC}"
    echo -e "• Shell Config: ${CYAN}$SHELL_CONFIG_FILE${NC}"
    echo -e "• Version: ${CYAN}Seismic Unix $SU_VERSION${NC}"
    echo
    echo -e "${GREEN}Happy seismic processing! 🌊${NC}"
}

# Run the main function
main "$@"
