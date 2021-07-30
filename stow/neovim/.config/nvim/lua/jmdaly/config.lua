-- This file contains local configuration in lua. When I move to an
-- init.lua, most of this could be moved into init.lua.

-- Directory containing my user-defined snippets
vim.api.nvim_set_var('vsnip_snippet_dir', vim.env.HOME .. '/dotfiles/snippets')

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
