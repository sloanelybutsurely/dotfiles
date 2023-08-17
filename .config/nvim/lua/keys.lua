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
map('n', '<leader>q', '<cmd>q<cr>')
map('n', '<leader>o', '<cmd>only<cr>')
map('n', '<esc>', '<cmd>nohlsearch<cr>')

wk.register({
  ['<space>'] = { '<cmd>Telescope find_files theme=dropdown<cr>', 'File file in project' },
  ['/'] = { '<cmd>Telescope live_grep<cr>', 'Search project' },
  ['<tab>'] = { '<cmd>NERDTreeToggle<cr>', 'Toggle NERDTree' },

  f = {
    name = 'file',
    e = { '<cmd>Telescope find_files cwd=~/.config/nvim<cr>', 'Find file in .config/nvim' },
    E = { '<cmd>e ~/.config/nvim<cr>', 'Browse .config/nvim' },
    f = { '<cmd>Telescope find_files cwd=~/ hidden=true no_ignore=true no_ignore_parent=true follow=true theme=dropdown<cr>', 'Find file' },
    F = { '<cmd>Telescope find_files theme=dropdown<cr>', 'File file from here' },
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
    p = { '<cmd>Git push -u origin head<cr>', 'Push' },
    P = { '<cmd>Git push -u origin head --force-with-lease<cr>', 'Push (force with lease)' },
    f = {
      name = 'fetch',
      o = { '<cmd>Git fetch origin<cr>', 'origin' },
      u = { '<cmd>Git fetch upstream<cr>', 'upstream' },
    },
    r = {
      name = 'rebase',
      o = { '<cmd>Git rebase origin/main<cr>', 'origin/main' },
      O = { '<cmd>Git rebase --interactive origin/main<cr>', '-i origin/main' },
      u = { '<cmd>Git rebase upstream/main<cr>', 'upstream/main' },
      U = { '<cmd>Git rebase --interactive upstream/main<cr>', '-i upstream/main' },
    }
  },

  i = {
    name = 'insert',
    e = { '<cmd>Telescope emoji theme=dropdown<cr>', 'emoji' },
  },

}, { prefix = '<leader>' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<space>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})
