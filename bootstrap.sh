#!/usr/bin/env bash

set -euo pipefail

# Only allow execution of bootstrap from dotfiles root
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PWD" != "$BOOTSTRAP_DIR" ]]; then
    echo "Error: Run this script from the dotfiles root" >&2
    exit 1
fi

# Include lib scripts
source "./lib/env.sh"
source "./lib/gum.sh"
source "./lib/demo_ui.sh"
source "./lib/stow.sh"

install_gum

#demo_ui

stow_pkg Shared -nv
stow_pkg $OS -nv
