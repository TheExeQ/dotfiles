{ pkgs, ... }:
{
  environment.systemPackages = [
    # Core packages
    pkgs.git
    pkgs.neovim
    pkgs.ripgrep
    pkgs.fd
    pkgs.lazygit
    pkgs.fzf
    pkgs.nixfmt
    pkgs.statix

    # Tools
    pkgs.fish
    pkgs.fastfetch
    pkgs.python3
    pkgs.stow
    pkgs.firefox
    pkgs.proton-pass-cli
    pkgs.opencode

    # Less important packages
    pkgs.ast-grep
    pkgs.luarocks
    pkgs.nodejs_22
    pkgs.imagemagick
    pkgs.ghostscript
    pkgs.mermaid-cli
    pkgs.tectonic
  ];

  programs = {
    bash.enable = false;
    zsh.enable = false;
    fish.enable = true;
  };

  environment.shells = [ pkgs.fish ];

  users.users.samuel.shell = pkgs.fish;

  nix.settings.experimental-features = "nix-command flakes";
}
