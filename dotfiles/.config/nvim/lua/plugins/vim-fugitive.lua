---@module 'lazy'
---@type LazyPluginSpec
return {
	"tpope/vim-fugitive",
	event = { "VeryLazy" },
	config = function()
		local keymap = require("vimrc.utils").keymapping

		keymap.nnoremap(
			"<leader>gm",
			function() vim.cmd.Git("mergetool") end,
			{ desc = "Git merge tool" }
		)
		keymap.nnoremap(
			"<leader>gdd",
			function() vim.cmd.Gvdiffsplit({ bang = true }) end,
			{ desc = "Git merge tool split view" }
		)
		keymap.nnoremap(
			"<leader>gdh",
			function() vim.cmd.diffget("//2") end,
			{ desc = "Git merge select left" }
		)
		keymap.nnoremap(
			"<leader>gdl",
			function() vim.cmd.diffget("//3") end,
			{ desc = "Git merge select right" }
		)
		keymap.nnoremap("<leader>gdD", vim.cmd.diffoff, { desc = "Git merge tool off" })
	end,
}
