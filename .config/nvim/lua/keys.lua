local wk = require('which-key')
local map = vim.keymap.set

wk.setup({
  key_labels = {
    ['<space>'] = 'SPC',
    ['<cr>'] = 'RET',
    ['<tab>'] = 'TAB'
  }
})

vim.opt.timeoutlen = 500

vim.g.mapleader = ' '

map({ 'n', 'v' }, ';', ':')
map({ 'n', 'v' }, 'q;', 'q:')

wk.register({
  ['<space>'] = { '<cmd>Telescope find_files<cr>', 'File file in project' },
  ['/'] = { '<cmd>Telescope live_grep<cr>', 'Search project' },
  ['<tab>'] = { '<cmd>NERDTreeToggle<cr>', 'Toggle NERDTree' },

  f = {
    name = 'file',
    e = { '<cmd>Telescope find_files cwd=~/.config/nvim<cr>', 'Find file in .config/nvim' },
    E = { '<cmd>e ~/.config/nvim<cr>', 'Browse .config/nvim' },
    f = { '<cmd>Telescope find_files cwd=~/ hidden=true no_ignore=true no_ignore_parent=true follow=true<cr>', 'Find file' },
    F = { '<cmd>Telescope find_files<cr>', 'File file from here' },
    l = { '<cmd>NERDTreeFind<cr>', 'Locate file' },
    r = { '<cmd>Telescope oldfiles<cr>', 'Recent files' },
  },

  q = {
    name = 'quit/session',
    b = { '<cmd>q<cr>', 'Buffer' },
    q = { '<cmd>qa<cr>', 'Neovim' },
  },

  e = {
    name = 'editor',
    p = {
      name = 'packer',
      s = { '<cmd>PackerSync<cr>',    'Packer Sync' },
      c = { '<cmd>PackerCompile<cr>', 'Packer Compile' },
      l = { '<cmd>PackerClean<cr>',   'Packer Clean' },
    }
  }
}, { prefix = '<leader>' })
