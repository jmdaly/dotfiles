-- This file contains local configuration in lua. When I move to an
-- init.lua, most of this could be moved into init.lua.

-- Directory containing my user-defined snippets
vim.api.nvim_set_var('vsnip_snippet_dir', vim.env.HOME .. '/dotfiles/snippets')

-- Copilot
vim.g.copilot_assume_mapped = true
-- Disable copilot completion for Rust, so that I have to think for myself
vim.g.copilot_filetypes = {
  rust = false
}

-- Set up material theme
require('material').setup({
        contrast = {
                sidebars = false,
                floating_windows = false,
                line_numbers = false,
                sign_column = false,
                cursor_line = false,
                non_current_windows = false,
                popup_menu = false
        },
        italics = {
                comments = true,
                strings = false,
                keywords = false,
                functions = false,
                variables = false
        },
        contrast_filetypes = {},
        high_visibility = {
                lighter = false,
                darker = false
        },
        disable = {
                borders = false,
                background = false,
                term_colors = false,
                eob_lines = false
        },
        custom_highlights = {}
})

-- A function to help get the current session name for lualine
local function session_name()
    return '[$ ' .. (require('possession.session').get_session_name() .. ']' or '')
end

-- A function to show which linters are running
local lint_progress = function()
  local linters = require("lint").get_running()
  if #linters == 0 then
      return "󰦕"
  end
  return "󱉶 " .. table.concat(linters, ", ")
end

require('lualine').setup{
  options = {
    theme = 'gruvbox'
  },
  sections = {
    lualine_a = { {'mode', upper = true} },
    lualine_b = { {'branch', icon = ''} },
    lualine_c = { {'filename', file_status = true}, {'diagnostics',
                                                      sources = { 'nvim_diagnostic' },
                                                    }
                },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { session_name, lint_progress },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {  },
    lualine_b = {  },
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {  },
    lualine_z = {   }
  },
}

-- Setup the debug adapter, for debugging in neovim
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}
dap.adapters.codelldb = {
  type = "executable",
  command = "codelldb",
}

-- Set up possession.nvim
require('possession').setup{
  autosave = {
    current = true,
  }
}

-- This function takes a string and splits it on the delimiter.
-- It returns a table of substrings, split on the delimiter.
function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = function()
      return Split(vim.fn.input('Command line args: '), " ")
    end,

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    runInTerminal = false,
  },
}
dap.configurations.rust = dap.configurations.cpp

-- Custom diff mode colors for better readability with gruvbox
-- These override the default gruvbox diff colors to be more vibrant and easier to read
local function setup_diff_colors()
  -- Gruvbox color palette (using the actual hex values from gruvbox)
  local colors = {
    dark0 = '#282828',
    dark1 = '#3c3836',
    dark2 = '#504945',
    light0 = '#fbf1c7',
    light1 = '#ebdbb2',
    light4 = '#a89984',
    bright_red = '#fb4934',
    bright_green = '#b8bb26',
    bright_yellow = '#fabd2f',
    bright_blue = '#83a598',
    bright_orange = '#fe8019',
    neutral_red = '#cc241d',
    neutral_green = '#98971a',
    neutral_yellow = '#d79921',
    faded_red = '#9d0006',
    faded_green = '#79740e',
  }

  -- Set diff colors with balanced approach: 
  -- Subtle but visible backgrounds + enhanced syntax via different strategy
  vim.api.nvim_set_hl(0, 'DiffAdd', { 
    bg = '#2d4a2d',  -- Slightly brighter dark green (was #2a3a2a)
    bold = false 
  })
  
  vim.api.nvim_set_hl(0, 'DiffDelete', { 
    bg = '#4a2d2d',  -- Slightly brighter dark red (was #3a2a2a)
    fg = colors.light4,  -- Keep fg for delete as it's often just markers
    bold = false 
  })
  
  vim.api.nvim_set_hl(0, 'DiffChange', { 
    bg = colors.dark1,  -- Slightly lighter gray (#3c3836)
    bold = false 
  })
  
  vim.api.nvim_set_hl(0, 'DiffText', { 
    bg = '#6a5a1f',  -- Slightly brighter golden brown (was #5a4a1a)
    fg = colors.light1,  -- Light text for contrast
    bold = true 
  })
end

-- Apply diff colors after colorscheme loads
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'gruvbox',
  callback = setup_diff_colors,
})

-- Also apply immediately if gruvbox is already loaded
if vim.g.colors_name == 'gruvbox' then
  setup_diff_colors()
end
