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

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
      j = "jj";
    };
  };
  programs.zoxide.enable = true;

  xdg.configFile."jj/config.toml".source = link "${config-files}/jj/config.toml";
  xdg.configFile."newsboat/config".source = link "${config-files}/newsboat/config";
  xdg.configFile."nvim" = {
    source = link "${config-files}/nvim";
    recursive = true;
  };
  xdg.configFile."aerc" = {
    source = link "${config-files}/aerc";
    recursive = true;
  };
}
