{ config, pkgs, lib, ... }:
{
  # disable things (opt-out) currently in base, should make these optional
  # modules and opt-in instead
  services.mpd.enable = lib.mkForce false;
  services.imapnotify.enable = lib.mkForce false;

  programs.newsboat.enable = lib.mkForce false;
  programs.aerc.enable = lib.mkForce false;
  programs.mbsync.enable = lib.mkForce false;
  programs.msmtp.enable = lib.mkForce false;
  programs.notmuch.enable = lib.mkForce false;

  accounts.email.accounts.personal.enable = lib.mkForce false;

  xdg.configFile."rmpc/config.ron".enable = lib.mkForce false;
  xdg.configFile."qutebrowser".enable = lib.mkForce false;
  xdg.configFile."weechat".enable = lib.mkForce false;
  xdg.configFile."mpd/mpd.conf".enable = lib.mkForce false;
  xdg.configFile."aerc/sync-folder.sh".enable = lib.mkForce false;

  home.file."media/podcasts".enable = lib.mkForce false;
  home.file."media/music".enable = lib.mkForce false;

  # additional options (opt-in)
  programs.claude-code.enable = true;

  programs.zellij = {
    enable = true;
  };
}
