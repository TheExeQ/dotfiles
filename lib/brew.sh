_require_brew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed"
    return 1
  fi
}

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
  local brew_path=""

  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    brew_path="/opt/homebrew/bin/brew"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    brew_path="/usr/local/bin/brew"
  fi

  if [[ -n "$brew_path" ]]; then
    eval "$("$brew_path" shellenv)"
  fi

  _require_brew || return

  local profile="$HOME/.zprofile"
  if [[ ! -f "$profile" ]] || ! grep -q "brew shellenv" "$profile"; then
    echo "eval \"\$($brew_path shellenv)\"" >>"$profile"
  fi
}
