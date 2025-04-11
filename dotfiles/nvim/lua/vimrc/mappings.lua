local packer = require('packer')

local keymap = require('vimrc.utils.keymapping')
local module_utils = require('vimrc.utils.modules')

local create_command = vim.api.nvim_create_user_command

keymap.nnoremap('<leader>0', module_utils.update_vimrc, { desc = 'Git pull latest vimrc' })
keymap.nnoremap('<leader>1', packer.sync, { desc = 'Packer sync' })
keymap.nnoremap('<leader>2', module_utils.reload_vimrc, { desc = 'Reload the vimrc config' })

-- Center screen on page up/down
keymap.nnoremap('<C-u>', '<C-u>zz')
keymap.nnoremap('<C-d>', '<C-d>zz')

-- Splits
keymap.nnoremap('<C-h>', '<C-w>h', { desc = 'Move one split left' })
keymap.nnoremap('<C-j>', '<C-w>j', { desc = 'Move one split down' })
keymap.nnoremap('<C-k>', '<C-w>k', { desc = 'Move one split up' })
keymap.nnoremap('<C-l>', '<C-w>l', { desc = 'Move one split right' })
keymap.nnoremap('<leader>wq', '<C-w>q', { desc = 'Close split' })
keymap.nnoremap('<leader>wv', vim.cmd.vsplit, { desc = 'New vertical split' })
keymap.nnoremap('<leader>wh', vim.cmd.split, { desc = 'New horizontal split' })

-- Tabs
keymap.nnoremap('<leader>tn', vim.cmd.tabnew, { desc = 'New tab' })
keymap.nnoremap('<leader>tq', vim.cmd.tabclose, { desc = 'Close current tab' })
keymap.nnoremap('<leader>tQ', vim.cmd.tabonly, { desc = 'Close all other tabs' })
keymap.nnoremap('<leader>t]', vim.cmd.tabnext, { desc = 'Next tab' })
keymap.nnoremap('<leader>t[', vim.cmd.tabprevious, { desc = 'Previous tab' })
keymap.nnoremap('<leader>tl', vim.cmd.tabs, { desc = 'List tabs' })

keymap.tnoremap('<C-]>', [[<C-\><C-n>]], { desc = 'Goto insert mode in terminal' })

create_command('SelectAll', [[normal! gg0VG$]], { desc = 'Select all buffer content' })
create_command('CopyAll', [[normal! gg0VG$"+y]], { desc = 'Copy all buffer content' })

keymap.vnoremap('<C-y>', [["+y]], { desc = 'Copy selection to clipboard' })
keymap.nnoremap('V', 'v$', { desc = 'Select to line end' })
keymap.nnoremap('J', [[J^]], { desc = 'Join the next line and go to the first char' })

-- Jump to line start/end
keymap.nnoremap('[[', '^', { desc = 'Jump to line start' })
keymap.vnoremap('[[', '^', { desc = 'Jump to line start' })
keymap.nnoremap(']]', '$', { desc = 'Jump to line end' })
keymap.vnoremap(']]', '$', { desc = 'Jump to line end' })

-- Move selection up/down
keymap.vnoremap('<A-k>', [[:m '>-2<CR>gv=gv]], { desc = 'Move selection up' })
keymap.nnoremap('<A-k>', [[:m .-2<CR>==]], { desc = 'Move selection up' })
keymap.vnoremap('<A-j>', [[:m '>+1<CR>gv=gv]], { desc = 'Move selection down' })
keymap.nnoremap('<A-j>', [[:m .+1<CR>==]], { desc = 'Move selection down' })

keymap.nnoremap('<CR>', vim.cmd.nohlsearch, { desc = 'Stops the highlight on the last search pattern matches' })

-- Word traversing
keymap.inoremap('<C-b>', function()
	vim.cmd.normal({ 'b', bang = true })
end, { desc = 'Traverse one word left' })
keymap.inoremap('<C-e>', function()
	vim.cmd.normal({ 'e', bang = true })
end, { desc = 'Traverse one word right' })
keymap.inoremap('<C-w>', function()
	vim.cmd.normal({ 'w', bang = true })
end, { desc = 'Traverse one word right' })
keymap.inoremap('<C-h>', function()
	vim.cmd.normal({ 'h', bang = true })
end, { desc = 'Traverse one letter left' })
keymap.inoremap('<C-j>', function()
	vim.cmd.normal({ 'j', bang = true })
end, { desc = 'Traverse one line down' })
keymap.inoremap('<C-k>', function()
	vim.cmd.normal({ 'k', bang = true })
end, { desc = 'Traverse one line up' })
keymap.inoremap('<C-l>', function()
	vim.cmd.normal({ 'l', bang = true })
end, { desc = 'Traverse one letter right' })

-- Special paste
keymap.vnoremap('p', [["_dP]], { desc = "Paste after without overriding the current register's content" })
keymap.vnoremap('P', [["_dp]], { desc = "Paste before without overriding the current register's content" })

keymap.nnoremap('<leader>cd', function()
	local cwd = vim.fn.expand('%:p:h')
	vim.cmd.cd(cwd)
	vim.notify('Changed current work dir to "' .. cwd .. '"')
end, { desc = 'Switch CWD to the directory of the open buffer' })

-- Undo
keymap.nnoremap('U', '<C-r>', { desc = 'Redo last change' })

create_command('CopyCursorLocation', function()
	local file_path = vim.fn.expand('%')
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))

	local cursor_location = file_path .. ':' .. line .. ':' .. col
	if vim.fn.has('clipboard') then
		vim.fn.setreg('+', cursor_location)
	else
		vim.fn.setreg('1', cursor_location)
	end
	vim.notify(cursor_location, vim.lsp.log_levels.INFO)
end, { desc = 'Copy the current cursor location' })

keymap.nnoremap('<leader>dy', function()
	vim.diagnostic.enable(0)
end, { desc = 'Enable diagnostics for current buffer' })
keymap.nnoremap('<leader>dn', function()
	vim.diagnostic.disable(0)
end, { desc = 'Disable diagnostics for current buffer' })
keymap.nnoremap('<leader>dY', vim.diagnostic.enable, { desc = 'Enable diagnostics for all buffers' })
keymap.nnoremap('<leader>dN', vim.diagnostic.disable, { desc = 'Disable diagnostics for all buffers' })
