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
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

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
    dependencies = { 'saghen/blink.cmp' },
  },

  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',
    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = {
        preset = 'default',
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          snippets = {
            opts = {
              search_paths = { vim.fn.stdpath("config") .. "/snippets", vim.env.HOME .. '/dotfiles/snippets' },
            },
          },
        },
      },
    },
    -- allows extending the providers array elsewhere in your config
    -- without having to redefine it
    opts_extend = {
      "sources.default"
    },
  },

  -- Improved Rust development
  {
    'mrcjkb/rustaceanvim',
    version = '^5', -- Recommended
    lazy = false, -- This plugin is already lazy
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
