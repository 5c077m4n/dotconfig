local vscode = require('vscode-neovim')

local g = vim.g
local o = vim.opt

g.mapleader = ' '
g.maplocalleader = ' '

o.undodir = vim.fn.stdpath('state') .. '/undo_dir/'
o.undofile = true

o.swapfile = false
o.title = true

g.clipboard = g.vscode_clipboard
vim.notify = vscode.notify
