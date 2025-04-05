-- Common settings and keymaps that work in both standalone Neovim and VSCode

-- Make searching case-insensitive:
vim.opt.ignorecase = true
-- When an upper case letter is in the search
-- make it case sensitive
vim.opt.smartcase = true

-- Set up common keymaps that work in both environments

-- Most of your complex keymaps will be defined in the standalone config
-- Only put very basic keymaps that would work identically in both environments here

-- For example:
-- Some basic vim-surround-like functionality that should work in both environments
-- (if you're using vim-surround plugin, you might not need these)

-- Some common fugitive mappings if they work in both environments
-- Comment these out if they cause issues in VSCode
vim.keymap.set('n', '<Leader>gs', ':Git<CR>')
vim.keymap.set('n', '<Leader>gd', ':Gdiffsplit<CR>')
vim.keymap.set('n', '<Leader>gb', ':Git blame<CR>')

-- Add other common settings and mappings that you want in both environments
