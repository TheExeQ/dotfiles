{ pkgs, ... }:
{
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

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "Nlsv";
        ShowPathbar = true;
      };

      controlcenter = {
        BatteryShowPercentage = true;
      };

      NSGlobalDomain.AppleIconAppearanceTheme = "ClearDark";
    };

    configurationRevision = null;
    stateVersion = 6;
  };

  environment.systemPackages = [
    pkgs.utm
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
}
