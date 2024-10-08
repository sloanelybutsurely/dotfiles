return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
    },
    config = function ()
      local lsp_zero = require('lsp-zero')

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      local function lsp_format_on_save(bufnr)
        vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function ()
            vim.lsp.buf.format()
          end
        })
      end

      local lsp_attach = function (client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = false })
        lsp_format_on_save(bufnr)
      end

      lsp_zero.extend_lspconfig({
        lsp_attach = lsp_attach,
      })

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          function (server_name)
            if server_name == 'tsserver' then
              server_name = 'ts_ls'
            end
            require('lspconfig')[server_name].setup({})
          end,
        },
      })

      local cmp = require('cmp')
      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
        },
        mapping = {
          ['<C-y>'] = cmp.mapping.confirm({select = false}),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
          ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
          ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item({behavior = 'insert'})
            else
              cmp.complete()
            end
          end),
          ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item({behavior = 'insert'})
            else
              cmp.complete()
            end
          end),
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
      })
    end
  },
}
