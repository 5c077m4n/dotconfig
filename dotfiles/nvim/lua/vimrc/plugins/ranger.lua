return {
	'francoiscabrol/ranger.vim',
	event = { 'CursorHold', 'CursorHoldI' },
	requires = 'rbgrouleff/bclose.vim',
	config = function()
		local keymap = require('vimrc.utils.keymapping')

		keymap.nnoremap('<leader>rr', vim.cmd.Ranger, { desc = 'Open ranger file browser' })
	end,
}
