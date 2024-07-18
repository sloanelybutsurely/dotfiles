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
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end
  },
}
