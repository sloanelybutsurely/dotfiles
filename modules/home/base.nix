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
    ffmpeg
    htop
    rmpc
    tree
    cyanrip
    customWeechat
    mpv
    notmuch
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man!";
  };

  services.mpd = {
    enable = true;
    extraConfig = ''
      auto_update "yes"
    '';
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
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig = {
      settings = {
        experimental = true;
      };
    };
  };
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

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
      player "mpv --no-audio-display"
    '';
  };

  programs.mbsync = {
    enable = true;
    extraConfig = ''
      CopyArrivalDate yes
      Create          Near
      Expunge         Both

      IMAPAccount  personal
      Host         imap.fastmail.com
      UserCmd      "op read 'op://Private/Fastmail/username'"
      PassCmd      "op read 'op://Private/Fastmail/Email App Password'"
      TLSType      IMAPS

      MaildirStore local
      Path         ~/.mail/
      Inbox        ~/.mail/Inbox
      SubFolders   Verbatim

      IMAPStore personal
      Account   personal

      Channel   personal
      Far       :personal:
      Near      :local:
      Patterns  *
    '';
  };
  programs.msmtp = {
    enable = true;
    configContent = ''
      defaults
      auth  on
      tls   on

      # personal
      account         personal
      host            smtp.fastmail.com
      port            465
      from            sloane@sloanelybutsurely.com
      user            sloane@sloanelybutsurely.com
      passwordeval    op read "op://Private/Fastmail/Email App Password"
      tls_starttls    off
    '';
  };

  xdg.configFile."jj/config.toml".source = link "${config-files}/jj/config.toml";
  xdg.configFile."rmpc/config.ron".source = link "${config-files}/rmpc/config.ron";
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
  xdg.configFile."weechat" = {
    source = link "${config-files}/weechat";
    recursive = true;
  };
  xdg.configFile."mpd/mpd.conf".text = config.services.mpd.generatedConfig;
}
