#!/usr/bin/env bash

set -euo pipefail

# Only allow execution of bootstrap from dotfiles root
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PWD" != "$BOOTSTRAP_DIR" ]]; then
    echo "Error: Run this script from the dotfiles root" >&2
    exit 1
fi

# Include lib scripts
source "./lib/options.sh"
source "./lib/env.sh"
source "./lib/gum.sh"
source "./lib/demo_ui.sh"
source "./lib/stow.sh"

bootstrap_parse_args "$@"

install_gum

#demo_ui

clear

"$GUM" style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" \
"Welcome to Samuel's dotfiles!"

echo "Stow packages:"
selections=$(
"$GUM" choose \
--no-limit \
"Shared" \
"$OS"
)

echo "Stowing to $TARGET_DIR"
while IFS= read -r selection; do
  stow_pkg "$selection" $DRY_RUN $VERBOSE $UNINSTALL
done <<< "$selections"
