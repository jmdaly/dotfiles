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
  'sindrets/diffview.nvim', -- A git diff viewer for neovim

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

  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require('nvim-treesitter')
      treesitter.install({
        "c", "cpp", "cmake", "cuda", "groovy", "lua", "rust", "vim", "vimdoc", "markdown", "yaml", "json", "python", "bash", "dockerfile", "regex", "comment", "diff", "git_rebase", "toml",
      })
    end,
  },

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
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { 'markdown', 'codecompanion' },
    },
  },

  -- Improved Rust development
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
            checkOnSave = true,
            check = {
              allFeatures = true,
              allTargets = true,
              command = "clippy",
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

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    cmd = "MCPHub",  -- lazy load by default
    build = "npm install -g mcp-hub@latest",  -- Installs required mcp-hub npm module
    opts = { },
  },

  {
    "Davidyz/VectorCode",
    version = "0.5.5", -- optional, depending on whether you're on nightly or release
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode",
  },

  -- Plugin to integrate with LLMs for chat
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    opts = {
      display = {
        chat = {
          show_settings = false,
        },
      },
      adapters = {
          http = {
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
        acp = {
          goose = {
            name = "goose",
            formatted_name = "Goose 🪿",
            type = "acp",
            roles = {
              llm = "assistant",
              user = "user",
            },
            opts = {
            },
            commands = {
              default = {
                "goose",
                "acp",
              },
            },
            defaults = {
              mcpServers = {},
              timeout = 20000, -- 20 seconds
            },
            env = {
            },
            parameters = {
              protocolVersion = 1,
              clientCapabilities = {
                fs = { readTextFile = true, writeTextFile = true },
              },
              clientInfo = {
                name = "CodeCompanion.nvim",
                version = "1.0.0",
              },
            },
            handlers = {
              ---@param self CodeCompanion.ACPAdapter
              ---@return boolean
              setup = function(self)
                return true
              end,

              ---Manually handle authentication
              ---@param self CodeCompanion.ACPAdapter
              ---@return boolean
              auth = function(self)
                return true
              end,

              ---@param self CodeCompanion.ACPAdapter
              ---@param messages table
              ---@param capabilities table
              ---@return table
              form_messages = function(self, messages, capabilities)
                local helpers = require("codecompanion.adapters.acp.helpers")
                return helpers.form_messages(self, messages, capabilities)
              end,

              ---Function to run when the request has completed. Useful to catch errors
              ---@param self CodeCompanion.ACPAdapter
              ---@param code number
              ---@return nil
              on_exit = function(self, code) end,
            },
          },
        },
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
            vectorcode = {
              callback = function()
                return require("vectorcode.integrations").codecompanion.chat.make_tool()
              end,
              description = "Run VectorCode to retrieve the project context.",
            },
          },
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
            make_vars = true, -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        }
      },
    },
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
  },

})
