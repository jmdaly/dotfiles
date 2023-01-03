local nvim_lsp = require('lspconfig')

-- https://github.com/bash-lsp/bash-language-server

if 1 == vim.fn.executable("bash-language-server") then
  nvim_lsp.bashls.setup{
    on_attach = on_attach,
  }
end
