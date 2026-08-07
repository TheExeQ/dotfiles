# Dotfiles

Personal dotfiles managed with **GNU Stow** and **Nix**, with support for macOS (Apple Silicon) and Linux.

> WORK IN PROGRESS

## Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/TheExeQ/dotfiles/nix/scripts/fetch.sh | bash
cd ~/dotfiles && ./bootstrap.sh
```

## What's Included

- **Shell** - Fish as default shell
- **Editor** - Neovim
- **Terminal** - Ghostty with custom theme
- **Tools** - Git, tmux, Python, and more
- **System** - Custom key remaps, Dock behavior, and shell preferences

See `nix/nix-darwin/flake.nix` for the full macOS setup.

## Structure

```
dotfiles/
  bootstrap.sh          # Interactive setup wizard
  scripts/fetch.sh      # One-liner remote installer
  lib/                  # Shell library modules
  stow/                 # Symlinked dotfile packages
  nix/nix-darwin/       # nix-darwin system flake
```

## How It Works

1. `fetch.sh` downloads and extracts the repo to `~/dotfiles`
2. `bootstrap.sh` installs `gum` locally, then presents an interactive menu to set up your package manager and symlink dotfiles
