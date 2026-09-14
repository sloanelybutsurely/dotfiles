{ pkgs, ... }:
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    rustup
  ];

  homebrew = {
    casks = [
      "discord"
      "postgres-unofficial"
      "postico"
      "syncthing"
      "tailscale"
    ];
  };
}
