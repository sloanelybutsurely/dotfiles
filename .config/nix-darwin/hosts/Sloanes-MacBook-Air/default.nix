{ pkgs, ... }:
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    rustup
    stripe-cli
  ];

  homebrew = {
    brews = [
      "flyctl"
    ];
    casks = [
      "discord"
      "postgres-unofficial"
      "postico"
      "syncthing"
      "tailscale"
      "obs"
      "superduper"
      "ableton-live-suite@11"
      "vuescan"
      "fujitsu-scansnap-home"
      "omnifocus"
    ];
  };
}
