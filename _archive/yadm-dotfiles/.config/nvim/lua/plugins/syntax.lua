return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function ()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'elixir',
          'javascript',
          'typescript',
          'css',
          'markdown',
          'lua',
          'html',
        },
        auto_install = false,
        highlight = {
          enable = true,
        },
      })
    end
  },
  {
    'otherjoel/vim-pollen',
    config = function ()
      vim_pollen_autogroup = vim.api.nvim_create_augroup('vim-pollen', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
        pattern = { '*.pm', '*.pp', '*.ptree', '*.p' },
        command = 'set filetype=pollen',
        group = vim_pollen_autogroup,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'pollen' },
        command = 'setlocal wrap',
        group = vim_pollen_autogroup,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'pollen' },
        command = 'setlocal linebreak',
        group = vim_pollen_autogroup,
      })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'pollen' },
        callback = function ()
          require('nvim-autopairs').disable()
        end,
        group = vim_pollen_autogroup,
      })
    end
  },
}
