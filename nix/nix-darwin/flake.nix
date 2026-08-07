{
  description = "First nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
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
          pkgs.utm

          # Less important packages
          pkgs.ast-grep
          pkgs.luarocks
          pkgs.nodejs_22
          pkgs.imagemagick
          pkgs.ghostscript
          pkgs.mermaid-cli
          pkgs.tectonic
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

        users.users.samuel.shell = pkgs.fish;

        environment.shells = [ pkgs.fish ];

        system = {
          primaryUser = "samuel";

          keyboard = {
            enableKeyMapping = true;
            remapCapsLockToEscape = true;
          };

          defaults = {
            dock = {
              autohide = true;
              minimize-to-application = true;
              persistent-apps = [ ];
            };

            controlcenter = {
              BatteryShowPercentage = true;
            };

            NSGlobalDomain.AppleIconAppearanceTheme = "ClearDark";
          };

          # Set Git commit hash for darwin-version.
          configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          stateVersion = 6;
        };

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        programs = {
          bash.enable = false;
          zsh.enable = false;
          fish.enable = false;
        };

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
