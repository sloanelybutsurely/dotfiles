return {
  {
    'williamboman/mason.nvim',
    cmd = {
      'Mason',
      'MasonUpdate',
      'MasonInstall',
      'MasonUninstall',
      'MasonUninstallAll',
      'MasonLog'
    },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function ()
      require('mason').setup()
    end
  },
}
