-- This file contains local configuration in lua. When I move to an
-- init.lua, most of this could be moved into init.lua.

-- Directory containing my user-defined snippets
vim.api.nvim_set_var('vsnip_snippet_dir', vim.env.HOME .. '/dotfiles/snippets')

-- Set up material theme
require('material').setup({
        contrast = true,
        borders = false,
        italics = {
                comments = true,
                strings = false,
                keywords = false,
                functions = false,
                variables = false
        },
        contrast_windows = {
                "terminal",
                "packer",
                "qf"
        },
        text_contrast = {
                lighter = false,
                darker = false
        },
        disable = {
                background = false,
                term_colors = false,
                eob_lines = false
        },
        custom_highlights = {}
})


require('lualine').setup{
  options = {
    theme = 'material-nvim'
  },
  sections = {
    lualine_a = { {'mode', upper = true} },
    lualine_b = { {'branch', icon = ''} },
    lualine_c = { {'filename', file_status = true}, {'diagnostics',
                                                      sources = { 'nvim_lsp', 'ale' },
                                                    }
                },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'ObsessionStatus', 'progress' },
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

-- Setup for lightspeed.nvim, a Sneak-like plugin for medium
-- distance motions.
require('lightspeed').setup {
   jump_to_first_match = true,
   jump_on_partial_input_safety_timeout = 400,
   highlight_unique_chars = false,
   grey_out_search_area = true,
   match_only_the_start_of_same_char_seqs = true,
   limit_ft_matches = 5,
   full_inclusive_prefix_key = '<c-x>',
}

-- Lightspeed overrides the default f/F/t/T maps, but I prefer the default
-- approach. As a result, I unmap those maps here.
vim.api.nvim_del_keymap('n', 'f')
vim.api.nvim_del_keymap('o', 'f')
vim.api.nvim_del_keymap('x', 'f')

vim.api.nvim_del_keymap('n', 'F')
vim.api.nvim_del_keymap('o', 'F')
vim.api.nvim_del_keymap('x', 'F')

vim.api.nvim_del_keymap('n', 't')
vim.api.nvim_del_keymap('o', 't')
vim.api.nvim_del_keymap('x', 't')

vim.api.nvim_del_keymap('n', 'T')
vim.api.nvim_del_keymap('o', 'T')
vim.api.nvim_del_keymap('x', 'T')

-- Setup the debug adapter, for debugging in neovim
local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed
  name = "lldb"
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

