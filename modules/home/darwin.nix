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
  programs.git.ignores = [ ".DS_Store" ];

  xdg.configFile."kitty" = {
    source = link "${config-files}/kitty";
    recursive = true;
  };

  services.mpd.musicDirectory = "${config.home.homeDirectory}/Music/iPod/Music";

  home.file."media/podcasts" = {
    enable = true;
    source = link /Volumes/Media/Podcasts;
    recursive = true;
  };
  home.file."media/music" = {
    enable = true;
    source = link /Volumes/Media/Music/Music;
    recursive = true;
  };
}
