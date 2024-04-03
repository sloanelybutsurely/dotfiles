{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    vim-abolish
    vim-dispatch
    vim-repeat
    vim-sensible

    vim-rhubarb
    vim-sort-motion
    vim-textobj-user

    nerdtree
  ];

  plugins = {
    surround.enable = true;
    commentary.enable = true;

    fugitive.enable = true;

    tmux-navigator.enable = true;

    lsp = {
      enable = true;
      servers = {
        elixirls.enable = true;
        tsserver.enable = true;
        nil_ls.enable = true;
      };
    };

    telescope = {
      enable = true;
      defaults = { preview = false; };
      extensions.fzf-native.enable = true;
    };

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
      cmdline = {
        ":" = {
          mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
          sources = [
            { name = "path"; }
            { name = "cmdline"; }
          ];
        };
      };
    };

    treesitter = {
      enable = true;
      indent = true;
    };
  };
}
