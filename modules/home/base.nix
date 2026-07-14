{ config, pkgs, ... }:
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
    zellij
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
    w3m
    fzy
    gnused
    restic
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
    viAlias = true;
    vimAlias = true;
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

  #   extraConfig = ''
  #     CopyArrivalDate yes
  #     Create          Near
  #     Expunge         Both
  #
  #     IMAPAccount  personal
  #     Host         imap.fastmail.com
  #     UserCmd      "op read 'op://Private/Fastmail/username'"
  #     PassCmd      "op read 'op://Private/Fastmail/Email App Password'"
  #     TLSType      IMAPS
  #
  #     MaildirStore local
  #     Path         ~/.mail/
  #     Inbox        ~/.mail/Inbox
  #     SubFolders   Verbatim
  #
  #     IMAPStore personal
  #     Account   personal
  #
  #     Channel   personal
  #     Far       :personal:
  #     Near      :local:
  #     Patterns  *
  #   '';
  # };
  # programs.msmtp = {
  #   enable = true;
  #   configContent = ''
  #     defaults
  #     auth  on
  #     tls   on
  #
  #     # personal
  #     account         personal
  #     host            smtp.fastmail.com
  #     port            465
  #     from            sloane@sloanelybutsurely.com
  #     user            sloane@sloanelybutsurely.com
  #     passwordeval    op read "op://Private/Fastmail/Email App Password"
  #     tls_starttls    off
  #   '';
  # };

  programs.senpai = {
    enable = true;
    config = {
      address = "ircs://chat.sr.ht";
      username = "sloanelybutsurely";
      password-cmd = ["op" "read" "op://Private/SourceHut/chat.sr.ht"];
      nickname = "sloane";
    };
  };

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
  xdg.configFile."aerc/sync-folder.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      case "$AERC_FOLDER" in
        Inbox) folder="INBOX" ;;
        *)     folder="$AERC_FOLDER" ;;
      esac

      ${pkgs.isync}/bin/mbsync "$AERC_ACCOUNT:$folder"
    '';
  };

  home.file.".bin" = {
    recursive = true;
    source = link "${nix-config}/bin";
  };

  ## email
  services.imapnotify.enable = true;
  programs.aerc = {
    enable = true;
    extraConfig = {
      general.unsafe-accounts-conf = true;
      viewer = {
        alternatives = "text/plain,text/html";
        pager = "less -Rc --wordwrap";
      };
      filters = {
        ".headers" = "colorize";
        "text/plain" = "colorize";
        "text/calendar" = "calendar";
        "text/html" = "! w3m -I UTF-8 -T text/html";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "colorize";
      };
      hooks = {
        flag-changed = "${config.xdg.configHome}/aerc/sync-folder.sh &";
        mail-deleted = "${config.xdg.configHome}/aerc/sync-folder.sh &";
        mail-added = "${config.xdg.configHome}/aerc/sync-folder.sh &";
      };
    };
    extraBinds = {
      global = {
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-t>" = ":term<Enter>";
        "?" = ":help keys<Enter>";
        "<C-z>" = ":suspend<Enter>";
        "<Semicolon>" = ":";
      };
      messages = {
        q = ":quit<Enter>";

        j = ":next<Enter>";
        "<Down>" = ":next<Enter>";
        "<C-d>" = ":next 50%<Enter>";
        "<C-f>" = ":next 100%<Enter>";
        "<PgDn>" = ":next 100%<Enter>";

        k = ":prev<Enter>";
        "<Up>" = ":prev<Enter>";
        "<C-u>" = ":prev 50%<Enter>";
        "<C-b>" = ":prev 100%<Enter>";
        "<PgUp>" = ":prev 100%<Enter>";
        g = ":select 0<Enter>";
        G = ":select -1<Enter>";

        J = ":next-folder<Enter>";
        "<C-Down>" = ":next-folder<Enter>";
        K = ":prev-folder<Enter>";
        "<C-Up>" = ":prev-folder<Enter>";
        H = ":collapse-folder<Enter>";
        "<C-Left>" = ":collapse-folder<Enter>";
        L = ":expand-folder<Enter>";
        "<C-Right>" = ":expand-folder<Enter>";

        v = ":mark -t<Enter>";
        "<Space>" = ":mark -t<Enter>:next<Enter>";
        V = ":mark -v<Enter>";

        T = ":toggle-threads<Enter>";
        zc = ":fold<Enter>";
        zo = ":unfold<Enter>";
        za = ":fold -t<Enter>";
        zM = ":fold -a<Enter>";
        zR = ":unfold -a<Enter>";
        "<Tab>" = ":fold -t<Enter>";

        zz = ":align center<Enter>";
        zt = ":align top<Enter>";
        zb = ":align bottom<Enter>";

        "<Enter>" = ":view<Enter>";
        "\\#" = ":read<Enter>:move Trash<Enter>";
        e = ":archive flat<Enter>";
        E = ":unmark -a<Enter>:mark -T<Enter>:archive flat<Enter>";

        C = ":compose<Enter>";
        m = ":compose<Enter>";

        b = ":bounce<Space>";

        r = ":reply -aq<Enter>";

        c = ":cf<Space>";
        "$" = ":term<Space>";
        "!" = ":term<Space>";
        "|" = ":pipe<Space>";

        "/" = ":search<Space>";
        "\\" = ":filter<Space>";
        n = ":next-result<Enter>";
        N = ":prev-result<Enter>";
        "<Esc>" = ":clear<Enter>";

        s = ":split<Enter>";
        S = ":vsplit<Enter>";

        pl = ":patch list<Enter>";
        pa = ":patch apply <Tab>";
        pd = ":patch drop <Tab>";
        pb = ":patch rebase<Enter>";
        pt = ":patch term<Enter>";
        ps = ":patch switch <Tab>";

        R = ":check-mail<Enter>";
      };
      "messages:folder=Drafts" = {
        "<Enter>" = ":recall<Enter>";
      };
      view = {
        "/" = ":toggle-key-passthrough<Enter>/";
        q = ":close<Enter>";
        O = ":open<Enter>";
        o = ":open<Enter>";
        S = ":save<Space>";
        "|" = ":pipe<Space>";
        "\\#" = ":read<Enter>:move Trash<Enter>";
        e = ":archive flat<Enter>";

        "<C-y>" = ":copy-link<Space>";
        "<C-l>" = ":open-link<Space>";

        f = ":forward<Enter>";
        r = ":reply -aq<Enter>";

        H = ":toggle-headers<Enter>";
        "<C-k>" = ":prev-part<Enter>";
        "<C-Up>" = ":prev-part<Enter>";
        "<C-j>" = ":next-part<Enter>";
        "<C-Down>" = ":next-part<Enter>";
        J = ":next<Enter>";
        "<C-Right>" = ":next<Enter>";
        K = ":prev<Enter>";
        "<C-Left>" = ":prev<Enter>";
      };
      "view::passthrough" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<Esc>" = ":toggle-key-passthrough<Enter>";
      };
      compose = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "$complete" = "<C-o>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-Up>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-Down>" = ":next-field<Enter>";
        "<A-p>" = ":switch-account -p<Enter>";
        "<C-Left>" = ":switch-account -p<Enter>";
        "<A-n>" = ":switch-account -n<Enter>";
        "<C-Right>" = ":switch-account -n<Enter>";
        "<Tab>" = ":next-field<Enter>";
        "<Backtab>" = ":prev-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
      "compose::editor" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-k>" = ":prev-field<Enter>";
        "<C-Up>" = ":prev-field<Enter>";
        "<C-j>" = ":next-field<Enter>";
        "<C-Down>" = ":next-field<Enter>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
      "compose::review" = {
        y = ":send<Enter>";
        n = ":abort<Enter>";
        s = ":sign<Enter>";
        x = ":encrypt<Enter>";
        v = ":preview<Enter>";
        p = ":postpone<Enter>";
        q = ":choose -o d discard abort -o p postpone postpone<Enter>";
        e = ":edit<Enter>";
        a = ":attach<Space>";
        d = ":detach<Space>";
      };
      terminal = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
    };
  };
  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch.enable = true;
  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/.mail";
  };
  accounts.email.accounts.personal = {
    primary = true;
    userName = "sloane@sloanelybutsurely.com";
    # create this: `op read ... > ~/.secrets/mail`
    # this doesn't use 1password directly because `op` doesn't work (or at
    # least i can't get it to work) inside a systemd user service (imapnotify).
    passwordCommand = "${pkgs.coreutils}/bin/cat ${config.home.homeDirectory}/.secrets/mail";
    address = "sloane@sloanelybutsurely.com";
    realName = "Sloane Perrault";
    imap.host = "imap.fastmail.com";
    smtp.host = "smtp.fastmail.com";

    aerc = {
      enable = true;
      extraAccounts = {
        folders-sort = "Inbox,Drafts,Sent,Archive";
        check-mail-cmd = "mbsync -a && notmuch new";
        check-mail-timeout = "30s";
        multi-file-strategy = "act-dir";
        restrict-delete = true;
      };
    };
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
      boxes = ["Inbox"];
      onNotify = "${pkgs.isync}/bin/mbsync -a";
      onNotifyPost = "${pkgs.notmuch}/bin/notmuch new";
    };
  };
}
