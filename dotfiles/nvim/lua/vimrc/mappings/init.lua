local packer = require('packer')

local keymap = require('vimrc.utils.keymapping')
local module_utils = require('vimrc.utils.modules')

local create_command = vim.api.nvim_create_user_command

keymap.nnoremap('<leader>0', module_utils.update_vimrc, { desc = 'Git pull latest vimrc' })
keymap.nnoremap('<leader>1', packer.sync, { desc = 'Packer sync' })
keymap.nnoremap('<leader>2', module_utils.reload_vimrc, { desc = 'Reload the vimrc config' })

-- Splits
keymap.nnoremap('<C-h>', '<C-w>h', { desc = 'Move one split left' })
keymap.nnoremap('<C-j>', '<C-w>j', { desc = 'Move one split down' })
keymap.nnoremap('<C-k>', '<C-w>k', { desc = 'Move one split up' })
keymap.nnoremap('<C-l>', '<C-w>l', { desc = 'Move one split right' })
keymap.nnoremap('<leader>wq', '<C-w>q', { desc = 'Close split' })
keymap.nnoremap('<leader>wv', ':vertical split<CR>', { desc = 'New vertical split' })
keymap.nnoremap('<leader>wh', ':split<CR>', { desc = 'New horizontal split' })

-- Tabs
keymap.nnoremap('<leader>tn', ':tab split<CR>', { desc = 'New tab' })
keymap.nnoremap('<leader>tq', ':tabclose<CR>', { desc = 'Close current tab' })
keymap.nnoremap('<leader>tQ', ':tabonly<CR>', { desc = 'Close all other tabs' })
keymap.nnoremap('<leader>t]', ':tabn<CR>', { desc = 'Next tab' })
keymap.nnoremap('<leader>t[', ':tabp<CR>', { desc = 'Previous tab' })
keymap.nnoremap('<leader>tl', ':tabs<CR>', { desc = 'List tabs' })

keymap.tnoremap('<C-]>', [[<C-\><C-n>]], { desc = 'Goto insert mode in terminal' })

create_command('SelectAll', [[normal! gg0VG$]], { desc = 'Select all buffer content' })
create_command('CopyAll', [[normal! gg0VG$"+y]], { desc = 'Copy all buffer content' })

keymap.vnoremap('<C-y>', [["+y]], { desc = 'Copy selection to clipboard' })
keymap.nnoremap('V', 'v$', { desc = 'Select to line end' })
keymap.nnoremap('J', [[mzJ`z]], { desc = 'Join line does not go one down' })

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

keymap.nnoremap('<CR>', ':nohlsearch<CR><CR>', { desc = 'Unsets the last search pattern register by hitting return' })

-- Word traversing
keymap.inoremap('<C-b>', [[<C-o>b]])
keymap.inoremap('<C-e>', [[<C-o>e]])
keymap.inoremap('<C-w>', [[<C-o>w]])
keymap.inoremap('<C-h>', [[<C-o>h]])
keymap.inoremap('<C-j>', [[<C-o>j]])
keymap.inoremap('<C-k>', [[<C-o>k]])
keymap.inoremap('<C-l>', [[<C-o>l]])

-- Special paste
keymap.vnoremap('<leader>p', [["_dp]], { desc = "Paste after without overriding the current register's content" })
keymap.vnoremap('<leader>P', [["_dP]], { desc = "Paste before without overriding the current register's content" })

keymap.nnoremap('<leader>cd', [[:cd %:p:h<CR>:pwd<CR>]], { desc = 'Switch CWD to the directory of the open buffer' })

-- Undo
keymap.nnoremap('U', '<C-r>')

create_command('CopyCursorLocation', function()
	local cursor_location = vim.fn.expand('%', nil, nil) .. ':' .. vim.fn.line('.') .. ':' .. vim.fn.col('.')
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
keymap.nnoremap('<leader>dY', function()
	vim.diagnostic.enable()
end, { desc = 'Enable diagnostics for all buffers' })
keymap.nnoremap('<leader>dN', function()
	vim.diagnostic.disable()
end, { desc = 'Disable diagnostics for all buffers' })
