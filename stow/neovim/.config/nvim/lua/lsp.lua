-- Set up the built-in language client

-- Tell neovim where to find clangd
vim.g.clang_path = "/usr"

if vim.fn.has("win32") == 1 then
  vim.g.clang_path = "C:/Program Files/LLVM"
  vim.g.python3_host_prog = "python"
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

-- Setup cmake language server
if 1 == vim.fn.executable("cmake-language-server") then
  lspconfig.cmake.setup{}
end

-- Setup Python language server
if 1 == vim.fn.executable("pylsp") then
  lspconfig.pylsp.setup{}
end

-- Setup Rust language server
if 1 == vim.fn.executable("rust-analyzer") then
  local opts = {
      tools = { -- rust-tools options
          autoSetHints = true,
          inlay_hints = {
              show_parameter_hints = false,
              parameter_hints_prefix = "",
              other_hints_prefix = "",
          },
      },

      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
      server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          -- on_attach = on_attach,
          settings = {
              -- to enable rust-analyzer settings visit:
              -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
              ["rust-analyzer"] = {
                  -- enable clippy on save
                  checkOnSave = {
                      command = "clippy"
                  },
              }
          }
      },
  }
  require('rust-tools').setup(opts)
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
