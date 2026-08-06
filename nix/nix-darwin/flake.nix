{
  description = "First nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
      [
      pkgs.git
      pkgs.python3
      pkgs.stow
      pkgs.neovim
      pkgs.firefox
      pkgs.proton-pass-cli
      pkgs.fastfetch
      pkgs.starship
      pkgs.fish
      pkgs.opencode
      pkgs.tmux
      pkgs.utm
      ];

      homebrew = {
      enable = true;

      brews = [
      # Empty for now
      ];

      casks = [
      "ghostty"
      ];

      onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      };
      };

      system.primaryUser = "samuel";

      users.users.samuel.shell = pkgs.fish;

      environment.shells = [ pkgs.fish ];

      system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      };

      system.defaults = 
      { 
        dock.autohide = true;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MBP
    darwinConfigurations."MBP" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
