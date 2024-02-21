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
  -- clangd seems to cause offset encoding issues with other plugins
  -- We set the offset encoding here to try to fix it
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.offsetEncoding = 'utf-8'
  lspconfig.clangd.setup{
    cmd = { vim.g.clang_path .. "/bin/clangd", "--background-index" },
    capabilities = capabilities,
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

-- Setup the lua language server
if 1 == vim.fn.executable("lua-language-server") then
  lspconfig.lua_ls.setup{
    on_init = function(client)
      local path = client.workspace_folders[1].name
      if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              }
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
              -- library = vim.api.nvim_get_runtime_file("", true)
            }
          }
        })

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end
      return true
    end
  }
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
