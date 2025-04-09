-- Use space as leader:
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set up the clipboard to use osc52, which allows copying to the system clipboard
-- This is useful when using neovim inside a docker container or a remote server.
vim.g.clipboard = 'osc52'

-- Load filetype plugins. This has to come before any autocmds
-- that do things like change the commenstring, so we keep it near
-- the top of the file.
vim.cmd('filetype plugin on')

require('plugins')
require('lsp')
require('jmdaly.config')

-- Enable true colour support:
vim.opt.termguicolors = true

vim.cmd.colorscheme('gruvbox')

-- This is a workaround for an issue with lualine where the statusline
-- now has inverted colours in neovim nightly. See the issue here:
-- https://github.com/nvim-lualine/lualine.nvim/issues/1312#issuecomment-2439965065
vim.api.nvim_set_hl(0, "StatusLine", {reverse = false})
vim.api.nvim_set_hl(0, "StatusLineNC", {reverse = false})

-- Turn line numbers on:
vim.opt.number = true

-- Turn relative line numbers on:
vim.opt.relativenumber = true

-- Make searching case-insensitive:
vim.opt.ignorecase = true
-- When an upper case letter is in the search
-- make it case sensitive
vim.opt.smartcase = true

-- Make diffs appear in vertical splits:
vim.opt.diffopt:append('vertical')

-- Add a mapping to escape out of terminal mode:
vim.keymap.set('t', '<Leader>e', '<C-\\><C-n>')

vim.o.completeopt = "menuone,noselect"

-- Set up code folding with treesitter. We put these in an autocommand, since
-- they are not global options.
local treesittergroup = vim.api.nvim_create_augroup('treesitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'cmake', 'cuda', 'json', 'rust', 'python', 'lua', 'cmake', 'groovy' },
  group = treesittergroup,
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt_local.foldlevel = 99 -- Start with all folds open
    -- Syntax highlight the fold line
    vim.opt_local.foldtext = ''
  end,
})

local lspgroup = vim.api.nvim_create_augroup('lsp', { clear = true })
-- Use LSP omni-completion in C and C++ files.
vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'c', 'cpp' },
  group = lspgroup,
  command = 'setlocal omnifunc=v:lua.vim.lsp.omnifunc',
})
-- Set up inlay hints for the supported languages
vim.api.nvim_create_autocmd('LspAttach', {
  group = lspgroup,
  desc = 'Set up inlay hints',
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if not client then return end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true)
    end
  end,
})

vim.keymap.set('n', '<Leader>rd', vim.lsp.buf.declaration)
vim.keymap.set('n', '<Leader>rj', vim.lsp.buf.definition)
vim.keymap.set('n', '<Leader>ty', vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>rk', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<Leader>rf', '<cmd>FzfLua lsp_references<CR>')
vim.keymap.set('n', '<Leader>ds', '<cmd>FzfLua lsp_document_symbols<CR>')
vim.keymap.set('n', '<Leader>dg', '<cmd>FzfLua diagnostics_document<CR>')
vim.keymap.set('n', '<Leader>rw', vim.lsp.buf.rename)
vim.keymap.set('n', '<Leader>k', '<cmd>FzfLua lsp_code_actions<CR>')
vim.keymap.set('n', '<Leader>m', vim.diagnostic.open_float)

-- Overwrite some keymaps when in Rust files, because the Rust language server offers
-- some functionality that default language servers don't.
local lspkeymaps = vim.api.nvim_create_augroup('LspKeyMaps', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = lspkeymaps,
  pattern = 'rust',
  callback = function()
    -- Clear existing keymaps
    vim.keymap.del('n', '<Leader>ty')

    -- Set Rust-specific keymaps
    vim.keymap.set('n', '<Leader>ty', '<cmd>RustLsp hover actions<CR>')
  end
})

