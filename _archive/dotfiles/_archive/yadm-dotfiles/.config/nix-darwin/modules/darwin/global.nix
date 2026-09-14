{ self, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    fish
    git
    curl
    tmux
  ];

  environment.shells = [ pkgs.fish ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nix.settings = {
    # Necessary for using flakes on this system.
    experimental-features = "nix-command flakes";
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["root" "sloane"];
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  system.defaults = {
    dock = {
      orientation = "bottom";
      autohide = true;
      autohide-delay = 0.1;
      show-recents = false;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    brews = [
      "openssl"
      "wxwidgets"
    ];
    taps = [
      "homebrew/cask-fonts"
    ];
    casks = [
      "1password"
      "alfred"
      "appcleaner"
      "dash@6"
      "fantastical"
      "firefox"
      "karabiner-elements"
      "keepingyouawake"
      "kitty"
      "obsidian"
      "unnaturalscrollwheels"
      "syncthing"
      "rectangle"

      "font-cousine-nerd-font"
      "font-victor-mono-nerd-font"
      "font-recursive-mono-nerd-font"
    ];
    masApps = {
      "Things 3" = 904280696;
      "Hand Mirror" = 1502839586;
    };
  };

}
