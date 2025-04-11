local o = vim.opt
local g = vim.g

g.mapleader = " "
g.maplocalleader = " "
g.python3_host_prog = vim.trim(vim.fn.system("which python3"))

-- Configure backspace so it acts as it should
o.backspace = { "eol", "start", "indent" }
-- Disable mouse
o.mouse = nil

-- Fold config
o.foldenable = true
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 10

o.sessionoptions = { "buffers", "tabpages", "curdir", "winsize" }

o.timeout = true
o.timeoutlen = 300
o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.history = 5000
o.tabpagemax = 50
o.tabstop = 4
---@diagnostic disable-next-line: assign-type-mismatch
o.shiftwidth = o.tabstop:get()
o.autoindent = true
o.smartindent = true
o.signcolumn = "yes"
o.wrap = true
o.showbreak = "⏎ "
-- Toggle paste mode
o.pastetoggle = "<F3>"
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
o.inccommand = "nosplit"

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

---@diagnostic disable-next-line: assign-type-mismatch
o.undodir = vim.fn.stdpath("state") .. "/undo_dir/"
o.undofile = true

o.swapfile = false
o.title = true

g.ranger_map_keys = 0
g.ranger_command_override = [[ranger --cmd "set show_hidden=true"]]

if g.neovide then
	g.neovide_refresh_rate = 60
	g.neovide_refresh_rate_idle = 10
	g.neovide_transparency = 1
	g.neovide_cursor_vfx_mode = "railgun"
	g.neovide_scroll_animation_length = 0.5
	g.neovide_hide_mouse_when_typing = true
	g.neovide_fullscreen = false
	g.neovide_input_use_logo = true
	g.neovide_input_macos_alt_is_meta = true
end
