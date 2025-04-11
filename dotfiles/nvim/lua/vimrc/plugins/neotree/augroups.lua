vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = vim.api.nvim_create_augroup("refresh_neo_tree", { clear = true }),
	callback = function()
		require("neo-tree.sources.filesystem.commands").refresh(
			require("neo-tree.sources.manager").get_state("filesystem")
		)
	end,
	desc = "Refresh `neo-tree.nvim` automatically",
})
