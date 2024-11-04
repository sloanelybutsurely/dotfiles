return {
  { 'tpope/vim-sensible' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-dispatch' },
  { 'tpope/vim-abolish' },

  { 'christoomey/vim-sort-motion' },
  { 'kana/vim-textobj-user' },

  {
    "https://git.sr.ht/~swaits/zellij-nav.nvim",
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

  {
    'folke/which-key.nvim',
    lazy = true,
    dependencies = {
      'echasnovski/mini.icons',
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
}
