{
  description = "Samuel's nix system flake";

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
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#MBP
      darwinConfigurations."MBP" = nix-darwin.lib.darwinSystem {
        modules = [
          ./common.nix
          ./darwin.nix
        ];
      };
    };
}
