vim.opt.number = true
vim.opt.relativenumber = true

local tabsize = 2
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize
vim.opt.expandtab = true


vim.g.mapleader = " "

-- de-shift ":" in normal mode
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', 'q;', 'q:')

vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

-- move between panes witkout <c-w>
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

-- quickly save and quit
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>')

-- quickly open splits
vim.keymap.set('n', '<leader>"', '<cmd>split<cr>')
vim.keymap.set('n', '<leader>%', '<cmd>vsplit<cr>')

vim.pack.add({
  { src = 'https://github.com/nvim-mini/mini.nvim', version = 'stable' }
})

-- lsp
vim.lsp.enable({ 'lua_ls' })
