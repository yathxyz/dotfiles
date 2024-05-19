-- init.lua

-- Disable syntax highlighting for performance
vim.cmd('syntax off')

-- Optionally, set a minimal colorscheme or no colorscheme
vim.cmd('colorscheme default')

-- Basic settings for a fast and minimalist Neovim setup
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.hidden = true         -- Enable background buffers
vim.opt.wrap = false          -- Disable line wrapping
vim.opt.swapfile = false      -- Disable swap file
vim.opt.backup = false        -- Disable backup
vim.opt.writebackup = false   -- Disable write backup
vim.opt.undofile = false      -- Disable undo file

-- Set minimal key mappings (customize as needed)
vim.api.nvim_set_keymap('n', '<Space>', '', { noremap = true })
vim.g.mapleader = ' '

-- Disable plugins for a lightweight setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basic indentation settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Disable some Neovim features for speed
vim.opt.lazyredraw = true

-- You can add more settings or plugins as needed

