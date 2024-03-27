-- Use space as leader:
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Load filetype plugins. This has to come before any autocmds
-- that do things like change the commenstring, so we keep it near
-- the top of the file.
vim.cmd('filetype plugin on')

require('plugins')
require('completion')
require('lsp')
require('jmdaly.config')

-- Enable true colour support:
vim.opt.termguicolors = true

vim.cmd.colorscheme('gruvbox-material')

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

local lspgroup = vim.api.nvim_create_augroup('lsp', { clear = true })
-- Use LSP omni-completion in C and C++ files.
vim.api.nvim_create_autocmd('Filetype', {
  pattern = { 'c', 'cpp' },
  group = lspgroup,
  command = 'setlocal omnifunc=v:lua.vim.lsp.omnifunc',
})

vim.keymap.set('n', '<Leader>rd', vim.lsp.buf.declaration)
vim.keymap.set('n', '<Leader>rj', vim.lsp.buf.definition)
vim.keymap.set('n', '<Leader>ty', vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>rk', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<Leader>rf', vim.lsp.buf.references)
vim.keymap.set('n', '<Leader>ds', vim.lsp.buf.document_symbol)
vim.keymap.set('n', '<Leader>rw', vim.lsp.buf.rename)
vim.keymap.set('n', '<Leader>k', vim.lsp.buf.code_action)
vim.keymap.set('n', '<Leader>m', vim.diagnostic.open_float)

-- Various mappings to open the corresponding header/source file in a new split
vim.keymap.set('n', '<Leader>of', '<cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>oh', '<cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>oj', '<cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>ok', '<cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<Leader>ol', '<cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>')

vim.keymap.set('n', '[z', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']z', vim.diagnostic.goto_next)

-- DAP debug mappings
vim.keymap.set('n', '<Leader>dc', require 'dap'.continue)
vim.keymap.set('n', '<Leader>do', require 'dap'.step_over)
vim.keymap.set('n', '<Leader>di', require 'dap'.step_into)
vim.keymap.set('n', '<Leader>br', require 'dap'.toggle_breakpoint)
vim.keymap.set('n', '<Leader>dr', require 'dap'.repl.open)
vim.keymap.set('n', '<Leader>dl', require 'dap'.run_last)
vim.keymap.set('n', '<Leader>dh', require 'dap.ui.widgets'.hover)

-- ALE configuration
vim.g.ale_linters = {
  cpp = { 'clangtidy' },
  c = { 'clangtidy', 'pclint' },
  python = { 'pyls', 'flake8' },
  rust = { 'cargo', 'analyzer' },
}

vim.g.ale_cpp_clangtidy_executable = vim.g.clang_path .. '/bin/clang-tidy'
vim.g.ale_cpp_clangtidy_extra_options = '-header-filter=.*'

vim.g.ale_c_clangtidy_executable = vim.g.clang_path .. '/bin/clang-tidy'
vim.g.ale_c_clangtidy_extra_options = '-header-filter=.*'

-- Set up mapping to move between errors
vim.keymap.set('n', '[w', '<Plug>(ale_previous_wrap)')
vim.keymap.set('n', ']w', '<Plug>(ale_next_wrap)')

-- Key mappings for clang-format, to format source code.
vim.g.clang_format_path = vim.g.clang_path .. '/bin/clang-format'

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
vim.keymap.set('n', '<Leader>z', ':Files<CR>')
vim.keymap.set('n', '<Leader><Tab>', ':Buffers<CR>')
vim.keymap.set('n', '<Leader>h', ':History:<CR>')
vim.keymap.set('n', '<Leader>/', ':History/<CR>')
vim.keymap.set('n', '<Leader>l', ':BLines<CR>')
vim.keymap.set('n', '<Leader>bc', ':BCommits<CR>')

-- A mapping to search using rg:
vim.keymap.set('n', '<Leader>rg', ':Rg<space>')

-- Set the fzf popup layout
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

-- vim-vsnip key mappings
-- Expand or jump
vim.api.nvim_set_keymap('i', '<C-j>', 'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-j>"', { expr = true })
vim.api.nvim_set_keymap('s', '<C-j>', 'vsnip#available(1) ? "<Plug>(vsnip-expand-or-jump)" : "<C-j>"', { expr = true })

-- Jump backward
vim.api.nvim_set_keymap('i', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-n>"', { expr = true })
vim.api.nvim_set_keymap('s', '<S-Tab>', 'vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-n>"', { expr = true })

-- Ensure the status line is always displayed:
vim.opt.laststatus = 2

-- Set the comment string for certain filetypes to
-- double slashes (used for vim-commentary):
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

-- Mapping to close the file in the current buffer:
vim.keymap.set('n', '<Leader>q', ':Sayonara<CR>')
vim.keymap.set('n', '<Leader>Q', ':Sayonara!<CR>')

-- mappings for fugitive:
vim.keymap.set('n', '<Leader>gs', ':Git<CR>')
vim.keymap.set('n', '<Leader>gd', ':Gdiffsplit<CR>')
vim.keymap.set('n', '<Leader>gg', ':Gdiffsplit<Space>')
vim.keymap.set('n', '<Leader>gm', ':Gdiffsplit master<CR>')
vim.keymap.set('n', '<Leader>gb', ':Git blame<CR>')
