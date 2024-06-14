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
  'tpope/vim-surround', -- Plugin for working with surroundings of words:
  'RRethy/vim-illuminate', -- Plugin to highlight the word under the cursor
  'mrtazz/DoxygenToolkit.vim', -- Plug to generate doxygen documentation strings:

  { "junegunn/fzf", build = "./install --all" }, -- The fuzzy searcher

  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "junegunn/fzf",
    },
    opts = {
      defaults = { formatter = "path.filename_first" }
    },
  },

  'mhinz/vim-sayonara', -- Plugin to make it easy to delete a buffer and close the file:

  -- Motion that takes two characters and jumps to occurences
  { 'ggandor/leap.nvim', dependencies = 'tpope/vim-repeat' },

  -- Session management
  { 'jedrzejboczar/possession.nvim', dependencies = 'nvim-lua/plenary.nvim' },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  'christoomey/vim-tmux-navigator', -- A plugin to facilitate navigating between vim and tmux
  'wellle/targets.vim', -- A plugin for additional text objects

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

  -- Improved Rust development
  {
    'mrcjkb/rustaceanvim',
    version = '^4', -- Recommended
    lazy = false, -- This plugin is already lazy
    opts = {
      server = {
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
            },
            -- Add clippy lints for Rust
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = {
                "--no-deps",
                "--",
                "-Wclippy::pedantic",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts)
    end,
  },

  'mfussenegger/nvim-dap', -- Debug Adapter Protocol plugin
  'mfussenegger/nvim-lint', -- Linting plugin for neovim
  'github/copilot.vim',

  { 'hoob3rt/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },

  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
        dashboard.button("e", " " .. " New File", ":ene<CR>"),
        dashboard.button("f", " " .. " Find Files", ":FzfLua files<CR>"),
        dashboard.button("r", " " .. " Recent Files", ":FzfLua oldfiles<CR>"),
        dashboard.button("g", " " .. " Find Text", ":FzfLua live_grep<CR>"),
        dashboard.button("c", " " .. " Nvim Config", ":cd ~/.config/nvim | e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("z", "󰄉 " .. " Command History", ":FzfLua command_history<CR>"),
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

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      -- See Configuration section for rest
      context = 'buffers', -- Use all buffers as context
      mappings = {
        -- Use tab for completion
        complete = {
          detail = "Use @<C-n> or /<C-n> for options.",
          insert = "<C-n>",
        },
        -- Close the chat
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        -- Reset the chat buffer
        reset = {
          normal = "gb",
          insert = "<A-l>",
        },
      },
    },
    keys = {
      -- Show help actions with fzf-lua
      {
        "<leader>cc", mode = { "n", "v" },
        "<cmd>CopilotChatToggle<CR>",
     },
      {
        "<leader>ch", mode = { "n", "v" },
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.help_actions())
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with fzf-lua
      {
        "<leader>cp", mode = { "n", "v" },
        function()
          local actions = require("CopilotChat.actions")
          require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
        end,
        desc = "CopilotChat - Prompt actions",
      },
    },
  },

})
