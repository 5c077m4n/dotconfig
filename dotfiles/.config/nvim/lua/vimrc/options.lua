local o = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "
g.python3_host_prog = vim.trim(vim.fn.system("which python3"))

-- Configure backspace so it acts as it should
o.backspace = { "eol", "start", "indent" }

-- Session config
o.sessionoptions = { "buffers", "tabpages", "curdir", "winsize" }

o.timeout = true
o.timeoutlen = 300
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.history = 5000
o.tabpagemax = 50
o.tabstop = 4
---@diagnostic disable-next-line: undefined-field
o.shiftwidth = o.tabstop:get()
o.autoindent = true
o.smartindent = true
o.signcolumn = "yes"
o.wrap = true
o.showbreak = "⏎ "
-- Show tabs and spaces
o.list = true
o.listchars = { tab = "> ", space = " ", trail = "·" }

-- Global statusline
o.laststatus = 3

o.termguicolors = true

o.complete:remove("i")
o.completeopt = { "menu", "menuone", "noselect", "preview" }
o.smarttab = true

-- Delete comment character when joining commented lines
o.formatoptions:append("j")

o.autoread = true
o.sessionoptions:remove("options")
o.viewoptions:remove("options")
-- Disable a legacy behavior that can break plugin maps
o.langremap = false

-- Incremental live completion
o.inccommand = "split"

-- Line numbering
o.number = true
o.relativenumber = true

o.langmenu = "en"
o.wildmenu = true
o.wildignore = { "*.o", "*~", "*.pyc" }
o.encoding = "utf8"
o.hidden = true

-- Default split positions
o.splitbelow = true
o.splitright = true
o.winminwidth = 5

o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
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

o.undodir = vim.fn.stdpath("state") .. "/undo_dir/"
o.undofile = true

o.swapfile = false
o.title = true

-- Ranger config
g.ranger_map_keys = 0
g.ranger_command_override = [[ranger --cmd "set show_hidden=true"]]

-- Netrw
--- Hide main banner
g.netrw_banner = 0
--- Show directories first (sorting)
g.netrw_sort_sequence = [[[\/]$,*]]
--- Netrw list style
--- 0: thin listing (one file per line)
--- 1: long listing (one file per line with timestamp information and file size)
--- 2: wide listing (multiple files in columns)
--- 3: tree style listing
g.netrw_liststyle = 3
--- Setup file operations commands
if vim.loop.os_uname().sysname ~= "Windows" then
	g.netrw_localcopydircmd = "cp -r"
	g.netrw_localmkdir = "mkdir -p"
	-- NOTE: 'rm' is used instead of 'rmdir' (default) to be able to remove non-empty directories
	g.netrw_localrmdir = "rm -r"
end

if g.neovide then
	g.neovide_position_animation_length = 0
	g.neovide_cursor_animation_length = 0.00
	g.neovide_cursor_trail_size = 0
	g.neovide_cursor_animate_in_insert_mode = false
	g.neovide_cursor_animate_command_line = false
	g.neovide_scroll_animation_far_lines = 0
	g.neovide_scroll_animation_length = 0.00
end
