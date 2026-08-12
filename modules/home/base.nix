{ config, pkgs, lib, ... }:
let
  link = config.lib.file.mkOutOfStoreSymlink;
  nix-config = "${config.home.homeDirectory}/.config/nix-config";
  config-files = "${nix-config}/config";
in
{
  home.username = "sloane";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    ripgrep
    fd
    difftastic
    htop
    wget
    jujutsu
    ffmpeg
    htop
    rmpc
    tree
    cyanrip
    customWeechat
    mpv
    pv
    file
    unzip
    fzy
    gnused
    restic
    lf
    _1password-cli
    nq
  ];

  home.sessionVariables = {
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
    shellInit = ''
      set --global --prepend fish_function_path ~/.bin/functions
    '';
    interactiveShellInit = ''
      fish_vi_key_bindings
    '';
    functions = {
      oil = {
        wraps = "nvim";
        body = "command nvim +Oil $argv";
      };
      note = ''
        set -l dest ~/notes
        set -l buf $(mktemp note.XXXXX)
        set -l prefix $(printf %x $(date +%s))

        command nvim $buf

        set -l safe_title $(
          head -n 1 $buf | \
            sed -E -e 's/\W+/-/g' -e 's/^\W+//g' -e 's/\W+$//g' | \
            tr '[:upper:]' '[:lower:]'
        )
        set -l out "$prefix"_"$safe_title".md
        mv $buf $dest/$out
        echo "Saved note to $dest/$out"
      '';
    };
  };
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    viAlias = false;
    vimAlias = false;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter-parsers.elixir
    ];
    extraPackages = with pkgs; [
      typescript-language-server
      lua-language-server
      elixir-ls
      gopls
    ];
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

      # binds
      bind k everywhere up
      bind j everywhere down
      bind ^U everywhere halfpageup
      bind ^D everywhere halfpagedown
    '';
  };

  programs.senpai = {
    enable = true;
    config = {
      address = "ircs://chat.sr.ht";
      username = "sloanelybutsurely";
      password-cmd = ["op" "read" "op://Private/SourceHut/chat.sr.ht"];
      nickname = "sloane";
    };
  };

  programs.gpg.enable = true;

  xdg = {
    enable = true;
    configHome = "${config.home.homeDirectory}/.config";
  };
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  xdg.configFile."jj/config.toml".source = link "${config-files}/jj/config.toml";
  xdg.configFile."rmpc/config.ron".source = link "${config-files}/rmpc/config.ron";
  xdg.configFile."nvim" = {
    source = link "${config-files}/nvim";
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
  xdg.configFile."aerc/binds.conf".source = link "${config-files}/aerc/binds.conf";
  xdg.configFile."aerc/sync-folder.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      case "$AERC_FOLDER" in
        Inbox) folder="INBOX" ;;
        *)     folder="$AERC_FOLDER" ;;
      esac

      ${pkgs.isync}/bin/mbsync "$AERC_ACCOUNT:$folder" && ${pkgs.notmuch}/bin/notmuch new
    '';
  };

  home.file.".bin" = {
    recursive = true;
    source = link "${nix-config}/bin";
  };

  home.activation.secrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p ${config.home.homeDirectory}/.secrets
    if  [ ! -f ${config.home.homeDirectory}/.secrets/personal ]; then
      run ${pkgs._1password-cli}/bin/op read "op://Private/Fastmail/home-manager" > ${config.home.homeDirectory}/.secrets/personal
      run chmod 0600 ${config.home.homeDirectory}/.secrets/personal
    fi
  '';

  ## email
  services.imapnotify.enable = true;
  programs.aerc = {
    enable = true;
    extraConfig = let
      iniFormat = pkgs.formats.iniWithGlobalSection {};
      nqSyncFolder = "NQDIR=${config.xdg.stateHome}/aerc ${pkgs.nq}/bin/nq -c ${config.xdg.configHome}/aerc/sync-folder.sh";
      cfgText = iniFormat.generate "aerc.conf" {
        sections = {
          general.unsafe-accounts-conf = true;
          hooks = {
            flag-changed = nqSyncFolder;
            mail-added   = nqSyncFolder;
            mail-deleted = nqSyncFolder;
          };
        };
      };
      in
      ''
      ${builtins.readFile cfgText}

      [filters]
      text/plain=wrap -w 80 | colorize
      text/calendar=calendar
      message/delivery-status=colorize
      message/rfc822=colorize
      text/html=html | colorize
      .headers=colorize
      '';
  };
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;
  accounts.email = {
    maildirBasePath = "${config.xdg.dataHome}/mail";
  };
  accounts.email.accounts.personal = {
    primary = true;
    userName = "sloane@sloanelybutsurely.com";
    passwordCommand = "${pkgs.coreutils}/bin/cat ${config.home.homeDirectory}/.secrets/personal";
    address = "sloane@sloanelybutsurely.com";
    realName = "Sloane Perrault";
    imap.host = "imap.fastmail.com";
    smtp.host = "smtp.fastmail.com";

    mbsync = {
      enable = true;
      create = "maildir";
      expunge = "both";
      remove = "maildir";
    };
    msmtp.enable = true;
    notmuch.enable = true;
    imapnotify = {
      enable = true;
      boxes = ["INBOX"];
      onNotify = "${pkgs.isync}/bin/mbsync personal:INBOX";
      onNotifyPost = "${pkgs.notmuch}/bin/notmuch new";
    };
    aerc = {
      enable = true;
      extraAccounts = {
        folders-sort = "Inbox,Archive,Drafts,Sent,Trash,Junk";
        restrict-delete = true;
        check-mail-cmd = "mbsync -a && notmuch new";
        check-mail-timeout = "30s";
      };
    };
  };
}
