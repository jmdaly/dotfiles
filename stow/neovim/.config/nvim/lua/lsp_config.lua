-- https://www.getman.io/posts/programming-go-in-neovim/
--
local nvim_lsp = require('lspconfig')

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    spell = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    ultisnips = true;
  };
}

-- Configure the way code diagnostics are displayed
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics, {
      -- This will disable virtual text, like doing:
      -- let g:diagnostic_enable_virtual_text = 0
      virtual_text = false,

      -- This is similar to:
      -- let g:diagnostic_show_sign = 1
      -- To configure sign display,
      --  see: ":help vim.diagnostic.set_signs()"
      signs = true,

      -- This is similar to:
      -- "let g:diagnostic_insert_delay = 1"
      update_in_insert = false,
   }
)


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', '<leader>rD',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',  opts)
  buf_set_keymap('n', '<leader>rd',  '<cmd>lua vim.lsp.buf.declaration()<CR>',      opts)
  buf_set_keymap('n', '<leader>rj',  '<cmd>lua vim.lsp.buf.definition()<CR>',       opts)
  buf_set_keymap('n', '<leader>ty',  '<cmd>lua vim.lsp.buf.hover()<CR>',            opts)
  buf_set_keymap('n', '<leader>rk',  '<cmd>lua vim.lsp.buf.signature_help()<CR>',   opts)
  buf_set_keymap('n', '<leader>rf',  '<cmd>lua vim.lsp.buf.references()<CR>',       opts)
  buf_set_keymap('n', '<leader>ds',  '<cmd>lua vim.lsp.buf.document_symbol()<CR>',  opts)
  buf_set_keymap('n', '<leader>rw',  '<cmd>lua vim.lsp.buf.rename()<CR>',           opts)
  buf_set_keymap('n', '<leader>c',   '<cmd>lua vim.lsp.buf.code_action()<CR>',      opts)
  buf_set_keymap('n', '<leader>el',   '<cmd>lua print(vim.lsp.get_log_path())<CR>',  opts)
  buf_set_keymap('n', '<leader>m',    '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

  -- Various mappings to open the corresponding header/source file in a new split
  buf_set_keymap('n', '<leader>of', '<cmd>ClangdSwitchSourceHeader<CR>', opts)
  buf_set_keymap('n', '<leader>oh', '<cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>', opts)
  buf_set_keymap('n', '<leader>oj', '<cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>', opts)
  buf_set_keymap('n', '<leader>ok', '<cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>', opts)
  buf_set_keymap('n', '<leader>ol', '<cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>', opts)

  buf_set_keymap('n', '[z', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']z', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

  -- New key mappings that came with go setup (but are general)

  buf_set_keymap('n',  '<space>e',   '<cmd>lua vim.diagnostic.open_float()<CR>',  opts)
  buf_set_keymap('n',  '[d',         '<cmd>lua vim.diagnostic.goto_prev()<CR>',              opts)
  buf_set_keymap('n',  ']d',         '<cmd>lua vim.diagnostic.goto_next()<CR>',              opts)
  buf_set_keymap('n',  '<space>q',   '<cmd>lua vim.diagnostic.set_loclist()<CR>',            opts)
  buf_set_keymap('n',  '<space>wa',  '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',          opts)
  buf_set_keymap('n',  'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',                opts)
  buf_set_keymap('n',  '<space>wr',  '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',       opts)

  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.server_capabilities.document_range_formatting then
    -- Doesn't work with go
    buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- vim.lsp.set_log_level("debug")

-- Import our local defs
require('clangd')
require('go')
require('cmake')
require('python')
-- require('kotlin')
require('bashls')

require('lspfuzzy').setup {}
