vim.o.completeopt = "menuone,noselect"

  -- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  },
  sources = {
    -- For vsnip user.
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }
})

-- Setup lspconfig.
require('lspconfig').clangd.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}
require('lspconfig').pylsp.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}
require('lspconfig').cmake.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}
