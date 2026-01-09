-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key
vim.g.mapleader = " "

-- Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Keybindings
local k = vim.keymap.set
k({ "n", "v" }, ";", ":")
k({ "n", "v" }, "q;", "q:")
k({ "n", "v" }, "<leader>y", '"+y')
k({ "n", "v" }, "<leader>Y", '"+Y')
k({ "n", "v" }, "<leader>p", '"+p')
k({ "n", "v" }, "<leader>P", '"+P')
k("n", "<leader>w", "<cmd>w<cr>")
k("n", "<leader>q", "<cmd>q<cr>")
k("n", "<esc>", "<cmd>nohlsearch<cr>")
k("n", '<leader>"', "<cmd>split<cr>")
k("n", "<leader>%", "<cmd>vsplit<cr>")
k("n", "<C-h>", "<C-w>h")
k("n", "<C-j>", "<C-w>j")
k("n", "<C-k>", "<C-w>k")
k("n", "<C-l>", "<C-w>l")

-- Plugins
require("lazy").setup({
  { "catppuccin/nvim", version = "^v1.11.0", name = "catppuccin", priority = 1000 },
  { "tpope/vim-abolish", version = "^v1.2" },
  { "tpope/vim-commentary", version = "^v1.3" },
  { "tpope/vim-repeat", version = "^v1.2" },

  {
    "windwp/nvim-autopairs",
    commit = "c2a0dd0",
    event = "InsertEnter",
    config = true,
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end
  },

  {
    "nvim-telescope/telescope.nvim",
    version = "^v0.2.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>" },
      { "<leader>/", "<cmd>Telescope live_grep<cr>" },
    },
  },
  
  {
    "nvim-tree/nvim-tree.lua",
    version = "^1.14.0",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
    keys = {
      { "<leader><tab>", "<cmd>NvimTreeToggle<cr>" },
      { "<leader>fl", "<cmd>NvimTreeFindFile<cr>" },
    },
  },
  
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  {
    "swaits/zellij-nav.nvim",
    lazy = true,
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeftTab<cr>",  { silent = true, desc = "navigate left or tab"  } },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>",  { silent = true, desc = "navigate down"  } },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>",    { silent = true, desc = "navigate up"    } },
      { "<c-l>", "<cmd>ZellijNavigateRightTab<cr>", { silent = true, desc = "navigate right or tab" } },
    },
    opts = {},
  },
})

vim.cmd.colorscheme "catppuccin"
