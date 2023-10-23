-- This file contains local configuration in lua. When I move to an
-- init.lua, most of this could be moved into init.lua.

-- Directory containing my user-defined snippets
vim.api.nvim_set_var('vsnip_snippet_dir', vim.env.HOME .. '/dotfiles/snippets')

-- Copilot
vim.g.copilot_assume_mapped = true

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
    return '[$ ' .. require('possession.session').session_name .. ']' or ''
end

require('lualine').setup{
  options = {
    theme = 'gruvbox-material'
  },
  sections = {
    lualine_a = { {'mode', upper = true} },
    lualine_b = { {'branch', icon = ''} },
    lualine_c = { {'filename', file_status = true}, {'diagnostics',
                                                      sources = { 'nvim_diagnostic', 'ale' },
                                                    }
                },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { session_name },
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

-- Set up leap default keybindings
require('leap').add_default_mappings()

-- Setup the debug adapter, for debugging in neovim
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
}

-- Set up possession.nvim
require('possession').setup{}

-- Set up treesitter
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "cpp", "groovy", "lua", "rust", "vim", "vimdoc", "markdown", "yaml", "json", "python", "bash", "dockerfile", "regex", "comment", "diff", "git_rebase" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
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
    type = "lldb",
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

