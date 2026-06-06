{ config, pkgs, ... }: let
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

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  xdg.configFile."alacritty/alacritty.toml".source = link "${config-files}/alacritty/alacritty.toml";

  # aerc wants config in Library
  home.file."Library/Preferences/aerc" = {
    source = link "${config.home.homeDirectory}/.config/aerc";
    recursive = true;
  };
}
