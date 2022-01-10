local nvim_lsp = require('lspconfig')

if 1 == vim.fn.executable("cmake-language-server") then
   nvim_lsp.cmake.setup{}
end
