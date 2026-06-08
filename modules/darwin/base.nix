{ self, pkgs, ... }: {
  environment.systemPackages = [ ];
  environment.shells = [ pkgs.fish ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 7;

  programs.fish.enable = true;

  users.users.sloane = {
    home = "/Users/sloane";
  };
  system.primaryUser = "sloane";

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  homebrew = {
    enable = true;
    enableFishIntegration = true;
    casks = [
      "alfred"
      "1password"
      "1password-cli"
      "firefox"
      "kitty"
      "dash"
      "cleanshot"
      "discord"
      "fantastical"
      "karabiner-elements"
      "keepingyouawake"
      "obsidian"
      "postgres-app"
      "postico"
      "unnaturalscrollwheels"
    ];
  };
}
