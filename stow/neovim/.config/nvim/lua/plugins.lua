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

  if fn.has("unix") == 1 or fn.has("wsl") == 1 then
    -- The installation script only works in Linux and similar
    use { 'junegunn/fzf', run = './install --all' } -- The fuzzy searcher
  else
    use 'junegunn/fzf' -- The fuzzy searcher
  end

  use 'junegunn/fzf.vim'
  use 'mhinz/vim-sayonara' -- Plugin to make it easy to delete a buffer and close the file:

  use {
    'ggandor/leap.nvim', -- Motion that takes two characters and jumps to occurences
    requires = 'tpope/vim-repeat'
  }

  use 'marko-cerovac/material.nvim'
  use 'sainnhe/gruvbox-material'

  use 'christoomey/vim-tmux-navigator' -- A plugin to facilitate navigating between vim and tmux
  use 'wellle/targets.vim' -- A plugin for additional text objects
  use 'w0rp/ale' -- A plugin for asynchronous linting while you type

  use {
    'hoob3rt/lualine.nvim',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  use {
    'glepnir/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
      theme = 'doom',
      config = {
        header = {
          '                                   ',
          '                                   ',
          '                                   ',
          '                                   ',
          '                                   ',
          '                                   ',
          '   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ',
          '    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
          '          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ',
          '           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
          '          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
          '   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
          '  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
          ' ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
          ' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ',
          '      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
          '       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
          '                                   ',
          '                                   ',
          '                                   ',
          '                                   ',
          '                                   ',
          '                                   ',
        },
        center = {
          {
            icon = '󰈞 ',
            icon_hl = 'Title',
            desc = 'Find file',
            desc_hl = 'String',
            key = 'f',
            key_hl = 'Number',
            action = ':Files',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'New file',
            desc_hl = 'String',
            key = 'e',
            key_hl = 'Number',
            action = ':ene',
          },
          {
            icon = '󰄉 ',
            icon_hl = 'Title',
            desc = 'Recently used files                        ',
            desc_hl = 'String',
            key = 'r',
            key_hl = 'Number',
            action = ':History',
          },
          {
            icon = '󰄉 ',
            icon_hl = 'Title',
            desc = 'Command history                        ',
            desc_hl = 'String',
            key = 'h',
            key_hl = 'Number',
            action = ':History:',
          },
          {
            icon = '󰊄 ',
            icon_hl = 'Title',
            desc = 'Find text',
            desc_hl = 'String',
            key = 'w',
            key_hl = 'Number',
            action = ':RG',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Configuration',
            desc_hl = 'String',
            key = 'c',
            key_hl = 'Number',
            action = ':cd ~/.config/nvim | e ~/.config/nvim/init.vim',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Update plugins',
            desc_hl = 'String',
            key = 'u',
            key_hl = 'Number',
            action = ':lua require("lazy").update()',
          },
          {
            icon = '󰦛 ',
            icon_hl = 'Title',
            desc = 'Restore last session',
            desc_hl = 'String',
            key = 'l',
            key_hl = 'Number',
            action = ':lua require("persistence").load({ last = true })',
          },
          {
            icon = ' ',
            icon_hl = 'Title',
            desc = 'Quit Neovim',
            desc_hl = 'String',
            key = 'q',
            key_hl = 'Number',
            action = ':qa',
          },
        }
      }
    }
    end,
    requires = {'nvim-tree/nvim-web-devicons'}
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

  -- The order that the completion support plugins are loaded is important
  -- in order to get friendly-snippets working. The following code comes from
  -- this github issue: https://github.com/hrsh7th/vim-vsnip/issues/219#issuecomment-940031501
  use {
    'hrsh7th/cmp-vsnip',
    after = 'nvim-cmp',
    requires = {
      'hrsh7th/vim-vsnip',
      {
        'rafamadriz/friendly-snippets',
        after = 'cmp-vsnip'
      }
    }
  }

  use 'simrat39/rust-tools.nvim' -- Improved rust development

  use 'mfussenegger/nvim-dap' -- Debug Adapter Protocol plugin

  use 'github/copilot.vim'

end)
