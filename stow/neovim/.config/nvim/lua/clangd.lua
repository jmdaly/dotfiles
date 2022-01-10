local nvim_lsp = require('lspconfig')

local clang_path = '/usr'

-- Set up clangd
nvim_lsp.clangd.setup{
   cmd = {
      clang_path .. "/bin/clangd",
      "--background-index"
   }
}
