install_brew() {
    if command -v brew &> /dev/null; then
        echo "Homebrew already installed"
        return
    fi

    echo "Installing Homebrew..."
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
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$profile"
    fi
}
