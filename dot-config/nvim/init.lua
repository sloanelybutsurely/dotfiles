vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' },
  { src = 'https://github.com/catppuccin/vim', name = 'catppuccin' },

  -- TODO: consider replacing this with `mini.files`
  { src = 'https://github.com/nvim-tree/nvim-tree.lua', version = 'v1.17' },

  -- TODO: consider replacing with `mini.pick`. plenary is slated for archival
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim', version = 'v0.2.2' },
})

-- basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = 'rounded'
vim.opt.termguicolors = true

local tabsize = 2
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize
vim.opt.expandtab = true


-- lsp
vim.lsp.enable({ 'lua_ls', 'expert' })
vim.keymap.set('n', 'gD', vim.lsp.buf.definition)
vim.keymap.set('n', 'gR', vim.lsp.buf.references)

require('mini.comment').setup({})
require('mini.pairs').setup({})
require('mini.operators').setup({})
require('mini.surround').setup({
  -- match tpope/vim-surround
  mappings = { add = 'ys', delete = 'ds', replace = 'cs', }
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require('nvim-tree').setup({
  renderer = {
    icons = {
      glyphs = {
        folder = {
          arrow_open = "-",
          arrow_closed = "+",
        }
      },
      show = {
        file = false,
        folder = false,
        git = false,
        diagnostics = false,
        bookmarks = false,
        folder_arrow = true,
      },
    },
  },
})

-- keymap
vim.g.mapleader = " "

-- de-shift ":" in normal mode
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, 'q;', 'q:')

vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- move between panes witkout <c-w>
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

-- system clipboard yank and paste
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>Y', '"+Y')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>p', '"+p')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>P', '"+P')

-- quickly save and quit
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')

-- quickly open splits
vim.keymap.set('n', '<leader>"', '<cmd>split<cr>')
vim.keymap.set('n', '<leader>%', '<cmd>vsplit<cr>')

-- nvim-tree
vim.keymap.set('n', '<leader><tab>', require('nvim-tree.api').tree.toggle)
vim.keymap.set('n', '<leader>fl', function ()
  require('nvim-tree.api').tree.find_file({ open = true })
end)

-- telescope
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files)
vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep)


vim.cmd.colorscheme('catppuccin_mocha')
