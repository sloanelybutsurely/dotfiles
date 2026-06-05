{ self, pkgs, ... }: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ ];
  environment.shells = [ pkgs.fish ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 7;


  # Enable alternative shell support in nix-darwin.
  programs.fish.enable = true;

  users.users.sloane = {
    shell = pkgs.fish;
    home = "/Users/sloane";
  };
  system.primaryUser = "sloane";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
    casks = [
      "alfred"
      "1password"
      "1password-cli"
      "firefox"
      "alacritty"
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
