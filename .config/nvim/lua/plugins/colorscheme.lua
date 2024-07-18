return {
  {
    'foxoman/vim-helix',
    lazy = false,
    priority = 1000,
    config = function ()
      vim.cmd([[colorscheme helix-boo]])
    end,
  },
}
