{ config, pkgs, ... }: let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nixos/config";
in
{
  home.username = "sloane";
  home.homeDirectory = "/home/sloane";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
    fish
    ripgrep
    fd
    zoxide
    jujutsu
    qutebrowser
    discord
    difftastic
    weechat
  ];

  ## Linked config files/directories:
  # files
  xdg.configFile."fish/config.fish".source = link "${config-files}/fish/config.fish";
  xdg.configFile."jj/config.toml".source = link "${config-files}/jj/config.toml";
  xdg.configFile."foot/foot.ini".source = link "${config-files}/foot/foot.ini";

  # directories
  xdg.configFile."nvim" = {
    source = link "${config-files}/nvim";
    recursive = true;
  };
  xdg.configFile."sway" = {
    source = link "${config-files}/sway";
    recursive = true;
  };
  # xdg.configFile."weechat" = {
  #   source = link "${config-files}/weechat";
  #   recursive = true;
  # };

  # services.udiskie = {
  #   enable = true;
  #   notify = false;
  # };

  programs.firefox.enable = true;
  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host *
      IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock
    '';
  };
  programs.aerc.enable = true;
  programs.rofi.enable = true;
}
