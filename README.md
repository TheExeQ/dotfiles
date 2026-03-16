# Dotfiles

This repo is configured with GNU Stow via `bootstrap.sh`.

## Prerequisites

- `git`
- GNU Stow (`stow`)

Install Stow:

- macOS (Homebrew): `brew install stow`
- Debian/Ubuntu: `sudo apt install stow`
- Fedora: `sudo dnf install stow`

## Configure dotfiles with bootstrap script

1. Clone the repo:

   ```bash
   git clone https://github.com/TheExeQ/dotfiles ~/dotfiles
   cd ~/dotfiles
   ```

2. Optional: preview changes without modifying files:

   ```bash
   ./bootstrap.sh --dry-run
   ```

3. Apply configuration:

   ```bash
   ./bootstrap.sh
   ```

## What `bootstrap.sh` does

- Verifies `stow` is installed.
- Uses your home directory (`$HOME`) as the stow target.
- Always stows the `shared/` package.
- Also stows one OS-specific package:
  - `mac/` on macOS (`Darwin`)
  - `linux/` on Linux
- If a package directory is missing, it is skipped.

## Re-running

You can safely re-run `./bootstrap.sh` after updates to re-apply symlinks.
