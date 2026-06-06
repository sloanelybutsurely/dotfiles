{ config, pkgs, ... }: let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nix-config/config";
in
{
  home.homeDirectory = "/home/sloane";
  home.packages = with pkgs; [
    qutebrowser
    discord
  ];

  programs.fish = {
    functions = {
      rebuild-system = "sudo nixos-rebuild switch --flake ~/.config/nix-config#(hostname)";
    };
  };

  xdg.configFile."sway" = {
    source = link "${config-files}/sway";
    recursive = true;
  };
  xdg.configFile."foot/foot.ini".source = link "${config-files}/foot/foot.ini";

  programs.ssh = {
    enable = true;
    extraConfig = ''
    Host *
      IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock
    '';
  };
  programs.firefox.enable = true;
  programs.rofi.enable = true;
}
