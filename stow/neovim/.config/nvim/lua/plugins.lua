-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

-- If packer is not installed, we retrieve it
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'justinmk/vim-dirvish' -- Path navigator for vim
  use 'octol/vim-cpp-enhanced-highlight' -- Better C++ Syntax Highlighting:
  use 'SirVer/ultisnips' -- Track the ultisnips engine.
  use 'honza/vim-snippets' -- Snippets are separated from the engine. Add this if you want them:
  use 'tpope/vim-sleuth' -- heuristically determine spacing to use when tabbing
  use 'tpope/vim-fugitive' -- git wrapper for vim
  use 'tpope/vim-unimpaired' -- A plugin containing handy pairs of bracket mapping:
  use 'tpope/vim-commentary' -- Plug to assist with commenting out blocks of text:
  use 'tpope/vim-surround' -- Plugin for working with surroundings of words:
  use 'tpope/vim-obsession' -- Plugin to help manage sessions
  use 'RRethy/vim-illuminate' -- Plugin to highlight the word under the cursor
  use 'mrtazz/DoxygenToolkit.vim' -- Plug to generate doxygen documentation strings:

  if vim.fn.has("unix") == 1 or vim.fn.has("wsl") == 1 then
    -- The installation script only works in Linux and similar
    use { 'junegunn/fzf', run = './install --all' } -- The fuzzy searcher
  else
    use 'junegunn/fzf' -- The fuzzy searcher
  end

  use 'junegunn/fzf.vim'
  use 'mhinz/vim-startify' -- Plugin to provide a useful start screen in vim:
  use 'mhinz/vim-sayonara' -- Plugin to make it easy to delete a buffer and close the file:
  use 'justinmk/vim-sneak' -- Motion that takes two characters and jumps to occurences

  -- Note that I set the colour scheme and my highlight info right here in
  -- an inline function. This is to get around an issue where the highlights
  -- get cleared by the colour scheme. I got this solution here:
  -- https://www.reddit.com/r/neovim/comments/m0gyip/nvim_initlua_not_respecting_highlight_commands/gqawq0h?utm_source=share&utm_medium=web2x&context=3
  -- It wasn't an issue with vim-plug, but appears to be an issue when using
  -- packer.nvim
  use {
    'arcticicestudio/nord-vim',
    config = function()
      vim.cmd [[colorscheme nord]]
      vim.g.background = 'dark'
      vim.cmd [[highlight Comment cterm=italic gui=italic]]
    end
  } -- nord colour scheme

  use 'christoomey/vim-tmux-navigator' -- A plugin to facilitate navigating between vim and tmux
  use 'wellle/targets.vim' -- A plugin for additional text objects
  use 'w0rp/ale' -- A plugin for asynchronous linting while you type

  use {
    'hoob3rt/lualine.nvim',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  if fn.executable('black') then
    -- Only load the plugin if the black executable is available, this is
    -- to prevent errors on startup
    use 'psf/black' -- A plugin to format Python code by calling black
  end

  use 'neovim/nvim-lspconfig' -- Configurations for neovim's language client
  use 'hrsh7th/nvim-compe' -- Autocompletion plugin
  use 'ojroques/nvim-lspfuzzy' -- Integrates fzf with nvim-lsp results

end)
