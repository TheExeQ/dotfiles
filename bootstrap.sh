#!/usr/bin/env bash

set -euo pipefail

# Only allow execution of bootstrap from repo root
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CURRENT_DIR="$(pwd -P)"

if [[ "$CURRENT_DIR" != "$BOOTSTRAP_DIR" ]]; then
    echo "Error: Run this script from the dotfiles root" >&2
    exit 1
fi

# Import lib scripts
source "./lib/options.sh"
source "./lib/env.sh"
source "./lib/gum.sh"
source "./lib/stow.sh"

source "./lib/nix.sh"
source "./lib/brew.sh"

_setup_pkg_manager() {

# Verifies that the user has nix installed.
check_nix

# Updates NIX_FLAGS variable depending on which nix installation the user has.
setup_nix_flags

# Only runs on Darwin systems.
if [[ "$OS" == "Darwin" ]]; then
	setup_brew

	setup_nix_darwin
fi

}

_stow_selections() {

local selections="$1"
shift

while IFS= read -r selection; do
  stow_pkg "$selection" "$@"
done <<< "$selections"

}

_setup_dotfiles() {

# Verifies that the user has stow installed.
check_stow

echo "Which packages do you want to stow?"
local selections=$(
"$GUM" choose \
--no-limit \
"Shared" \
"$OS"
)

# Perform dry run to make sure user approves changes before performing them.
echo "Stowing to $TARGET_DIR"
_stow_selections "$selections" -n -v $UNINSTALL

if "$GUM" confirm "The following actions will be performed do you accept these changes?"; then
	_stow_selections "$selections" -v $UNINSTALL
	echo "Stow succeeded"
else
	echo "Stow aborted"
fi

}

bootstrap_parse_args "$@"

# Downloads binaries for gum (Terminal User Interface) for nicer UI with the bootstrap.
install_gum

clear

"$GUM" style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" \
"Welcome to Samuel's dotfiles!"

echo "Which jobs would you like the bootstrapper to perform?"
selections=$(
"$GUM" choose \
--no-limit \
--label-delimiter "#" \
"Setup package manager (requires nix)#pkg_manager" \
"Setup dotfiles#dotfiles"
)

while IFS= read -r selection; do
	case "$selection" in
        pkg_manager)
	    _setup_pkg_manager
            ;;
        dotfiles)
            _setup_dotfiles
            ;;
        *)
            echo "Unknown selection: $selection"
            ;;
    esac
done <<< "$selections"
