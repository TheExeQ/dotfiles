install_brew() {
  if [[ "$BREW_CHOICE" != "yes" ]]; then
    echo "Skipping homebrew installation"
    return
  fi

  if command -v brew &>/dev/null; then
    echo "Homebrew already installed"
    return
  fi

  echo "Installing Homebrew..."
  sudo -v
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

setup_brew() {
  if ! command -v brew &>/dev/null; then
    return
  fi

  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  local profile="$HOME/.zprofile"
  if [[ ! -f "$profile" ]] || ! grep -q "brew shellenv" "$profile"; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$profile"
  fi
}
