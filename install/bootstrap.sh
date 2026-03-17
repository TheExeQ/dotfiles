#!/bin/sh
set -eu

usage() {
  echo "Usage: $0 [--dry-run]"
  echo ""
  echo "Options:"
  echo "  --dry-run   Show what would be done without making changes"
  echo "  --help      Show this help message"
}

DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
  --dry-run)
    DRY_RUN=1
    ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    echo "Error: unknown argument: $arg" >&2
    exit 1
    ;;
  esac
done

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU Stow is not installed." >&2
  exit 1
fi

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
REPO_DIR=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd -P)
STOW_DIR="$REPO_DIR/stow"
TARGET_DIR="$HOME"
OS=$(uname -s)

STOW_FLAGS="-v"
if [ "$DRY_RUN" -eq 1 ]; then
  STOW_FLAGS="-n -v"
fi

stow_pkg() {
  pkg=$1

  if [ -d "$STOW_DIR/$pkg" ]; then
    echo "Stowing package: $pkg"
    # shellcheck disable=SC2086
    stow $STOW_FLAGS -d "$STOW_DIR" -t "$TARGET_DIR" "$pkg"
  else
    echo "Skipping missing package: $pkg"
  fi
}

echo "Script dir:   $SCRIPT_DIR"
echo "Repo dir:     $REPO_DIR"
echo "Stow dir:     $STOW_DIR"
echo "Target dir:   $TARGET_DIR"
echo "OS:           $OS"
echo "Note: if you see conflicts, remove existing unmanaged files in $TARGET_DIR and rerun."

stow_pkg shared

case "$OS" in
Darwin)
  stow_pkg mac
  ;;
Linux)
  stow_pkg linux
  ;;
*)
  echo "Error: unsupported OS: $OS" >&2
  exit 1
  ;;
esac
