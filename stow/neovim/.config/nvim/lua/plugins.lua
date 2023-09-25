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

  use {
      'jedrzejboczar/possession.nvim', -- Session management
      requires = { 'nvim-lua/plenary.nvim' },
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
    'goolord/alpha-nvim',
    config = function ()
      local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find Files", ":Files<CR>"),
        dashboard.button("e", " " .. " New Files", ":ene<CR>"),
        dashboard.button("o", " " .. " Recent Files", ":History<CR>"),
        dashboard.button("g", " " .. " Find Text", ":RG<CR>"),
        dashboard.button("c", " " .. " Nvim Config", ":cd ~/.config/nvim | e ~/.config/nvim/init.vim<CR>"),
        dashboard.button("z", "󰄉 " .. " Command History", ":History:<CR>"),
        dashboard.button("u", "󰄉 " .. " Update Plugins", ":PackerSync<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        -- This function is for retrieving the list of Sessions from possession
        (function()
          local group = { type = "group", opts = { spacing = 0 } }
          group.val = {
            {
              type = "text",
              val = "Sessions",
              opts = {
                position = "center"
              }
            }
          }
          local path = vim.fn.stdpath("data") .. "/possession"
          local files = vim.split(vim.fn.glob(path .. "/*.json"), "\n")
          for i, file in pairs(files) do
            local basename = vim.fs.basename(file):gsub("%.json", "")
            local button = dashboard.button(tostring(i), "勒 " .. basename, "<cmd>PossessionLoad " .. basename .. "<cr>")
            table.insert(group.val, button)
          end
          return group
        end)()
      }
      dashboard.opts.layout[1].val = 8
      require'alpha'.setup(dashboard.config)
    end
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
