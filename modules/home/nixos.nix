{ config, pkgs, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  config-files = "${config.home.homeDirectory}/.config/nix-config/config";
in
{
  home.homeDirectory = "/home/sloane";
  home.packages = with pkgs; [
    qutebrowser
    discord
    qemu
  ];

  programs.fish = {
    functions = {
      rebuild-system = "sudo nixos-rebuild switch --flake ~/.config/nix-config#(hostname)";
    };
  };
  # programs.waybar = {
  #   enable = true;
  #   settings = {
  #     mainBar = {
  #       layer = "top";
  #       position = "top";
  #       height = 30;
  #       modules-left =  [ "sway/workspaces" "sway/mode" ];
  #       modules-center = [ ];
  #
  #       "clock".format = "{:%a %b %e, %y %I:%M %p}";
  #       "cpu".format = "CPU {usage}%";
  #       "memory".format = "MEM {percentage}%";
  #     };
  #   };
  #   style = ''
  #     * {
  #       font-family: MonoLisaText;
  #     }
  #   '';
  # };
  programs.newsboat.browser = ''"exec qutebrowser %u > /dev/null 2>&1 &"'';

  xdg.configFile."sway" = {
    source = link "${config-files}/sway";
    recursive = true;
  };
  xdg.configFile."foot/foot.ini".source = link "${config-files}/foot/foot.ini";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "Host *" = {
        IdentityAgent = "${config.home.homeDirectory}/.1password.agent.sock";
      };
    };
  };
  programs.firefox.enable = true;
  programs.rofi.enable = true;

  services.mako.enable = true;
  services.mpd = {
    musicDirectory = "${config.home.homeDirectory}/media/music";
    network.startWhenNeeded = true;
  };
  services.udiskie.enable = true;
}
