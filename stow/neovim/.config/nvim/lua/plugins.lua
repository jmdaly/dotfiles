-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local fn = vim.fn

-- -- Automatically install packer
-- local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
-- if fn.empty(fn.glob(install_path)) > 0 then
--   PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
--   print("Installing packer close and reopen Neovim...")
-- end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
)

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use 'wbthomason/packer.nvim' -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- Conditionally install with something like:
  -- https://github.com/wbthomason/packer.nvim/discussions/196#discussioncomment-345837

  -- Simple plugins can be specified as strings
  -- use 'rstacruz/vim-closer'

  -- Lazy loading:
  -- Load on specific commands
  -- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

  -- Load on an autocommand event
  use {'andymass/vim-matchup', event = 'VimEnter'}

 use {
    'tpope/vim-fugitive',
    -- config = function()
    --   vim.api.nvim_set_var('diffopt', vim.api.nvim_set_var('diffopt') .. 'vertical')
    -- end,
  }

  -- Used for navigating the quickfix window better.  Recommended by fugitive
  use 'tpope/vim-unimpaired'

  -- This should improve Git Fugitive and Git Gutter
  use 'tmux-plugins/vim-tmux-focus-events'

  use {
    'SirVer/ultisnips',
    config = function()
      vim.api.nvim_set_var('UltiSnipsExpandTrigger', '<c-j>')
      vim.api.nvim_set_var('UltiSnipsJumpForwardTrigger', '<c-j>')
      vim.api.nvim_set_var('UltiSnipsJumpBackwardTrigger', '<c-n>')

      -- If you want :UltiSnipsEdit to split your window.
      vim.api.nvim_set_var('UltiSnipsEditSplit', 'vertical')

      -- Add to the runtime path so that custom
      -- snippets can be found:
      -- let &rtp .= ','.expand(g:dotfiles)

      -- vim.api.nvim_set_var('vsnip_snippet_dir', vim.env.HOME .. '/dotfiles/snippets')
    end,
  }

  use {
    'honza/vim-snippets'
    -- config = function()
      -- vim.api.nvim_set_var('vsnip_snippet_dir', vim.env.HOME .. '/dotfiles/snippets')
    -- end,
  }
  use {
    'airblade/vim-rooter',
     config = function()
      vim.api.nvim_set_var('rooter_silent_chdir', 1)
      vim.api.nvim_set_var('rooter_patterns', {'.git', '_darcs', '.hg', '.bzr', '.svn'})
    end,
  }


   -- Adding this so I can search/replace and preserve letter case
   use 'tpope/vim-abolish'

   -- Highlighting for tmux
   use 'tmux-plugins/vim-tmux'

   -- Plug to assist with commenting out blocks of text:
   use 'tpope/vim-commentary'

   -- Tabular, align equals
   use 'godlygeek/tabular'

   -- Show markers
   use 'kshenoy/vim-signature'

   -- Display trailing whitespace
   use 'ntpeters/vim-better-whitespace'

   use 'TheZoq2/neovim-auto-autoread'

  use {
    'Hdima/python-syntax',
    ft = {'py', 'fsb'},
  }

  use {
    'shawncplus/phpcomplete.vim',
    ft = {'php'}
  }

  use {
    'psf/black',
    branch = 'stable',
    ft = {'py', 'fsb'},
    cond = vim.fn.executable('black'),
    config = function()
      vim.api.nvim_set_var('black_linelength', 150)
    end,
  }

  use {
    'mhinz/vim-signify',
    config = function()
      vim.api.nvim_set_option('updatetime', 100)
    end,
  }

  use 'vimlab/split-term.vim'

  use {
    'udalov/kotlin-vim',
    ft = {'kt'},
  }

  -- Colour coding nests
  use {
    'luochen1990/rainbow',
    config = function()
      -- 0 if you want to enable it later via :RainbowToggle
      vim.api.nvim_set_var('rainbow_active', 1)
    end,
    cond = false,
  }

  use 'tpope/vim-obsession'
  use 'mhinz/vim-startify'
  use {
    'szw/vim-maximizer',
    config = function()
      local map = require("utils").map
      map('n', '<leader>z', ':MaximizerToggle<CR>', { silent = true })
      map('v', '<leader>z', ':MaximizerToggle<CR>gv', { silent = true })
      map('i', '<leader>z', '<C-o>:MaximizerToggle<CR>', { silent = true })

      map('n', '<C-w>z', ':MaximizerToggle<CR>', { silent = true })
      map('v', '<C-w>z', ':MaximizerToggle<CR>gv', { silent = true })
      map('i', '<C-w>z', '<C-o>:MaximizerToggle<CR>', { silent = true })
    end,
  }


  -- Install fzf, the fuzzy searcher (also loads Ultisnips)
  use {
    'ibhagwan/fzf-lua',
    -- requires = {
    --   'junegunn/fzf',
    --   'build' = './install --all',
    --   'merged' = 0
    -- }
  }

  -- Configurations for neovim's language client
  use {
    'neovim/nvim-lspconfig',
    config = function()
      vim.api.nvim_set_var('clang_path', '/usr')

      local map = require("utils").map
      map('n', '<leader>rd', '<cmd>lua vim.lsp.buf.declaration()<CR>', { silent = true })
      map('n', '<leader>rj', '<cmd>lua vim.lsp.buf.definition()<CR>', { silent = true })
      map('n', '<leader>ty', '<cmd>lua vim.lsp.buf.hover()<CR>', { silent = true })
      map('n', '<leader>rk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { silent = true })
      map('n', '<leader>rf', '<cmd>lua vim.lsp.buf.references()<CR>', { silent = true })
      map('n', '<leader>ds', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { silent = true })
      map('n', '<leader>rw', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
      map('n', '<leader>c ', '<cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true })
      map('n', '<leader>m ', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { silent = true })
      map('n', '<leader>el', '<cmd>lua print(vim.lsp.get_log_path())<CR>', { silent = true })

      -- Various mappings to open the corresponding header/source file in a new split
      map('n', '<leader>of', '<cmd>ClangdSwitchSourceHeader<CR>', { silent = true })
      map('n', '<leader>oh', '<cmd>vsp<CR><cmd>ClangdSwitchSourceHeader<CR>', { silent = true })
      map('n', '<leader>oj', '<cmd>below sp<CR><cmd>ClangdSwitchSourceHeader<CR>', { silent = true })
      map('n', '<leader>ok', '<cmd>sp<CR><cmd>ClangdSwitchSourceHeader<CR>', { silent = true })
      map('n', '<leader>ol', '<cmd>below vsp<CR><cmd>ClangdSwitchSourceHeader<CR>', { silent = true })

      map('n', '[z', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { silent = true })
      map('n', ']z', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { silent = true })
    end
  }
  use { 'ojroques/nvim-lspfuzzy', required = { 'fzf' } }

  use 'mhinz/vim-sayonara' -- Plugin to make it easy to delete a buffer and close the file:

  -- Autocompletion plugin
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      -- vim.api.nvim_set_option('completeopt', 'menuone,noselect')

      -- local map = require("utils").map
      -- map('i', '<C-Space>', 'compe#complete()', { silent = true, expr=1 })
      -- map('i', '<CR>', 'compe#confirm("<CR>")', { silent = true, expr=1 })
      -- map('i', '<C-e>', 'compe#close("<C-e>")', { silent = true, expr=1 })
      -- map('i', '<C-f>', 'compe#scroll({ "delta": +4 })', { silent = true, expr=1 })
      -- map('i', '<C-d>', 'compe#scroll({ "delta": -4 })', { silent = true, expr=1 })
     end
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'

  -- Plugin for working with surroundings of words
  use 'tpope/vim-surround'

  -- A plugin for asynchronous linting while you type
  use {
    'w0rp/ale',
    ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
    cmd = 'ALEEnable',
    config = function()
      vim.cmd[[ALEEnable]]

      vim.api.nvim_set_var('ale_linters', {
        cpp = {'clangtidy'},
        c = {'clangtidy'},
      })

      vim.api.nvim_set_var('ale_fixers', {
       cpp = {'clang-format'},
       -- '*' = {'remove_trailing_lines', 'trim_whitespace'},
      })

      local map = require("utils").map
      -- Set up mapping to move between errors
      map('i', '[w', '<Plug>(ale_previous_wrap)', { silent = true })
      map('i', ']w', '<Plug>(ale_next_wrap)', { silent = true} )
    end,
  }

  use {
    'itchyny/lightline.vim',
    config = function()
      vim.api.nvim_set_var('lightline', {
        colorscheme = 'one',
        component_function = {
          filename = 'LightlineFilename',
        }
      })
      vim.api.nvim_set_var('unite_force_overwrite_statusline', 0)
      vim.api.nvim_set_var('vimfiler_force_overwrite_statusline', 0)
      vim.api.nvim_set_var('vimshell_force_overwrite_statusline', 0)
      vim.api.nvim_set_var('lightline.separator', { left = '', right = '' })
      vim.api.nvim_set_var('lightline.subseparator', { left = '', right = '' })
    end,
    cond = false
  }
  -- use 'maximbaz/lightline-ale'
  -- use 'kosayoda/nvim-lightbulb'

  use {
    'PProvost/vim-ps1',
    ft = {'ps1'}
  }

  -- syntax highlighting for *.hal, *.bp, and *.rc files.
  use 'https://github.ford.com/MRUSS100/aosp-vim-syntax.git'
  use 'rubberduck203/aosp-vim'

  use 'kheaactua/vim-fzf-repo'

  -- Vim sugar for the UNIX shell commands that need it the most. Features include:
  -- :Remove: Delete a buffer and the file on disk simultaneously.
  -- :Unlink: Like :Remove, but keeps the now empty buffer.
  -- :Move:   Rename a buffer and the file on disk simultaneously.
  -- :Rename: Like :Move, but relative to the current file's containing directory.
  -- :Chmod:  Change the permissions of the current file.
  -- :Mkdir:  Create a directory, defaulting to the parent of the current file.
  -- :Find:   Run find and load the results into the quickfix list.
  -- :Locate: Run locate and load the results into the quickfix list.
  -- :Wall:   Write every open window. Handy for kicking off tools like guard.
  -- :SudoWrite: Write a privileged file with sudo.
  -- :SudoEdit:  Edit a privileged file with sudo.
  use 'tpope/vim-eunuch'

  -- Colourschemes
  use 'altercation/vim-colors-solarized'
  use 'kristijanhusak/vim-hybrid-material'
  use 'atelierbram/vim-colors_duotones'
  use 'atelierbram/vim-colors_atelier-schemes'

  -- Other..
  use 'rakr/vim-one'
  use 'arcticicestudio/nord-vim'
  use 'drewtempelmeyer/palenight.vim'
  use 'morhetz/gruvbox'
  use 'mhartington/oceanic-next'

  use {
    'ayu-theme/ayu-vim',
     config = function()
      vim.api.nvim_set_var('ayucolor', 'mirage')
      vim.api.nvim_set_var('rooter_patterns', {'.git', '_darcs', '.hg', '.bzr', '.svn'})
    end,
  }

  -- A bunch more...
  use 'flazz/vim-colorschemes'

  use {
    'kheaactua/vim-managecolor',
    config = function()
      dotfiles_dir=vim.api.nvim_get_var('dotfiles')
      vim.api.nvim_set_var('colo_search_path', dotfiles_dir .. '/bundles/dein')
      vim.api.nvim_set_var('colo_cache_file', dotfiles_dir .. '/colos.json')
    end,
  }

  -- /Colourschemes


  -- use 'majutsushi/tagbar'
  -- use 'hoschi/yode-nvim'
  -- use 'mtth/scratch.vim'
  -- use 'editorconfig/editorconfig-vim'

--   -- Plugins can have dependencies on other plugins
--   use {
--     'haorenW1025/completion-nvim',
--     opt = true,
--     requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
--   }


  -- Local plugins can be included
  -- use '~/projects/personal/hover.nvim'

  -- -- Plugins can have post-install/update hooks
  -- use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

--   -- Use specific branch, dependency and run lua file after load
--   use {
--     'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
--     requires = {'kyazdani42/nvim-web-devicons'}
--   }

--   -- Use dependency and run lua function after load
--   use {
--     'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
--     config = function() require('gitsigns').setup() end
--   }

  -- You can specify multiple plugins in a single call
  -- use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}

  -- You can alias plugin names
  use {'dracula/vim', as = 'dracula'}


  -- if packer_plugins["vim-rooter"] and packer_plugins["vim-rooter"].loaded then
  --   print("Setting up vim rooter")
  -- end


  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
