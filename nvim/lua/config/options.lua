local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation: 2 spaces, matches typical TS/Biome projects
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.wrap = false
opt.cursorline = true
opt.splitright = true
opt.splitbelow = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Performance / UX
opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menuone", "noselect" }

vim.g.mapleader = " "
vim.g.maplocalleader = " "
