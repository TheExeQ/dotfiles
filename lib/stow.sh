STOW_DIR="$DOTFILES_PATH/stow"
TARGET_DIR="$HOME"

stow_pkg() {
  pkg=$1
  flags=$2

  if [ -d "$STOW_DIR/$pkg" ]; then
    stow "$flags" -d "$STOW_DIR" -t "$TARGET_DIR" "$pkg"
  else
    echo "Skipping missing package: $pkg"
  fi
}
