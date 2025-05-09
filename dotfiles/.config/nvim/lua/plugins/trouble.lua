---@module 'lazy'
---@type LazyPluginSpec
return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "VeryLazy" },
	config = function()
		local trouble = require("trouble")
		local keymap = require("vimrc.utils").keymapping

		trouble.setup({
			indent_lines = true,
			signs = { error = "E", warning = "W", hint = "H", information = "I" },
		})

		keymap.nnoremap(
			"<leader>xx",
			function() vim.cmd.Trouble("diagnostics toggle") end,
			{ desc = "Toggle trouble diagnostics" }
		)
		keymap.nnoremap(
			"<leader>xd",
			function() vim.cmd.Trouble("diagnostics toggle filter.buf=0") end,
			{ desc = "Toggle trouble diagnostics for current buffer" }
		)
		keymap.nnoremap(
			"<leader>xl",
			function() vim.cmd.Trouble("lsp toggle") end,
			{ desc = "Toggle LSP definitions & refernces" }
		)
	end,
}
