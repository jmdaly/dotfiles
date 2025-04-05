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

-- Define all plugins
local plugins = {
  -- Core plugins that work in both vscode and standalone neovim
  'tpope/vim-fugitive', -- git wrapper for vim
  'tpope/vim-unimpaired', -- A plugin containing handy pairs of bracket mapping
  'tpope/vim-surround', -- Plugin for working with surroundings of words

  -- Plugins that should only be loaded in standalone Neovim
  {
    'justinmk/vim-dirvish', -- Path navigator for vim
    cond = not vim.g.vscode
  },
  {
    'tpope/vim-sleuth', -- heuristically determine spacing to use when tabbing
    cond = not vim.g.vscode
  },
  {
    'RRethy/vim-illuminate', -- Plugin to highlight the word under the cursor
    cond = not vim.g.vscode
  },
  {
    'mrtazz/DoxygenToolkit.vim', -- Plug to generate doxygen documentation strings
    cond = not vim.g.vscode
  },
  {
    "junegunn/fzf",
    build = "./install --all", -- The fuzzy searcher
    cond = not vim.g.vscode
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "junegunn/fzf",
    },
    opts = {
      defaults = { formatter = "path.filename_first" }
    },
    cond = not vim.g.vscode
  },
  {
    'mhinz/vim-sayonara', -- Plugin to make it easy to delete a buffer and close the file
    cond = not vim.g.vscode
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
    cond = not vim.g.vscode
  },
  {
    'jedrzejboczar/possession.nvim', -- Session management 
    dependencies = 'nvim-lua/plenary.nvim',
    cond = not vim.g.vscode
  },
  {
    "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate",
    cond = not vim.g.vscode
  },
  {
    'christoomey/vim-tmux-navigator', -- A plugin to facilitate navigating between vim and tmux
    cond = not vim.g.vscode
  },
  {
    'wellle/targets.vim', -- A plugin for additional text objects
    cond = not vim.g.vscode
  },
  {
    'marko-cerovac/material.nvim',
    cond = not vim.g.vscode
  },
  {
    'sainnhe/gruvbox-material',
    cond = not vim.g.vscode
  },
  {
    'ellisonleao/gruvbox.nvim',
    opts = {
      contrast = 'soft',
    },
    cond = not vim.g.vscode
  },
  {
    'psf/black', -- A plugin to format Python code by calling black
    cond = not vim.g.vscode
  },
  {
    'neovim/nvim-lspconfig', -- Configurations for neovim's language client
    dependencies = { 'saghen/blink.cmp' },
    cond = not vim.g.vscode
  },
  {
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',
    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- see the "default configuration" section below for full documentation on how to define
      -- your own keymap.
      keymap = {
        preset = 'enter',
      },
      cmdline = {
        keymap = {
          ['<Tab>'] = { 'show', 'select_next' },
          ['<S-Tab>'] = { 'select_prev' },
          ['<CR>'] = { 'accept', 'fallback' },
        },
      },

      completion = {
        -- Don't automatically show completion in cmdline or search
        menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end },
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion' },
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
    cond = not vim.g.vscode
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
    opts = {
      server = {
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts)
    end,
    cond = not vim.g.vscode
  },
  {
    'mfussenegger/nvim-dap', -- Debug Adapter Protocol plugin
    cond = not vim.g.vscode
  },
  {
    'mfussenegger/nvim-lint', -- Linting plugin for neovim
    cond = not vim.g.vscode
  },
  {
    'github/copilot.vim',
    cond = not vim.g.vscode -- VSCode has its own Copilot
  },
  {
    'hoob3rt/lualine.nvim', 
    dependencies = 'nvim-tree/nvim-web-devicons',
    cond = not vim.g.vscode
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local dashboard = require("alpha.themes.dashboard")
        dashboard.section.buttons.val = {
        dashboard.button("e", " " .. " New File", ":ene<CR>"),
        dashboard.button("f", " " .. " Find Files", ":FzfLua files<CR>"),
        dashboard.button("r", " " .. " Recent Files", ":FzfLua oldfiles<CR>"),
        dashboard.button("g", " " .. " Find Text", ":FzfLua live_grep<CR>"),
        dashboard.button("c", " " .. " Nvim Config", ":cd ~/.config/nvim | e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("z", "󰄉 " .. " Command History", ":FzfLua command_history<CR>"),
        dashboard.button("u", "󰄉 " .. " Update Plugins", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
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
            local button = dashboard.button(tostring(i), "勒 " .. basename, "<cmd>PossessionLoad " .. basename .. "<cr>")
            table.insert(group.val, button)
          end
          return group
        end)()
      }
      dashboard.opts.layout[1].val = 8
      require'alpha'.setup(dashboard.config)
    end,
    cond = not vim.g.vscode
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub",  -- lazy load by default
    build = "npm install -g mcp-hub@latest",  -- Installs required mcp-hub npm module
    opts = {
      extensions = {
        codecompanion = {
          -- Show the mcp tool result in the chat buffer
          show_result_in_chat = true,
          -- Make chat #variables from MCP server resources
          make_vars = true,
          -- Make /slash commands from MCP server prompts
          make_slash_commands = true,
        }
      }
    },
    cond = not vim.g.vscode
  },
  {
    "Davidyz/VectorCode",
    version = "0.5.5", -- optional, depending on whether you're on nightly or release
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
    cond = not vim.g.vscode
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    opts = {
      display = {
        chat = {
          show_settings = false,
        },
      },
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.7-sonnet-thought",
              },
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:14b",
              },
            },
            env = {
              url = "http://localhost:11434",
            },
            headers = {
              ["Content-Type"] = "application/json",
            },
            parameters = {
              sync = true,
            },
          })
        end,
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "https://openrouter.ai/api",
              api_key = "cmd: echo $OPENROUTER_API_KEY",
              chat_url = "/v1/chat/completions",
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "cmd: echo $GEMINI_API_KEY",
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot",
          slash_commands = {
            ["symbols"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
            ["file"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
            ["buffer"] = {
              opts = {
                provider = "fzf_lua",
              },
            },
          },
          tools = {
            ["mcp"] = {
              -- Prevent mcphub from loading before needed
              callback = function() 
                  return require("mcphub.extensions.codecompanion") 
              end,
              description = "Call tools and resources from the MCP Servers",
              opts = {
                  requires_approval = true,
              }
            },
            vectorcode = {
              callback = function()
                return require("vectorcode.integrations").codecompanion.chat.make_tool()
              end,
              description = "Run VectorCode to retrieve the project context.",
            },
          },
        },
      },
    },
    cond = not vim.g.vscode
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
      model = 'claude-3.7-sonnet-thought', -- Use the sonnet model by default
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
      prompts = {
        DiffReview = {
          prompt = "Please review the provided code. The diff is included for review, along with selected portions of the relevant code being modified.",
          system_prompt = "You are a senior developer. Your job is to do a thorough code review of this code. You should write it up and output markdown. Include line numbers, and contextual info. Your code review will be passed to another teammate, so be thorough. Think deeply before writing the code review. Review every part, and don't hallucinate.",
          description = "Code review based on diffs",
        }
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
    cond = not vim.g.vscode
  },
}

-- Load lazy.nvim
require("lazy").setup(plugins)
