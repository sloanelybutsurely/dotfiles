{
  nixpkgs.overlays = [
    (import ./weechat.nix)
  ];
}
