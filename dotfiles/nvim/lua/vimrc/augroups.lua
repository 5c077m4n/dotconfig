local utils = require('vimrc.utils')

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

local autoread_on_buffer_change_id = create_augroup('autoread_on_buffer_change', { clear = true })
create_autocmd({ 'FocusGained', 'BufEnter' }, {
	group = autoread_on_buffer_change_id,
	pattern = { '*' },
	command = 'checktime',
	desc = 'Re-read file when re-entering it',
})

local last_read_point_on_file_open_id = create_augroup('last_read_point_on_file_open', { clear = true })
create_autocmd({ 'BufReadPost' }, {
	group = last_read_point_on_file_open_id,
	pattern = { '*' },
	callback = utils.jump_to_last_visited,
	desc = 'Goto last visited line in file',
})

local highlight_yank_id = create_augroup('highlight_yank', { clear = true })
create_autocmd({ 'TextYankPost' }, {
	group = highlight_yank_id,
	pattern = { '*' },
	callback = function()
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
	end,
	desc = 'Highlight copied text',
})

local delete_trailing_spaces_on_save_id = create_augroup('delete_trailing_spaces_on_save', { clear = true })
create_autocmd({ 'BufWritePre' }, {
	group = delete_trailing_spaces_on_save_id,
	pattern = { '*' },
	callback = utils.clean_extra_spaces,
	desc = 'Delete trailing whitespaces from line ends on save',
})

local recompile_on_init_change_id = create_augroup('recompile_on_init_change', { clear = true })
create_autocmd({ 'BufWritePost' }, {
	group = recompile_on_init_change_id,
	pattern = { 'lua/vimrc/plugins/init.lua' },
	command = 'PackerCompile',
	desc = 'Re-create the `packer_compiled.lua` file on plugins change',
})

local highlight_cursor_line_id = create_augroup('highlight_cursor_line', { clear = true })
create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
	group = highlight_cursor_line_id,
	pattern = { '*' },
	command = 'setlocal cursorline',
	desc = 'Highlight cursor line in buffer',
})
create_autocmd({ 'WinLeave' }, {
	group = highlight_cursor_line_id,
	pattern = { '*' },
	command = 'setlocal nocursorline',
	desc = 'Remove highlight cursor line when exiting buffer',
})
