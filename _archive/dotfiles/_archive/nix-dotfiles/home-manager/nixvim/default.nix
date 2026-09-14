{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      projectionist_heuristics = {
        "mix.exs" = {
          "lib/*.ex" = {
            type = "source";
            alternate = "test/{}_test.exs";
          };
          "test/*_test.exs" = {
            type = "test";
            alternate = "lib/{}.ex";
            dispatch  = "mix test {file}";
          };
        };
      };
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      expandtab = true;
      tabstop = 2;
    };

    colorschemes.catppuccin.enable = true;

    keymaps = [
      {
        key = ";";
        action = ":";
        mode = [ "n" "v" ];
      }
      {
        key = "q;";
        action = "q:";
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>y";
        action = ''"+y'';
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>Y";
        action = ''"+Y'';
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>p";
        action = ''"+p'';
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>P";
        action = ''"+P'';
        mode = [ "n" "v" ];
      }
      {
        key = "<leader>w";
        action = "<cmd>w<cr>";
        mode = [ "n" ];
      }
      {
        key = "<leader>q";
        action = "<cmd>q<cr>";
        mode = [ "n" ];
      }
      {
        key = "<esc>";
        action = "<cmd>nohlsearch<cr>";
        mode = [ "n" ];
      }
      {
        key = ''<leader>"'';
        action = "<cmd>split<cr>";
        mode = [ "n" ];
      }
      {
        key = "<leader>%";
        action = "<cmd>vsplit<cr>";
        mode = [ "n" ];
      }
      {
        key = "<leader><tab>";
        action = "<cmd>NvimTreeToggle<cr>";
        mode = [ "n" ];
      }
      {
        key = "<leader>fl";
        action = "<cmd>NvimTreeFindFile<cr>";
        mode = [ "n" ];
      }
      {
        key = "<leader><space>";
        action = "<cmd>Telescope find_files theme=dropdown<cr>";
        mode = [ "n" ];
      }
      {
        key = "<leader>/";
        action = "<cmd>Telescope live_grep<cr>";
        mode = [ "n" ];
      }
      {
        key = "<C-h>";
        action = "<cmd>ZellijNavigateLeft<cr>";
        mode = [ "n" ];
      }
      {
        key = "<C-j>";
        action = "<cmd>ZellijNavigateDown<cr>";
        mode = [ "n" ];
      }
      {
        key = "<C-k>";
        action = "<cmd>ZellijNavigateUp<cr>";
        mode = [ "n" ];
      }
      {
        key = "<C-l>";
        action = "<cmd>ZellijNavigateRight<cr>";
        mode = [ "n" ];
      }
    ];

    autoGroups = { format_on_save = { clear = true; }; };

    autoCmd = [{
      event = "BufWritePre";
      group = "format_on_save";
      pattern = "*";
      command = "lua vim.lsp.buf.format()";
    }];

    extraPlugins = with pkgs.vimPlugins; [
      vim-abolish
      vim-rhubarb
      vim-dispatch
      vim-dispatch-neovim
      vim-projectionist
      splitjoin-vim
    ];

    plugins.commentary.enable = true;
    plugins.repeat.enable = true;
    plugins.fugitive.enable = true;

    plugins.nvim-autopairs.enable = true;
    plugins.nvim-surround.enable = true;

    plugins.web-devicons.enable = true;

    plugins.treesitter = {
      enable = true;
      settings.indent.enable = true;
      settings.highlight.enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        json
        lua
        markdown
        nix
        toml
        vim
        yaml
        elixir
        heex
        javascript
        typescript
        css
        html
        terraform
      ];
    };

    plugins.lsp = {
      enable = true;
      servers = {
        elixirls = {
          enable = true;
          settings = {
            dialyzerEnabled = false;
          };
        };
        fish_lsp.enable = true;
        html.enable = true;
        nixd.enable = true;
        tailwindcss.enable = true;
        terraform_lsp.enable = true;
        ts_ls.enable = true;
      };
      keymaps.lspBuf = {
        grn = "rename";
        grr = "references";
        gri = "implementation";
        grd = "definition";
      };
    };

    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require('luasnip')
              if cmp.visible() then
                cmp.confirm({ select = true })
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, {'i', 's'})
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              local luasnip = require('luasnip')
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, {'i', 's'})
          '';
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };
    };

    plugins.zellij-nav.enable = true;

    plugins.neotest = {
      enable = true;
      adapters.elixir.enable = true;
    };

    plugins.which-key = {
      enable = true;
    };

    plugins.nvim-tree = {
      enable = true;
      settings.disable_netrw = true;
      openOnSetup = false;
    };

    plugins.copilot-lua.enable = false;
    plugins.copilot-cmp.enable = false;
    plugins.codecompanion = {
      enable = false;
      settings = {
        strategies = {
          agent.adapter = "copilot";
          chat.adapter = "copilot";
          inline.adapter = "copilot";
        };
      };
    };
  };
}
