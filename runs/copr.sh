#!/usr/bin/env bash

# COPR Repos and packages needed from them
# solopasha/hyprland - most packages
# erikreider/SwayNotificationCenter swaync
# errornointernet/packages - wallust ONLY
# tofik/nwg-shell - nwg-displays ONLY

# List of COPR repositories to be added and enabled
COPR_REPOS=(
  solopasha/hyprland
  erikreider/SwayNotificationCenter
  errornointernet/packages
  tofik/nwg-shell 
)

# Function to add dnf config if not present
add_config_if_not_present() {
  local file="$1"
  local config="$2"
  grep -qF "$config" "$file" || echo "$config" | sudo tee -a "$file" > /dev/null
}

# Check and add configuration settings to /etc/dnf/dnf.conf
add_config_if_not_present "/etc/dnf/dnf.conf" "max_parallel_downloads=5"
add_config_if_not_present "/etc/dnf/dnf.conf" "fastestmirror=True"
add_config_if_not_present "/etc/dnf/dnf.conf" "defaultyes=True"

# Enable RPM Fusion repositories
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &&

# Enable COPR Repositories
for repo in "${COPR_REPOS[@]}"; do
  sudo dnf copr enable -y "$repo" 2>&1 || { printf "%s - Failed to enable necessary copr repos\n" "${ERROR}"; exit 1; }
done

printf "\n%.0s" {1..1}

# Limit package installation to specific packages from certain COPRs
declare -A COPR_PACKAGE_LIMITS=(
  ["errornointernet/packages"]="wallust"
  ["tofik/nwg-shell"]="nwg-displays"  
)

# Function to modify repo files to restrict package installation
restrict_copr_packages() {
  local repo="$1"
  local package="$2"
  local repo_file="/etc/yum.repos.d/_copr:copr.fedorainfracloud.org:${repo//\//:}.repo"

  if [ -f "$repo_file" ]; then
    if grep -q "^includepkgs=$package$" "$repo_file"; then
      echo "Package restriction already exists for $repo."
    else
      echo "includepkgs=$package" | sudo tee -a "$repo_file" > /dev/null
      echo "Restricting $repo to only install $package."
    fi
  else
    echo "Repo file not found: $repo_file"
  fi
}

# Apply package restrictions
for repo in "${!COPR_PACKAGE_LIMITS[@]}"; do
  restrict_copr_packages "$repo" "${COPR_PACKAGE_LIMITS[$repo]}"
done

printf "\n%.0s" {1..1}
