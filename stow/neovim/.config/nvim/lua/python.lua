local nvim_lsp = require('lspconfig')

-- pip install 'python-lsp-server[all]'
if 1 == vim.fn.executable("pyls") then
  nvim_lsp.pylsp.setup{
    on_attach = on_attach,
  }
end
