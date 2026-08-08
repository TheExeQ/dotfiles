show_welcome() {
  run_gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" \
    "Welcome to Samuel's dotfiles!"
}

select_jobs() {
  echo "Which jobs would you like the bootstrapper to perform?"
  SELECTIONS=$(run_gum choose \
    --no-limit \
    --label-delimiter "#" \
    --selected "*" \
    "Setup package manager (requires nix)#pkg_manager" \
    "Setup dotfiles#dotfiles")
}

select_packages() {
  local os="$1"
  echo "Which packages do you want to stow?"
  SELECTIONS=$(run_gum choose \
    --no-limit \
    --selected "*" \
    "Shared" \
    "$os")
}

confirm_changes() {
  run_gum confirm "The following actions will be performed do you accept these changes?"
}

confirm_install_brew() {
  run_gum confirm "Homebrew is required by this dotfiles setup, do you wish to install it?"
}

confirm_install_nix() {
  run_gum confirm "Nix is required by this dotfiles setup, do you wish to install it?"
}

confirm_nix_darwin() {
  run_gum confirm "Do you wish to run nix-darwin?"
}
