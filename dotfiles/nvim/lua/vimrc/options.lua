local o = vim.opt
local g = vim.g

g.mapleader = ' '
g.maplocalleader = ' '
g.python3_host_prog = vim.trim(vim.fn.system('which python3'))

-- Configure backspace so it acts as it should
o.backspace = { 'eol', 'start', 'indent' }
-- Disable mouse
o.mouse = nil

-- Fold config
o.foldenable = true
o.foldmethod = 'indent'
o.foldlevel = 99
o.foldlevelstart = 4

o.updatetime = 200
o.timeoutlen = 500
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.history = 5000
o.tabstop = 4
o.shiftwidth = o.tabstop:get()
o.autoindent = true
o.smartindent = true
o.wrap = false
if o.wrap:get() then
	o.showbreak = '+ '
end
-- Toggle paste mode
o.pastetoggle = '<F3>'
-- Show tabs and spaces
o.list = true
if o.list:get() then
	o.listchars = { tab = '| ', space = ' ', trail = '·' }
end

-- Global statusline
o.laststatus = 3

o.termguicolors = true

o.completeopt = { 'menuone', 'noselect' }

-- Incremental live completion
o.inccommand = 'nosplit'

-- Line numbering
o.number = true
o.relativenumber = true

o.langmenu = 'en'
o.wildmenu = true
o.wildignore = { '*.o', '*~', '*.pyc' }
o.encoding = 'utf8'
o.hidden = true

-- Default split positions
o.splitbelow = true
o.splitright = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = true
-- Makes search act like search in modern browsers
o.incsearch = true
-- Don't redraw while executing macros (good performance config)
o.lazyredraw = true
-- For regular expressions turn magic on
o.magic = true
-- Show matching brackets when text indicator is over them
o.showmatch = true
-- How many tenths of a second to blink when matching brackets
o.mat = 2

o.undofile = true
o.undodir = vim.fn.stdpath('data') .. '/undo_dir/'

o.swapfile = false
o.title = true

if g.neovide then
	g.neovide_refresh_rate = 60
	g.neovide_transparency = 0.8
	g.neovide_cursor_vfx_mode = 'railgun'
end
