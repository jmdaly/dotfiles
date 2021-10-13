-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

-- If packer is not installed, we retrieve it
if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
  execute 'packadd packer.nvim'
end
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'justinmk/vim-dirvish' -- Path navigator for vim
  use 'octol/vim-cpp-enhanced-highlight' -- Better C++ Syntax Highlighting:
  use 'tpope/vim-sleuth' -- heuristically determine spacing to use when tabbing
  use 'tpope/vim-fugitive' -- git wrapper for vim
  use 'tpope/vim-unimpaired' -- A plugin containing handy pairs of bracket mapping:
  use 'tpope/vim-commentary' -- Plug to assist with commenting out blocks of text:
  use 'tpope/vim-surround' -- Plugin for working with surroundings of words:
  use 'tpope/vim-obsession' -- Plugin to help manage sessions
  use 'RRethy/vim-illuminate' -- Plugin to highlight the word under the cursor
  use 'mrtazz/DoxygenToolkit.vim' -- Plug to generate doxygen documentation strings:

  use {
    'hrsh7th/vim-vsnip',
    requires = 'rafamadriz/friendly-snippets'
  }

  if fn.has("unix") == 1 or fn.has("wsl") == 1 then
    -- The installation script only works in Linux and similar
    use { 'junegunn/fzf', run = './install --all' } -- The fuzzy searcher
  else
    use 'junegunn/fzf' -- The fuzzy searcher
  end

  use 'junegunn/fzf.vim'
  use 'mhinz/vim-startify' -- Plugin to provide a useful start screen in vim:
  use 'mhinz/vim-sayonara' -- Plugin to make it easy to delete a buffer and close the file:
  use 'ggandor/lightspeed.nvim' -- Motion that takes two characters and jumps to occurences

  use 'marko-cerovac/material.nvim'

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
  use 'ojroques/nvim-lspfuzzy' -- Integrates fzf with nvim-lsp results

  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-vsnip'

  use 'mfussenegger/nvim-dap' -- Debug Adapter Protocol plugin

end)
