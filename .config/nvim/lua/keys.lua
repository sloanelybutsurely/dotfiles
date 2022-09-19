local wk = require('which-key')
local map = vim.keymap.set

vim.cmd([[
  augroup keys_user_config
    autocmd!
    autocmd BufWritePost keys.lua source <afile>
  augroup end
]])

wk.setup({
  key_labels = {
    ['<space>'] = 'SPC',
    ['<cr>'] = 'RET',
    ['<tab>'] = 'TAB'
  }
})

vim.opt.timeoutlen = 500

vim.g.mapleader = ' '

-- Handy to remap semi-colon to colon
map({ 'n', 'v' }, ';', ':')
map({ 'n', 'v' }, 'q;', 'q:')

-- System clipboard via <leader> -> y | p
map({ 'n', 'v' }, '<leader>y', '"+y')
map(  'n',        'Y',         '"+Y')
map({ 'n', 'v' }, '<leader>p', '"+p')
map({ 'n', 'v' }, '<leader>P', '"+P')

-- Common short-hands
map('n', '<leader>w', '<cmd>w<cr>')
map('n', '<leader>q', '<cmd>wq<cr>')
map('n', '<leader>o', '<cmd>only<cr>')

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

  e = {
    name = 'editor',
    p = {
      name = 'packer',
      s = { '<cmd>PackerSync<cr>',    'Packer Sync' },
      c = { '<cmd>PackerCompile<cr>', 'Packer Compile' },
      l = { '<cmd>PackerClean<cr>',   'Packer Clean' },
    }
  },

  g = {
    name = 'git',
    s = { '<cmd>Git<cr>', 'Status' },
    f = { '<cmd>Git fetch<cr>', 'Fetch' },
    p = { '<cmd>Git push --force-with-lease -u origin head<cr>', 'Push' },
    r = { 
      name = 'rebase',
      m = { '<cmd>Git rebase origin/main<cr>', 'origin/main' },
      M = { '<cmd>Git rebase --interactive origin/main<cr>', 'Interactive origin/main' }
    }
  },

}, { prefix = '<leader>' })
