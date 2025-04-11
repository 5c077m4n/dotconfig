local utils = require('vimrc.utils')

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

local autoread_on_buffer_change_id = create_augroup('autoread_on_buffer_change', { clear = true })
create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
	group = autoread_on_buffer_change_id,
	command = 'checktime',
	desc = 'Re-read file when re-entering it and when idle',
})

local last_read_point_on_file_open_id = create_augroup('last_read_point_on_file_open', { clear = true })
create_autocmd({ 'BufReadPost' }, {
	group = last_read_point_on_file_open_id,
	callback = utils.jump_to_last_visited,
	desc = 'Goto last visited line in file',
})

local highlight_yank_id = create_augroup('highlight_yank', { clear = true })
create_autocmd({ 'TextYankPost' }, {
	group = highlight_yank_id,
	callback = function()
		vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 500 })
	end,
	desc = 'Highlight copied text',
})

local delete_trailing_spaces_on_save_id = create_augroup('delete_trailing_spaces_on_save', { clear = true })
create_autocmd({ 'BufWritePre' }, {
	group = delete_trailing_spaces_on_save_id,
	callback = utils.clean_extra_spaces,
	desc = 'Delete trailing whitespaces from line ends on save',
})

local highlight_cursor_line_id = create_augroup('highlight_cursor_line', { clear = true })
create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
	group = highlight_cursor_line_id,
	callback = function()
		vim.opt.cursorline = true
	end,
	desc = 'Highlight cursor line in buffer',
})
create_autocmd({ 'WinLeave' }, {
	group = highlight_cursor_line_id,
	callback = function()
		vim.opt.cursorline = false
	end,
	desc = 'Remove highlight cursor line when exiting buffer',
})

local packer_compile_on_config_change_id = create_augroup('packer_compile_on_config_change', { clear = true })
create_autocmd({ 'BufWritePost' }, {
	group = packer_compile_on_config_change_id,
	pattern = '*/vimrc/plugins/*.lua',
	callback = function(event)
		vim.notify('"' .. event.file .. '" has changed, so recompiling...', vim.log.levels.INFO, { title = 'VIMRC' })

		require('packer').compile()
		vim.loader.reset()
	end,
	desc = 'Packer compile on plugin config change',
})

local lsp_attach_id = create_augroup('lsp_attach', { clear = true })
create_autocmd({ 'LspAttach' }, {
	group = lsp_attach_id,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.notify(
			client.name .. ' LSP server connected successfully',
			vim.log.levels.INFO,
			{ timeout = 1000, title = 'LSP' }
		)
	end,
	desc = 'Notify on LSP attach',
})
