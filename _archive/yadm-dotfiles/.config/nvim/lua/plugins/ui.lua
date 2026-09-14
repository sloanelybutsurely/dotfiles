return {
  {
    'preservim/nerdtree',
    cmd = {
      'NERDTree',
      'NERDTreeToggle',
      'NERDTreeFind',
      'NERDTreeFocus'
    }
  },

  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = { 'Telescope' },
  },
}
