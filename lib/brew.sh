_install_brew() {

  if command -v brew &>/dev/null; then
    echo "Homebrew already installed"
    return
  fi

  echo "Installing Homebrew..."
  sudo -v
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for current session
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Add to .zprofile if not already present
  local profile="$HOME/.zprofile"
  if [[ ! -f "$profile" ]] || ! grep -q "brew shellenv" "$profile"; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$profile"
  fi

}

setup_brew() {

  if ! command -v brew &>/dev/null; then
    if "$GUM" confirm "Homebrew is required by this dotfiles setup, do you wish to install it?"; then
      _install_brew
    else
      echo "Skipping homebrew installation"
    fi
  fi

}
