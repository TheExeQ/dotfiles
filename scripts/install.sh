#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
REPO_URL="https://github.com/TheExeQ/dotfiles/tarball/nix" # currently using nix branch while testing

# Check dependencies
for cmd in curl tar; do
    if ! command -v "$cmd" &>/dev/null; then
        echo "Error: $cmd is required but not installed." >&2
        exit 1
    fi
done

# Check if directory already exists
if [[ -d "$DOTFILES_DIR" ]]; then
    echo "Directory $DOTFILES_DIR already exists."
    read -rp "Overwrite? [y/N] " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 1
    fi
    rm -rf "$DOTFILES_DIR"
fi

# Download and extract
echo "Downloading dotfiles..."
TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

if ! curl -fsSL -o "$TMPFILE" "$REPO_URL"; then
    echo "Error: Failed to download dotfiles." >&2
    exit 1
fi

echo "Installing to $DOTFILES_DIR..."
mkdir -p "$DOTFILES_DIR"
tar -xzf "$TMPFILE" --strip-components 1 -C "$DOTFILES_DIR"

# Run bootstrap
cd "$DOTFILES_DIR"
echo "Running bootstrap..."
./bootstrap.sh "$@"
