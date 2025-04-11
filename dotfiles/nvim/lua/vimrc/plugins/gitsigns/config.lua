require('gitsigns').setup({
	signs = {
		add = {
			hl = 'GitSignsAdd',
			text = '+',
			numhl = 'GitSignsAddNr',
			linehl = 'GitSignsAddLn',
		},
		change = {
			hl = 'GitSignsChange',
			text = '│',
			numhl = 'GitSignsChangeNr',
			linehl = 'GitSignsChangeLn',
		},
		delete = {
			hl = 'GitSignsDelete',
			text = '_',
			numhl = 'GitSignsDeleteNr',
			linehl = 'GitSignsDeleteLn',
		},
		topdelete = {
			hl = 'GitSignsDelete',
			text = '‾',
			numhl = 'GitSignsDeleteNr',
			linehl = 'GitSignsDeleteLn',
		},
		changedelete = {
			hl = 'GitSignsChange',
			text = '~',
			numhl = 'GitSignsChangeNr',
			linehl = 'GitSignsChangeLn',
		},
	},
	watch_gitdir = { interval = 800, follow_files = true },
	update_debounce = 400,
	keymaps = { noremap = false },
})
