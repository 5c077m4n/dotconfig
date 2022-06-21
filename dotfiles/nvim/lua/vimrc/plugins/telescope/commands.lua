local telescope_builtin = require('telescope.builtin')

local keymap = require('vimrc.utils.keymapping')

keymap.nnoremap('<leader>fls', function()
	local opts = {}
	local ok = pcall(telescope_builtin.git_files, opts)
	if not ok then
		telescope_builtin.find_files(opts)
	end
end, { desc = 'Find project files' })
keymap.nnoremap('<leader>fs', telescope_builtin.live_grep, { desc = 'Search project for a string' })
keymap.nnoremap('<leader>f#', telescope_builtin.grep_string, { desc = 'Search project for the word under the cursor' })
keymap.nnoremap('<leader>fb', telescope_builtin.buffers, { desc = 'Search buffers' })
keymap.nnoremap('<leader>fm', telescope_builtin.marks, { desc = 'Search bookmarks' })
keymap.nnoremap('<leader>fo', function()
	telescope_builtin.oldfiles({ only_cwd = true })
end, { desc = 'Search recently opened files' })
keymap.nnoremap('<leader>fc', telescope_builtin.git_commits, { desc = 'Search through git commits' })
keymap.nnoremap(
	'<leader>ffc',
	telescope_builtin.git_bcommits,
	{ desc = "Search through the current file's git commits" }
)
keymap.nnoremap('<leader>ffs', telescope_builtin.current_buffer_fuzzy_find, { desc = 'Current file fuzzy finder' })
keymap.nnoremap('<leader>ffy', telescope_builtin.lsp_document_symbols, { desc = "Current file's LSP symbols" })
keymap.nnoremap('<leader>fft', telescope_builtin.filetypes, { desc = 'Change filetype' })
keymap.nnoremap('<leader>f?', telescope_builtin.commands, { desc = 'Search commands' })
