-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Start by ensuring that lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim
require("lazy").setup({
  'justinmk/vim-dirvish', -- Path navigator for vim
  'tpope/vim-sleuth', -- heuristically determine spacing to use when tabbing
  'tpope/vim-fugitive', -- git wrapper for vim
  'tpope/vim-unimpaired', -- A plugin containing handy pairs of bracket mapping:
  'tpope/vim-commentary', -- Plug to assist with commenting out blocks of text:
  'tpope/vim-surround', -- Plugin for working with surroundings of words:
  'RRethy/vim-illuminate', -- Plugin to highlight the word under the cursor
  'mrtazz/DoxygenToolkit.vim', -- Plug to generate doxygen documentation strings:

  { "junegunn/fzf", build = "./install --all" }, -- The fuzzy searcher
  { 'junegunn/fzf.vim', dependencies = 'junegunn/fzf'},

  'mhinz/vim-sayonara', -- Plugin to make it easy to delete a buffer and close the file:

  -- Motion that takes two characters and jumps to occurences
  { 'ggandor/leap.nvim', dependencies = 'tpope/vim-repeat' },

  -- Session management
  { 'jedrzejboczar/possession.nvim', dependencies = 'nvim-lua/plenary.nvim' },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  'christoomey/vim-tmux-navigator', -- A plugin to facilitate navigating between vim and tmux
  'wellle/targets.vim', -- A plugin for additional text objects
  'w0rp/ale', -- A plugin for asynchronous linting while you type

  'marko-cerovac/material.nvim',
  'sainnhe/gruvbox-material',

  { 'ellisonleao/gruvbox.nvim',
     opts = {
       contrast = 'soft',
     },
  },

  'psf/black', -- A plugin to format Python code by calling black

  {
    'neovim/nvim-lspconfig', -- Configurations for neovim's language client
  },

  'ojroques/nvim-lspfuzzy', -- Integrates fzf with nvim-lsp results

  {
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    -- load cmp on InsertEnter
    event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-vsnip",
    },
  },

  -- Snippets plugin
  { "hrsh7th/vim-vsnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },

  'simrat39/rust-tools.nvim', -- Improved rust development
  'mfussenegger/nvim-dap', -- Debug Adapter Protocol plugin
  'github/copilot.vim',

  { 'hoob3rt/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
        dashboard.button("e", " " .. " New File", ":ene<CR>"),
        dashboard.button("f", " " .. " Find Files", ":Files<CR>"),
        dashboard.button("r", " " .. " Recent Files", ":History<CR>"),
        dashboard.button("g", " " .. " Find Text", ":RG<CR>"),
        dashboard.button("c", " " .. " Nvim Config", ":cd ~/.config/nvim | e ~/.config/nvim/init.vim<CR>"),
        dashboard.button("z", "󰄉 " .. " Command History", ":History:<CR>"),
        dashboard.button("u", "󰄉 " .. " Update Plugins", ":Lazy<CR>"),
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
  },

  -- Plugin to integrate with ollama models
  {
      "David-Kunz/gen.nvim",
      opts = {
          model = "llama2", -- The default model to use.
          host = "localhost",
          port = "11434",
          display_mode = "split", -- The display mode. Can be "float" or "split".
          show_prompt = true, -- Shows the Prompt submitted to Ollama.
          show_model = true, -- Displays which model you are using at the beginning of your chat session.
      }
  },

})
