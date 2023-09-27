#!/bin/bash

# ============================================================================
#                 HYPRLAND NVIDIA AUR PACKAGE DEPENDENCIES INSTALLER
# ============================================================================

# ============================================================================
#                               VARIABLES
# ============================================================================

# AUR package version
aur_package_version="0.30.0"

# URL of the repository
repository_url="https://github.com/sunsetzfrags/HyprlandNvidia-AUR"

# URL of Hyprland Nvidia documentation
hyprland_nvidia_docs="https://wiki.hyprland.org/Nvidia/"

# URL of Hyprland xdg-desktop-portal-hyprland documentation
hyprland_xdg_portal_docs="https://wiki.hyprland.org/Useful-Utilities/Hyprland-desktop-portal/"

# Array of required packages
required_packages=(
	cairo
	cmake
	ffmpeg
	gdb
	gcc
	git
	glslang
	libdisplay-info
	libinput
	libliftoff
	libx11
	libxcb
	libxcomposite
	libxfixes
	libxkbcommon
	libxrender
	meson
	ninja
	pango
	pixman
	polkit
	seatd
	vulkan-headers
	vulkan-icd-loader
	vulkan-validation-layers
	wayland
	wayland-protocols
	xcb-proto
	xcb-util
	xcb-util-errors
	xcb-util-keysyms
	xcb-util-renderutil
	xcb-util-wm
	xorg-xinput
	xorg-xwayland
	xorgproto
)

# Array of additional recommended packages
additional_packages=(
    qt5-wayland
    qt5ct
    libva
)

# Package name for X11 compatibility
xdg_portal_package="xdg-desktop-portal-hyprland"

# ============================================================================
#                              FUNCTIONS
# ============================================================================

# Function to check if the script is run with sudo
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script requires root privileges. Please run with 'sudo'."
        exit 1
    fi
}

# Function to print the greeting message
print_greeting() {
    echo ""
    echo "Welcome to the AUR Package Dependencies Installer Script for Hyprland-Nvidia (AUR version: $aur_package_version)"
    echo "For more information, visit the repository on $repository_url."
    echo ""
}

# Function to confirm user action
confirm_action() {
    read -p "$1 (yes/no): " user_confirmation
    # If the response is empty (just Enter), consider it as confirmation
    if [[ -z "$user_confirmation" || "$user_confirmation" =~ ^[Yy](es)?$ ]]; then
        return 0  # User confirmed (Yes)
    else
        return 1  # User canceled or entered No
    fi
}

# Function to install packages
install_packages() {
    local packages=("$@")
    echo ""
    pacman -S --needed "${packages[@]}" || { echo "Error installing one or more packages"; exit 1; }
    echo ""
}

# Function to print success message
print_success_message() {
    echo ""
    echo "All required packages installed successfully."
    echo "Congratulations! You can now clone the Hyprland-Nvidia AUR package, compile, and perform the installation."
    echo "For more information on Hyprland Nvidia, please refer to the documentation: $hyprland_nvidia_docs"
    echo "For information on xdg-desktop-portal-hyprland, visit: $hyprland_xdg_portal_docs"
    echo ""
}

# ============================================================================
#                            MAIN SCRIPT
# ============================================================================

# Check if the script is run with sudo
check_sudo

# Print the greeting message
print_greeting

# Confirm if the user wants to continue with the installation
if ! confirm_action "Do you want to continue with the installation?"; then
    echo "Installation canceled."
    exit 0
fi

# Install required packages
install_packages "${required_packages[@]}"

# Check if the user wants to install additional recommended packages
if confirm_action "Do you also want to install additional recommended packages from the Hyprland Nvidia Wiki?"; then
    install_packages "${additional_packages[@]}"
    echo "Additional recommended packages installed successfully."
fi

# Check if the user wants to install xdg-desktop-portal-hyprland for X11 compatibility
if confirm_action "Do you also want to install xdg-desktop-portal-hyprland for X11 compatibility?"; then
    pacman -S --needed "$xdg_portal_package" || { echo "Error installing $xdg_portal_package"; exit 1; }
    echo "$xdg_portal_package installed successfully."
fi

# Print the final success message
print_success_message
