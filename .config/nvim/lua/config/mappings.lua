local wk = require('which-key')
local map = vim.keymap.set

wk.setup({
  replace = {
    key = {
      { '<space>', 'SPC' },
      { '<cr>', 'RET' },
      { '<tab>', 'TAB' },
    },
  },
})

vim.opt.timeoutlen = 500
vim.g.mapleader = " "

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
map('n', '<leader>q', '<cmd>q<cr>')
map('n', '<leader>o', '<cmd>only<cr>')
map('n', '<esc>', '<cmd>nohlsearch<cr>')

wk.add({
  { '<leader><tab>', '<cmd>NERDTreeToggle<cr>', desc = 'Toggle NERDTree' },
  { '<leader><space>', '<cmd>Telescope find_files theme=dropdown<cr>', desc = 'Find file in current directory' },
  { '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Search current directory' },


  -- File
  { '<leader>fl', '<cmd>NERDTreeFind<cr>', desc = 'Show in NERDTree' },

})

-- wk.register({
--   ['<space>'] = { '<cmd>Telescope find_files theme=dropdown<cr>', 'File file in project' },
--   ['/'] = { '<cmd>Telescope live_grep<cr>', 'Search project' },
--   ['<tab>'] = { '<cmd>NERDTreeToggle<cr>', 'Toggle NERDTree' },

--   f = {
--     name = 'file',
--     e = { '<cmd>Telescope find_files cwd=~/.config/nvim<cr>', 'Find file in .config/nvim' },
--     E = { '<cmd>e ~/.config/nvim<cr>', 'Browse .config/nvim' },
--     f = { '<cmd>Telescope find_files cwd=~/ hidden=true no_ignore=true no_ignore_parent=true follow=true theme=dropdown<cr>', 'Find file' },
--     F = { '<cmd>Telescope find_files theme=dropdown<cr>', 'File file from here' },
--     l = { '<cmd>NERDTreeFind<cr>', 'Locate file' },
--     r = { '<cmd>Telescope oldfiles<cr>', 'Recent files' },
--   },

--   e = {
--     name = 'editor',
--     p = {
--       name = 'packer',
--       s = { '<cmd>PackerSync<cr>',    'Packer Sync' },
--       c = { '<cmd>PackerCompile<cr>', 'Packer Compile' },
--       l = { '<cmd>PackerClean<cr>',   'Packer Clean' },
--     }
--   },

--   g = {
--     name = 'git',
--     s = { '<cmd>Git<cr>', 'Status' },
--     p = { '<cmd>Git push -u origin head<cr>', 'Push' },
--     P = { '<cmd>Git push -u origin head --force-with-lease<cr>', 'Push (force with lease)' },
--     f = {
--       name = 'fetch',
--       o = { '<cmd>Git fetch origin<cr>', 'origin' },
--       u = { '<cmd>Git fetch upstream<cr>', 'upstream' },
--     },
--     r = {
--       name = 'rebase',
--       o = { '<cmd>Git rebase origin/main<cr>', 'origin/main' },
--       O = { '<cmd>Git rebase --interactive origin/main<cr>', '-i origin/main' },
--       u = { '<cmd>Git rebase upstream/main<cr>', 'upstream/main' },
--       U = { '<cmd>Git rebase --interactive upstream/main<cr>', '-i upstream/main' },
--     }
--   },

--   i = {
--     name = 'insert',
--     e = { '<cmd>Telescope emoji theme=dropdown<cr>', 'emoji' },
--   },

-- }, { prefix = '<leader>' })
