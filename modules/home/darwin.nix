{ config, pkgs, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nix-config/config";
in
{
  home.homeDirectory = "/Users/sloane";

  programs.fish = {
    functions = {
      rebuild-system = "sudo darwin-rebuild switch --flake ~/.config/nix-config#(hostname)";
    };
  };
  programs.newsboat.browser = ''"open %u"'';

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  xdg.configFile."kitty/kitty.conf".source = link "${config-files}/kitty/kitty.conf";

  # aerc wants config in Library
  home.file."Library/Preferences/aerc" = {
    source = link "${config.home.homeDirectory}/.config/aerc";
    recursive = true;
  };
  # so does qute
  home.file."Library/Preferences/qutebrowser" = {
    source = link "${config.home.homeDirectory}/.config/qutebrowser";
    recursive = true;
  };

  services.mpd.musicDirectory = "${config.home.homeDirectory}/Music/iPod/Music";
}
