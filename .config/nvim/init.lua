local fn = vim.fn
local opt = vim.opt

vim.g.mapleader = ","

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.autoindent = true
opt.smartindent = true

opt.hlsearch = false
opt.incsearch = true

opt.undodir = fn.stdpath('state')..'/undo'
opt.undofile = true

opt.completeopt = 'menu,menuone,noselect'

opt.list = true
opt.listchars = 'tab:!·,trail:·,nbsp:!'

require('plugins')
