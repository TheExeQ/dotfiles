#!/usr/bin/env bash

set -euo pipefail

# Only allow execution of bootstrap from dotfiles root
BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "$PWD" != "$BOOTSTRAP_DIR" ]]; then
    echo "Error: Run this script from the dotfiles root" >&2
    exit 1
fi

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help              Show this help message
  -n, --dry-run           Show what stow would do without applying changes
  -v, --verbose           Verbose stow output
  -D, --uninstall         Uninstall stow setup
EOF
    exit 0
}

parse_args() {
    DRY_RUN=""
    VERBOSE=""
    UNINSTALL=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                ;;
            -n|--dry-run)
                DRY_RUN="-n"
                ;;
            -v|--verbose)
                VERBOSE="-v"
                ;;
            -D|--uninstall)
                UNINSTALL="-D"
                ;;
            *)
                echo "Error: Unknown option '$1'" >&2
                usage
                ;;
        esac
	shift
    done
}

parse_args "$@"

# Include lib scripts
source "./lib/env.sh"
source "./lib/gum.sh"
source "./lib/demo_ui.sh"
source "./lib/stow.sh"

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

while IFS= read -r selection; do
  stow_pkg "$selection" $DRY_RUN $VERBOSE $UNINSTALL
done <<< "$selections"
