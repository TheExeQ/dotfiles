{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

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
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.uv
    pkgs.stow
    pkgs.proton-pass-cli
    pkgs.opencode
    pkgs.claude-code
    pkgs.ansible
    pkgs.opentofu
    pkgs.podman
    pkgs.podman-compose
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.minikube

    # Less important packages
    pkgs.ast-grep
    pkgs.luarocks
    pkgs.imagemagick
    pkgs.ghostscript
    pkgs.mermaid-cli
    pkgs.tectonic
  ];

  programs = {
    bash.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };

  environment.shells = [ pkgs.fish ];

  nix.settings.experimental-features = "nix-command flakes";
}
