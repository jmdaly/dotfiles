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

-- Common settings and keymaps that work in both environments
require('jmdaly.common')

-- Check if running inside VSCode
if vim.g.vscode then
    -- VSCode-specific configuration
    require('jmdaly.vscode')
else
    -- Standalone Neovim setup
    
    -- Load plugins
    require('plugins')
    
    -- Load LSP configuration
    require('lsp')
    
    -- Load Neovim-specific configuration
    require('jmdaly.config')
    
    -- Load standalone-specific settings and keymaps
    require('jmdaly.standalone')
    
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
end