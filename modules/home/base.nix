{ config, pkgs, ... }:
let
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
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
  };
  programs.zoxide.enable = true;
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      refresh-on-startup yes

      # miniflux
      urls-source "miniflux"
      miniflux-url "https://miniflux.sloanelybutsurely.com"
      miniflux-login "sloane"
      miniflux-passwordeval "op read op://Private/miniflux/password"

      # podcasts
      # podcast-auto-enqueue yes
      download-path "~/media/podcasts/%n"
      download-filename-format "%F - %t.%e"
      delete-played-files yes
      max-downloads 6
      podlist-format "%4i %-70b [%6p %%] %S"
    '';
  };

  xdg.configFile."jj/config.toml".source = link "${config-files}/jj/config.toml";
  xdg.configFile."nvim" = {
    source = link "${config-files}/nvim";
    recursive = true;
  };
  xdg.configFile."aerc" = {
    source = link "${config-files}/aerc";
    recursive = true;
  };
  xdg.configFile."qutebrowser" = {
    source = link "${config-files}/qutebrowser";
    recursive = true;
  };
}
