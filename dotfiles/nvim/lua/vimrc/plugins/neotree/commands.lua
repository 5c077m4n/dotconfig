local keymap = require("vimrc.utils").keymapping

keymap.nnoremap("<leader>tf", vim.cmd.Neotree, { desc = "Focus on curren file in `neo-tree`" })
keymap.nnoremap("<leader>tt", function()
	vim.cmd.Neotree("toggle")
end, { desc = "Toggle show of `neo-tree`" })
keymap.nnoremap("<leader>tr", function()
	require("neo-tree.sources.filesystem.commands").refresh(
		require("neo-tree.sources.manager").get_state("filesystem")
	)
end, { desc = "Refresh `neo-tree`" })
