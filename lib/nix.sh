_install_nix() {

  if command -v nix &>/dev/null; then
    echo "Nix already installed"
    return
  fi

  echo "WIP: Auto download nix is currently not working, please install it manually and rerun this script"
  exit 0

  echo "Installing Nix Package Manager..."
  sudo -v
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon

  export PATH="/nix/var/nix/profiles/default/bin:$PATH" # todo: this is not enough and needs to be fixed
}

_nix_flags() {
  NIX_FLAGS=()

  # Check if experimental features are already enabled via nix show-config
  local experimental_features
  experimental_features=$(nix show-config 2>/dev/null | grep "^experimental-features" | awk -F' = ' '{print $2}' || true)

  if [[ "$experimental_features" == *"flakes"* && "$experimental_features" == *"nix-command"* ]]; then
    return
  fi

  # Experimental features not enabled, add flags
  NIX_FLAGS+=(--extra-experimental-features "nix-command flakes")
}

setup_nix() {
  if ! command -v nix &>/dev/null; then
    if run_gum confirm "Nix is required by this dotfiles setup, do you wish to install it?"; then
      _install_nix
    else
      echo "Skipping nix installation"
      exit 0
    fi
  fi

  _nix_flags
}

setup_nix_darwin() {
  if ((${#NIX_FLAGS[@]} > 0)); then
    echo "Required Nix experimental features are not enabled in the Nix config; using command-line flags."
  fi

  if ! run_gum confirm "Do you wish to run nix-darwin?"; then
    return
  fi

  local NIX_COMMAND
  local FLAKE_DIR="$DOTFILES_PATH/nix/"

  if command -v darwin-rebuild &>/dev/null; then
    NIX_COMMAND=(darwin-rebuild)
  else
    NIX_COMMAND=(nix "${NIX_FLAGS[@]}" run nix-darwin/master#darwin-rebuild --)
  fi

  if [[ -f "$FLAKE_DIR/flake.nix" ]]; then
    sudo "${NIX_COMMAND[@]}" switch --flake "$FLAKE_DIR#MBP"
  fi
}
