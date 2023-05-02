local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd 'packadd packer.nvim'
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'tpope/vim-sensible'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-abolish'

  use {
    'tpope/vim-fugitive',
    'tpope/vim-rhubarb',
  }

  use 'christoomey/vim-sort-motion'
  use 'christoomey/vim-tmux-navigator'

  use {
    'kana/vim-textobj-user',
    'kana/vim-textobj-indent',
    'kana/vim-textobj-line',
  }

  use {
    'williamboman/mason.nvim',
    requires = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
    run = ':MasonUpdate',
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      require("mason-lspconfig").setup_handlers({
        function (server_name) -- default handler
          require("lspconfig")[server_name].setup({
            capabilities = capabilities
          })
        end,
        -- Next, you can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        -- ["rust_analyzer"] = function ()
        --   require("rust-tools").setup {}
        -- end
      })
    end
  }

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        mapping = cmp.mapping.preset.insert({}),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
        }, {
            { name = 'buffer' },
          })
      })
      
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
            { name = 'cmdline' }
          })
      })
    end
  }

  use 'sheerun/vim-polyglot'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        indent = { enable = true },
        highlight = { enable = true },
      })
    end,
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'xiyaowong/telescope-emoji.nvim' },
    },
    config = function()
      require('telescope').setup({
        defaults = { preview = false }
      })
      require('telescope').load_extension('fzf')
      require('telescope').load_extension('emoji')
    end
  }

  use { 'folke/which-key.nvim', config = function() require('keys') end }

  use 'preservim/nerdtree'

  use {
    'elixir-tools/elixir-tools.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('elixir').setup()
    end
  }

  use { 'dracula/vim', as = 'dracula' }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
