{ self, pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    casks = [
      "slack"
    ];
  };
}
