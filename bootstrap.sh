#!/bin/sh
set -eu

if ! command -v stow >/dev/null 2>&1; then
    echo "Error: GNU Stow is not installed." >&2
    exit 1
fi

REPO_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
TARGET_DIR=$HOME
OS=$(uname -s)

STOW_FLAGS="-v"
if [ "${1-}" = "--dry-run" ]; then
    STOW_FLAGS="-n -v"
fi

stow_pkg() {
    pkg=$1

    if [ -d "$REPO_DIR/$pkg" ]; then
        echo "Stowing package: $pkg"
        # shellcheck disable=SC2086
        stow $STOW_FLAGS -d "$REPO_DIR" -t "$TARGET_DIR" "$pkg"
    else
        echo "Skipping missing package: $pkg"
    fi
}

echo "Dotfiles repo: $REPO_DIR"
echo "Target dir:   $TARGET_DIR"
echo "OS:           $OS"

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
