{ config, pkgs, ... }: {
  programs.waybar.settings.mainBar = {
    modules-right = [ "mpd" "cpu" "memory" "battery#bat0" "battery#bat1" "clock" "tray" ];

    "battery#bat0"."bat" = "BAT0";
    "battery#bat1"."bat" = "BAT1";
  };
}
