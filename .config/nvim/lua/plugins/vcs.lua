return {
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  {
    'julienvincent/hunk.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = { 'DiffEditor' },
    config = function ()
      require('hunk').setup()
    end,
  },
}
