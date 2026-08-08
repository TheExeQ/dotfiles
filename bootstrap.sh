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
source "./lib/ui.sh"

_setup_pkg_manager() {
  # Verifies that the user has nix installed.
  setup_nix

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
  done <<<"$selections"
}

_setup_dotfiles() {

  # Verifies that the user has stow installed.
  check_stow

  select_packages "$OS"
  local selections="$SELECTIONS"

  # Perform dry run to make sure user approves changes before performing them.
  echo "Stowing to $TARGET_DIR"
  _stow_selections "$selections" -n -v $UNINSTALL

  if confirm_changes; then
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

show_welcome

select_jobs
selections="$SELECTIONS"

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
done <<<"$selections"
