local telescope_builtin = require('telescope.builtin')

local keymap = require('vimrc.utils.keymapping')

keymap.nnoremap('<leader>fls', telescope_builtin.find_files)
keymap.nnoremap('<leader>fgs', telescope_builtin.git_files)
keymap.nnoremap('<leader>fs', telescope_builtin.live_grep)
keymap.nnoremap('<leader>f#', telescope_builtin.grep_string)
keymap.nnoremap('<leader>fb', telescope_builtin.buffers)
keymap.nnoremap('<leader>fm', telescope_builtin.marks)
keymap.nnoremap('<leader>fo', telescope_builtin.oldfiles)
keymap.nnoremap('<leader>fc', telescope_builtin.git_commits)
keymap.nnoremap('<leader>ffc', telescope_builtin.git_bcommits)
keymap.nnoremap('<leader>ffs', telescope_builtin.current_buffer_fuzzy_find)
keymap.nnoremap('<leader>ffy', telescope_builtin.lsp_document_symbols)
keymap.nnoremap('<leader>fft', telescope_builtin.filetypes)
keymap.nnoremap('<leader>f?', telescope_builtin.commands)

require('which-key').register({
	['<leader>f'] = {
		name = 'Fuzzy search',
		f = {
			name = 'Current file search',
			c = 'Commit list',
			t = 'Filetypes',
			S = 'String under cursor',
			y = 'Symbol search',
		},
		ls = 'File list',
		gs = 'Git file list',
		s = 'Live grep',
		b = 'Buffer list',
		o = 'Old files',
		c = 'Git commits',
		m = 'Bookmarks',
		['#'] = 'Search project for current string',
		['?'] = 'Commands',
	},
})
