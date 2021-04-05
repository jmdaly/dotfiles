-- Set up the built-in language client

-- Tell neovim where to find clangd
vim.g.clang_path = "/opt/llvm"

if vim.fn.has("win32") == 1 then
  vim.g.clang_path = "C:/Program Files/LLVM"
end

local lspconfig = require'lspconfig'
-- We check if a language server is available before setting it up.
-- Otherwise, we'll get errors when loading files.

-- Set up clangd
if 1 == vim.fn.executable(vim.g.clang_path .. "/bin/clangd") then
  lspconfig.clangd.setup{
    cmd = { vim.g.clang_path .. "/bin/clangd", "--background-index" }
  }
end

if 1 == vim.fn.executable("cmake-language-server") then
  lspconfig.cmake.setup{}
end

if 1 == vim.fn.executable("pyls") then
  lspconfig.pyls.setup{}
end

-- Configure the way code diagnostics are displayed
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

--- Enable the lspfuzzy plugin
require('lspfuzzy').setup {}
