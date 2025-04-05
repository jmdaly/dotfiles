-- VSCode-specific configuration
local vscode = require('vscode')

-- These are some useful VSCode-specific keybindings
-- You can modify these to match your preferences

-- Navigation
vim.keymap.set('n', 'gh', function() vscode.action('editor.action.showHover') end)
vim.keymap.set('n', 'gd', function() vscode.action('editor.action.revealDefinition') end)
vim.keymap.set('n', 'gD', function() vscode.action('editor.action.peekDefinition') end)
vim.keymap.set('n', 'gH', function() vscode.action('editor.action.referenceSearch.trigger') end)
vim.keymap.set('n', 'gf', function() vscode.action('editor.action.revealDeclaration') end)
vim.keymap.set('n', 'gF', function() vscode.action('editor.action.peekDeclaration') end)
vim.keymap.set('n', '<C-w>gd', function() vscode.action('editor.action.revealDefinitionAside') end)
vim.keymap.set('n', 'gO', function() vscode.action('workbench.action.gotoSymbol') end)

-- Code Actions
vim.keymap.set({'n', 'x'}, '=', function() vscode.action('editor.action.formatSelection') end)
vim.keymap.set('n', '==', function() vscode.action('editor.action.formatSelection') end)

-- Commenting (if using VSCode's commenting feature)
vim.keymap.set({'n', 'x'}, 'gc', function() vscode.action('editor.action.commentLine') end)

-- Search
vim.keymap.set('n', '<Leader>rg', function() vscode.action('workbench.action.findInFiles') end)
vim.keymap.set('n', '<Leader>w', function()
  vscode.action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })
end)

-- File navigation
vim.keymap.set('n', '<Leader>z', function() vscode.action('workbench.action.quickOpen') end)
vim.keymap.set('n', '<Leader><Tab>', function() vscode.action('workbench.action.showAllEditors') end)

-- LSP-like functionality
vim.keymap.set('n', '<Leader>rd', function() vscode.action('editor.action.goToImplementation') end)
vim.keymap.set('n', '<Leader>rj', function() vscode.action('editor.action.goToReferences') end)
vim.keymap.set('n', '<Leader>ty', function() vscode.action('editor.action.showHover') end)
vim.keymap.set('n', '<Leader>rf', function() vscode.action('references-view.find') end)
vim.keymap.set('n', '<Leader>ds', function() vscode.action('workbench.action.gotoSymbol') end)
vim.keymap.set('n', '<Leader>dg', function() vscode.action('workbench.action.showAllProblems') end)
vim.keymap.set('n', '<Leader>rw', function() vscode.action('editor.action.rename') end)
vim.keymap.set('n', '<Leader>k', function() vscode.action('editor.action.quickFix') end)
vim.keymap.set('n', '<Leader>m', function() vscode.action('editor.action.showHover') end)
vim.keymap.set('n', '<Leader>f', function() vscode.action('editor.action.formatDocument') end)

-- File operations
vim.keymap.set('n', '<Leader>q', function() vscode.action('workbench.action.closeActiveEditor') end)
vim.keymap.set('n', '<Leader>Q', function() vscode.action('workbench.action.closeAllEditors') end)

-- Adapt your terminal escape keymap for VSCode terminal
vim.keymap.set('t', '<Leader>e', '<C-\\><C-n>')

-- Copilot and AI integration
-- These match your existing bindings but use VSCode's implementation
vim.keymap.set({'n', 'v'}, '<leader>]', function() vscode.action('github.copilot.chat.focus') end)
vim.keymap.set({'n', 'v'}, '<leader>[', function() vscode.action('github.copilot.chat.toggleSidebar') end)

-- Any other VSCode-specific keybindings you want to add

-- Set up a function to handle some common VSCode actions that might be needed
local function setup_vscode_commands()
  -- Define any custom commands that you might need in VSCode
  vim.api.nvim_create_user_command('Format', function() vscode.action('editor.action.formatDocument') end, {})
  vim.api.nvim_create_user_command('Rename', function() vscode.action('editor.action.rename') end, {})
  vim.api.nvim_create_user_command('FindReferences', function() vscode.action('editor.action.referenceSearch.trigger') end, {})
end

setup_vscode_commands()
