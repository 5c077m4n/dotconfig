local utils = require("vimrc.utils")

local module_utils, signals, keymap = utils.modules, utils.signals, utils.keymapping
local create_command = vim.api.nvim_create_user_command

---@param cmd string
local function norBang(cmd)
	return function()
		-- selene: allow(mixed_table)
		vim.cmd.normal({ cmd, bang = true })
	end
end

keymap.nnoremap("<leader>0", module_utils.update_vimrc, { desc = "Git pull latest vimrc" })
keymap.nnoremap("<leader>1", function()
	require("lazy").sync()
end, { desc = "Update all plugins" })
keymap.nnoremap("<leader>2", module_utils.reload_vimrc, { desc = "Reload vimrc" })
keymap.nnoremap("<leader>3", signals.send_usr1_to_all_nvim, { desc = "Reload all NVIM instances" })

-- Save only if needed
keymap.nnoremap("<leader>up", vim.cmd.update, { desc = "Save buffer only if changed" })

-- Center screen on page up/down
keymap.nnoremap("<C-u>", "<C-u>zz")
keymap.nnoremap("<C-d>", "<C-d>zz")

-- Splits
keymap.nnoremap("<leader>wq", "<C-w>q", { desc = "Close split" })
keymap.nnoremap("<leader>wv", vim.cmd.vsplit, { desc = "New vertical split" })
keymap.nnoremap("<leader>wh", vim.cmd.split, { desc = "New horizontal split" })

-- Tabs
keymap.nnoremap("<leader>tn", function()
	vim.cmd.tabnew("%")
end, { desc = "New tab in cwd" })
keymap.nnoremap("<leader>tq", vim.cmd.tabclose, { desc = "Close current tab" })
keymap.nnoremap("<leader>tQ", vim.cmd.tabonly, { desc = "Close all other tabs" })
keymap.nnoremap("<leader>tl", vim.cmd.tabs, { desc = "List tabs" })
keymap.nnoremap("]t", vim.cmd.tabnext, { desc = "Next tab" })
keymap.nnoremap("[t", vim.cmd.tabprevious, { desc = "Previous tab" })

keymap.tnoremap("<C-]>", [[<C-\><C-n>]], { desc = "Goto insert mode in terminal" })

create_command("SelectAll", [[normal! gg0VG$]], { desc = "Select all buffer content" })
create_command("CopyAll", [[normal! gg0VG$"+y]], { desc = "Copy all buffer content" })

keymap.vnoremap("<C-y>", [["+y]], { desc = "Copy selection to clipboard" })
keymap.nnoremap("V", "v$", { desc = "Select to line end" })
keymap.nnoremap("S", "v$hs", { desc = "Switch to line end" })
keymap.nnoremap("J", [[J^]], { desc = "Join the next line and go to the first char" })

keymap.vnoremap("/", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], { desc = "Search page for selection" })

keymap.nnoremap(
	"<CR>",
	vim.cmd.nohlsearch,
	{ desc = "Stops the highlight on the last search pattern matches" }
)

-- Word traversing in insert mode
keymap.inoremap("<C-b>", norBang("b"), { desc = "Traverse one word left" })
keymap.inoremap("<C-e>", norBang("e"), { desc = "Traverse one word right" })
keymap.inoremap("<C-w>", norBang("w"), { desc = "Traverse one word right" })
keymap.inoremap("<C-h>", norBang("h"), { desc = "Traverse one letter left" })
keymap.inoremap("<C-j>", norBang("j"), { desc = "Traverse one line down" })
keymap.inoremap("<C-k>", norBang("k"), { desc = "Traverse one line up" })
keymap.inoremap("<C-l>", norBang("l"), { desc = "Traverse one letter right" })

-- Special paste
keymap.vnoremap(
	"p",
	[["_dP]],
	{ desc = "Paste after without overriding the current register's content" }
)
keymap.vnoremap(
	"P",
	[["_dp]],
	{ desc = "Paste before without overriding the current register's content" }
)

keymap.nnoremap("<leader>cd", function()
	local cwd = vim.fn.expand("%:p:h")
	vim.cmd.cd(cwd)
	vim.notify('Changed current work dir to "' .. cwd .. '"')
end, { desc = "Switch CWD to the directory of the open buffer" })

keymap.nnoremap("<leader>rl", function()
	vim.wo.rightleft = not vim.wo.rightleft
end, { desc = "Toggle window's right-to-left mode" })

-- Undo
keymap.nnoremap("U", vim.cmd.redo, { desc = "Redo last change" })

create_command("CopyCursorLocation", function()
	local file_path = vim.fn.expand("%:.")
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))

	local cursor_location = file_path .. ":" .. line .. ":" .. col
	if vim.fn.has("clipboard") then
		vim.fn.setreg("+", cursor_location)
	else
		vim.fn.setreg("1", cursor_location)
	end
	vim.notify(cursor_location, vim.lsp.log_levels.INFO)
end, { desc = "Copy the current cursor location" })

-- Diagnostics toggles
keymap.nnoremap("<leader>dy", function()
	vim.diagnostic.enable(0)
end, { desc = "Enable diagnostics for current buffer" })
keymap.nnoremap("<leader>dn", function()
	vim.diagnostic.disable(0)
end, { desc = "Disable diagnostics for current buffer" })
keymap.nnoremap(
	"<leader>dY",
	vim.diagnostic.enable,
	{ desc = "Enable diagnostics for all buffers" }
)
keymap.nnoremap(
	"<leader>dN",
	vim.diagnostic.disable,
	{ desc = "Disable diagnostics for all buffers" }
)
