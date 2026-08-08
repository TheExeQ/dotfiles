show_welcome() {
  run_gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" \
    "Welcome to Samuel's dotfiles!"
}

select_jobs() {
  echo "Which setup tasks would you like to run?"
  SELECTIONS=$(run_gum choose \
    --no-limit \
    --label-delimiter "#" \
    --selected "*" \
    "Setup package manager (requires nix)#pkg_manager" \
    "Setup dotfiles#dotfiles")
}

select_packages() {
  local os="$1"
  echo "Which package sets would you like to install?"
  SELECTIONS=$(run_gum choose \
    --no-limit \
    --selected "*" \
    "Shared" \
    "$os")
}

select_nix() {
  if command -v nix &>/dev/null; then
    echo "Nix already installed"
    NIX_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    NIX_CHOICE="no"
    return
  fi

  NIX_CHOICE=$(run_gum confirm "Nix is required. Install it?" && echo "yes" || echo "no")
}

select_brew() {
  if command -v brew &>/dev/null; then
    echo "Homebrew already installed"
    BREW_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    BREW_CHOICE="no"
    return
  fi

  BREW_CHOICE=$(run_gum confirm "Homebrew is required. Install it?" && echo "yes" || echo "no")
}

select_nix_darwin() {
  if ! command -v nix &>/dev/null && [[ "$NIX_CHOICE" != "yes" ]]; then
    echo "Skipping nix-darwin (nix not installed)"
    NIX_DARWIN_CHOICE="no"
    return
  fi

  if [[ -n "${UNINSTALL:-}" ]]; then
    return
  fi

  NIX_DARWIN_CHOICE=$(run_gum confirm "Do you want to enable nix-darwin?" && echo "yes" || echo "no")
}

show_summary() {
  run_gum style --foreground 212 --border-foreground 212 --border double --align left --width 50 --margin "1 2" --padding "2 4" \
    "Summary of your choices:" \
    "" \
    "Jobs: $JOBS" \
    "Install Nix: ${NIX_CHOICE:-no}" \
    "Install Homebrew: ${BREW_CHOICE:-no}" \
    "Run nix-darwin: ${NIX_DARWIN_CHOICE:-no}" \
    "Packages: ${PACKAGES:-none}" \
    "" \
    "Note: The --uninstall flag will remove dotfiles and nix-darwin." \
    "Nix and Homebrew must be uninstalled manually."
}

confirm_summary() {
  run_gum confirm "Do you want to proceed with these choices?"
}
