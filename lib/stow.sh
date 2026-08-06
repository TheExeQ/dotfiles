STOW_DIR="$DOTFILES_PATH/stow"
TARGET_DIR="$HOME"

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow is not installed." >&2
  exit 1
fi

stow_pkg() {
  local pkg="$1"
  [ -z "$pkg" ] && return
  local subdir="$2"
  shift 2
  local flags=("$@")

  local stow_path="$STOW_DIR/$subdir"

  if [ -d "$stow_path/$pkg" ]; then
    stow "${flags[@]}" -d "$stow_path" -t "$TARGET_DIR" "$pkg"
  else
    echo "Skipping missing package: $pkg"
  fi
}