-- Toggle inlay hints
vim.keymap.set('n', '<Leader>ih', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

-- Various mappings to open the corresponding header/source file in a new split
vim.keymap.set('n', '<Leader>of', '<cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>oh', '<cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>oj', '<cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>ok', '<cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>ol', '<cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>')

-- DAP debug mappings
vim.keymap.set('n', '<Leader>dc', require 'dap'.continue)
vim.keymap.set('n', '<Leader>do', require 'dap'.step_over)
vim.keymap.set('n', '<Leader>di', require 'dap'.step_into)
vim.keymap.set('n', '<Leader>br', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<Leader>dr', require 'dap'.repl.open)
vim.keymap.set('n', '<Leader>dl', require 'dap'.run_last)
vim.keymap.set('n', '<Leader>dh', require 'dap.ui.widgets'.hover)

-- nvim-lint configuration
require('lint').linters_by_ft = {
  c = { 'clangtidy' },
  cpp = { 'clangtidy' },
  cmake = { 'cmakelint' },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype. ignore_errors is set to true to avoid
    -- errors when a configured linter is not available.
    require("lint").try_lint(nil, { ignore_errors = true })

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    -- require("lint").try_lint("cspell")
  end,
})

-- Mappings for formatting code
local fileformattinggroup = vim.api.nvim_create_augroup('fileformatting', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  group = fileformattinggroup,
  callback = function()
    vim.keymap.set('n', '<Leader>f', ':Black<CR>')
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust', 'cpp', 'c', 'lua' },
  group = fileformattinggroup,
  callback = function()
    vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format)
  end,
})

-- Set up keyboard shortbuts for fzf, the fuzzy finder
vim.keymap.set('n', '<Leader>z', ':FzfLua files<CR>')
vim.keymap.set('n', '<Leader><Tab>', ':FzfLua buffers<CR>')
vim.keymap.set('n', '<Leader>h', ':FzfLua command_history<CR>')
vim.keymap.set('n', '<Leader>/', ':FzfLua search_history<CR>')
vim.keymap.set('n', '<Leader>l', ':FzfLua blines<CR>')
vim.keymap.set('n', '<Leader>bc', ':FzfLua git_commits<CR>')

-- A mapping to search using rg:
vim.keymap.set('n', '<Leader>rg', ':FzfLua live_grep<CR>')
-- A mapping to search for the word under the cursor using rg:
vim.keymap.set('n', '<Leader>w', ':FzfLua grep_cword<CR>')

-- Register fzf-lua as the default picker
require('fzf-lua').register_ui_select()

-- vim-vsnip key mappings
-- Expand or jump
vim.api.nvim_set_keymap('i', '<C-j>', 'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-j>"', { expr = true })
vim.api.nvim_set_keymap('s', '<C-j>', 'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-j>"', { expr = true })

-- Jump backward
vim.api.nvim_set_keymap('i', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-n>"', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-n>"', { expr = true })

-- Ensure the status line is always displayed:
vim.opt.laststatus = 2

-- Set the comment string for certain filetypes
local ftoptionsgroup = vim.api.nvim_create_augroup('FTOptions', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'cs', 'java', 'rust' },
  group = ftoptionsgroup,
  command = 'setlocal commentstring=//\\ %s',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cmake',
  group = ftoptionsgroup,
  command = 'setlocal commentstring=#\\ %s',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'matlab',
  group = ftoptionsgroup,
  command = 'setlocal commentstring=%\\ %s',
})

-- Configure some unconventional filetypes
local filetypesgroup = vim.api.nvim_create_augroup('filetypes', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'Jenkinsfile*',
  group = filetypesgroup,
  command = 'setlocal filetype=groovy',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = 'Dockerfile*',
  group = filetypesgroup,
  command = 'setlocal filetype=dockerfile',
})

-- Set relative line numbers for copilot chat buffer
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = 'copilot-*',
    callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true
    end
})

-- Mapping to close the file in the current buffer:
vim.keymap.set('n', '<Leader>q', ':Sayonara<CR>')
vim.keymap.set('n', '<Leader>Q', ':Sayonara!<CR>')

-- mappings for fugitive:
vim.keymap.set('n', '<Leader>gs', ':Git<CR>')
vim.keymap.set('n', '<Leader>gd', ':Gdiffsplit<CR>')
vim.keymap.set('n', '<Leader>gg', ':Gdiffsplit<Space>')
vim.keymap.set('n', '<Leader>gm', ':Gdiffsplit master<CR>')
vim.keymap.set('n', '<Leader>gb', ':Git blame<CR>')

-- Set up some keybindings for CodeCompanion
vim.keymap.set({ 'n', 'v' }, '<leader>]', ':CodeCompanionChat<CR>') -- Open AI chat
vim.keymap.set({ 'n', 'v' }, '<leader>[', ':CodeCompanionChat Toggle<CR>') -- Toggle AI chat
vim.keymap.set({ 'n', 'v' }, '<leader>ca', ':CodeCompanionActions<CR>') -- Toggle AI chat
vim.keymap.set('v', 'ga', '<cmd>CodeCompanionChat Add<CR>')
