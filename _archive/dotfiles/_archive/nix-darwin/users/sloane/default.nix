{ pkgs, ... }:
{
  home = {
    username = "sloane";
    homeDirectory = "/Users/sloane";
    stateVersion = "23.11";
    packages = with pkgs; [
      jq
      zoxide
      yadm
      devenv
      watchman
    ];

    sessionVariables = {
      EDITOR = "nvim";
      KERL_CONFIGURE_OPTIONS="--with-ssl=/opt/homebrew/opt/openssl@3";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
      if not set -q TMUX
        set -g TMUX tmux new-session -d -s default
        eval $TMUX
        tmux attach-session -d -t default
      end
    '';
    shellInitLast = ''
      if test -d /opt/homebrew
        /opt/homebrew/bin/brew shellenv | source
      end
      mise activate fish | source
    '';
    plugins = [
      {
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "41b46a05c84a15fe391b9d43ecb71c7a243b5703";
          hash = "sha256-zmEa/GJ9jtjzeyJUWVNSz/wYrU2FtqhcHdgxzi6ANHg=";
        };
      }
    ];
    shellAbbrs = {
      vim = "nvim";
      cat = "bat";

      # git
      g    = "git";
      ga   = "git add";
      gb   = "git branch";
      gc   = "git commit";
      gcb  = "git checkout -b";
      gco  = "git checkout";
      gd   = "git diff";
      gf   = "git fetch";
      gp   = "git push";
      gP   = "git push --force-with-lease";
      gpl  = "git pull";
      gplr = "git pull --rebase ";
      gr   = "git rebase";
      grr  = "git rebase --continue";
      gst  = "git status";
      gca  = "git commit -a";
    };
  };

  programs.git = {
    enable = true;
    userName = "sloane";
    userEmail = "1699281+sloanelybutsurely@users.noreply.github.com";
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0TH2GezEx8+zlKBqUb7rBsbmghnd1u4nX6YpQr28Zw";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      core.fsmonitor = pkgs.watchman;
      user = {
        name = "sloane";
        email = "1699281+sloanelybutsurely@users.noreply.github.com";
      };
      signing = {
        sign-all = true;
        backend = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0TH2GezEx8+zlKBqUb7rBsbmghnd1u4nX6YpQr28Zw";
        backends.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      ui.paginate = "never";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions.IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    extraConfig = ''
      # Set new panes to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      prefix-highlight
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'frappe'";
      }
    ];
  };

  programs.home-manager.enable = true;

  programs.mise = {
    enable = true;

  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Cousine Nerd Font Mono Regular";
      size = 18;
    };
    settings = {
      confirm_os_window_close = 0;
      paste_actions = "quote-urls-at-prompt,confirm-if-large";
    };
    theme = "Catppuccin-Frappe";
  };

  programs.bat.enable = true;
  programs.eza ={
    enable = true;
    git = true;
    icons = true;
    enableFishIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
  programs.fzf.enable = true;
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
  programs.ripgrep = {
    enable = true;
    arguments = [];
  };
}
