local telescope_builtin = require("telescope.builtin")

local utils = require("vimrc.utils")

local keymap = utils.keymapping
local is_git_repo = utils.misc.is_git_repo

keymap.nnoremap("<leader>fls", function()
	if is_git_repo() then
		telescope_builtin.git_files()
	else
		telescope_builtin.find_files()
	end
end, { desc = "Find project files" })
keymap.nnoremap("<C-p>", function()
	telescope_builtin.find_files({ cwd = vim.fn.getcwd() })
end, { desc = "Find project files (from current work directory)" })
keymap.nnoremap("<leader>fs", function()
	telescope_builtin.live_grep({ cwd = vim.fn.getcwd() })
end, { desc = "Search project for a string (from current work directory)" })
keymap.nnoremap(
	"<leader>f#",
	telescope_builtin.grep_string,
	{ desc = "Search project for the word under the cursor" }
)
keymap.nnoremap("<leader>f:", telescope_builtin.commands, { desc = "Search commands" })
keymap.nnoremap("<leader>fr", telescope_builtin.registers, { desc = "Search registers" })
keymap.inoremap("<C-r>", telescope_builtin.registers, { desc = "Search registers" })
keymap.nnoremap("<leader>fb", telescope_builtin.buffers, { desc = "Search buffers" })
keymap.nnoremap("<leader>fm", telescope_builtin.marks, { desc = "Search bookmarks" })
keymap.nnoremap("<leader>fh", telescope_builtin.help_tags, { desc = "Search vim helpdocs" })
keymap.nnoremap("<leader>fd", telescope_builtin.diagnostics, { desc = "Search diagnostics" })
keymap.nnoremap("<leader>fo", function()
	telescope_builtin.oldfiles({ only_cwd = true })
end, { desc = "Search recently opened files" })
keymap.nnoremap(
	"<leader>fc",
	telescope_builtin.git_commits,
	{ desc = "Search through git commits" }
)
keymap.nnoremap(
	"<leader>ffc",
	telescope_builtin.git_bcommits,
	{ desc = "Search through the current file's git commits" }
)
keymap.nnoremap(
	"<leader>ffs",
	telescope_builtin.current_buffer_fuzzy_find,
	{ desc = "Current file fuzzy finder" }
)
keymap.nnoremap(
	"<leader>ffy",
	telescope_builtin.lsp_document_symbols,
	{ desc = "Current file's LSP symbols" }
)
keymap.nnoremap("<leader>fft", telescope_builtin.filetypes, { desc = "Change filetype" })
