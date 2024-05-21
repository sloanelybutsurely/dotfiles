{ self, pkgs, ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    httpie
  ];

  homebrew = {
    brews = [
      "awscli"
    ];
    casks = [
      "slack"
    ];
  };
}
