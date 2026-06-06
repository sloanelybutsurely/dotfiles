{ config, pkgs, ... }: let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nix-config/config";
in
{
  programs.fish = {
    functions = {
      rebuild-system = "sudo darwin-rebuild switch --flake ~/.config/nix-config#(hostname)";
    };
  };

  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  xdg.configFile."alacritty/alacritty.toml".source = link "${config-files}/alacritty/alacritty.toml";
}
