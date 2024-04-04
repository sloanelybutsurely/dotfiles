{ pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    options = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-abolish
      vim-dispatch
      vim-repeat
      vim-sensible

      vim-rhubarb
      vim-sort-motion
      vim-textobj-user

      nerdtree

      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-jjdescription";
        src = pkgs.fetchFromGitHub {
          owner = "avm99963";
          repo = "vim-jjdescription";
          rev = "c9bf9f849ead3961ae38ab33f68306996e64c6e8";
          hash = "sha256-qnZFuXbzpm2GN/+CfksFfW2O+qTosUZcUagqCTzmtWo=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-helix";
        src = pkgs.fetchFromGitHub {
          owner = "foxoman";
          repo = "vim-helix";
          rev = "db32bbdf5cf0b639bdd7ef87c23ac2473a482627";
          hash = "sha256-rBHgZsBSf4iHI2X6W8PydmIqlv4Ok8nT+Tgj5Dxi73M=";
        };
      })
    ];

    colorscheme = "helix-boo";

    plugins = {
      surround.enable = true;
      commentary.enable = true;

      fugitive.enable = true;

      tmux-navigator.enable = true;

      nvim-autopairs = {
        enable = true;
      };

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
        settings = {
          mapping.__raw = "cmp.mapping.preset.insert({})";
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
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

      # rust
      rustaceanvim = {
        enable = true;
      };
    };

    plugins.which-key = {
      enable = true;
      keyLabels = {
        "<space>" = "SPC";
        "<cr>" = "RET";
        "<tab>" = "TAB";
      };
      registrations = {
        "<leader>g" = "Git";
        "<leader>f" = "Files";
      };
    };

    globals.mapleader = " ";

    keymaps = [
      { key = ";"; action = ":"; }
      { key = "q;"; action = "q:"; }

      { key = "<leader>y"; action = ''"+y''; }
      { key = "<leader>Y"; action = ''"+Y''; }
      { key = "<leader>p"; action = ''"+p''; }
      { key = "<leader>P"; action = ''"+P''; }

      { key = "<leader>w"; action = "<cmd>w<cr>"; }
      { key = "<leader>q"; action = "<cmd>q<cr>"; }
      { key = "<esc>"; action = "<cmd>nohlsearch<cr>"; mode = "n"; }

      # root level leader commands
      {
        key = "<leader><space>";
        action = "<cmd>Telescope find_files<cr>"; 
        options = { desc = "Find files in project"; };
      }
      {
        key = "<leader>/";
        action = "<cmd>Telescope live_grep<cr>"; 
        options = { desc = "Search project"; };
      }
      {
        key = "<leader><tab>";
        action = "<cmd>NERDTreeToggle<cr>"; 
        options = { desc = "Toggle NERDTree"; };
      }

      # file commands
      {
        key = "<leader>fl";
        action = "<cmd>NERDTreeFind<cr>";
        options = { desc = "Locate file"; };
      }

      # git
      {
        key = "<leader>gs";
        action = "<cmd>Git<cr>"; 
        options = { desc = "Status"; };
      }
      {
        key = "<leader>gp";
        action = "<cmd>Git push<cr>"; 
        options = { desc = "Push"; };
      }
      {
        key = "<leader>gP";
        action = "<cmd>Git push --force-with-lease<cr>"; 
        options = { desc = "Push (force with lease)"; };
      }
      {
        key = "<leader>gf";
        action = "<cmd>Git fetch<cr>"; 
        options = { desc = "Fetch"; };
      }
      # git rebase
      {
        key = "<leader>gro";
        action = "<cmd>Git rebase origin/main<cr>"; 
        options = { desc = "origin/main"; };
      }
      {
        
        key = "<leader>grO";
        action = "<cmd>Git rebase --interactive origin/main<cr>"; 
        options = { desc = "-i origin/main"; };
      }
      {
        
        key = "<leader>grm";
        action = "<cmd>Git rebase origin/master<cr>"; 
        options = { desc = "origin/master"; };
      }
      {
        key = "<leader>grM";
        action = "<cmd>Git rebase --interactive origin/master<cr>"; 
        options = { desc = "-i origin/master"; };
      }
    ];

    # TODO: move this into Nix
    extraConfigLuaPost = ''
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end,
    })
    '';
  };
}

