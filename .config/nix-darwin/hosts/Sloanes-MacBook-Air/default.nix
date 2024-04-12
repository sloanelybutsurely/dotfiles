{ pkgs, ... }:
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    rustup
  ];

  homebrew = {
    brews = [
      "flyctl"
    ];
    taps = [
      "homebrew/cask-versions"
    ];
    casks = [
      "discord"
      "postgres-unofficial"
      "postico"
      "syncthing"
      "tailscale"
      "obs"
      "superduper"
      "ableton-live-suite11"
    ];
  };
}
