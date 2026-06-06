{ config, pkgs, ... }: let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nix-config/config";
in
{
  home.username = "sloane";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    fd
    neovim
    difftastic
    htop
    wget
    zellij
    aerc
    newsboat
    jujutsu
  ];

  programs.fish = {
    enable = true;
    shellAbbrs = {
      j = "jj";
    };
  };
  programs.zoxide.enable = true;

  xdg.configFile."newsboat/config".source =
    link "${config-files}/newsboat/config";
  xdg.configFile."nvim" = {
    source = link "${config-files}/nvim";
    recursive = true;
  };
}
