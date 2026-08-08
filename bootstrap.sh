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
  install_nix
  setup_nix

  if [[ "$OS" == "Darwin" ]]; then
    install_brew
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

  echo "Stowing to $TARGET_DIR"
  _stow_selections "$PACKAGES" -n -v $UNINSTALL

  _stow_selections "$PACKAGES" -v $UNINSTALL
  echo "Stow succeeded"
}

bootstrap_parse_args "$@"

# Downloads binaries for gum (Terminal User Interface) for nicer UI with the bootstrap.
install_gum

clear

show_welcome

# Phase 1: Collect all choices
select_jobs
JOBS="$SELECTIONS"

if [[ "$JOBS" == *"pkg_manager"* ]]; then
  select_nix
  if [[ "$OS" == "Darwin" ]]; then
    select_brew
    select_nix_darwin
  fi
fi

if [[ "$JOBS" == *"dotfiles"* ]]; then
  select_packages "$OS"
  PACKAGES="$SELECTIONS"
fi

# Phase 2: Show summary and confirm
show_summary

if ! confirm_summary; then
  echo "Aborted."
  exit 0
fi

# Phase 3: Execute silently
clear

while IFS= read -r job; do
  case "$job" in
  pkg_manager)
    _setup_pkg_manager
    ;;
  dotfiles)
    _setup_dotfiles
    ;;
  esac
done <<<"$JOBS"
