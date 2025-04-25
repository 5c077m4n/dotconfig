local utils = require("vimrc.utils")

local keymap = utils.keymapping

return {
	"folke/persistence.nvim",
	event = { "VeryLazy" },
	config = function()
		local persist = require("persistence")

		persist.setup({
			pre_save = function() vim.cmd.Neotree("close") end,
			pre_load = function() vim.cmd.Neotree("close") end,
		})
		keymap.nnoremap(
			"<leader>pr",
			persist.load,
			{ desc = "Restore the session for the current directory" }
		)
		keymap.nnoremap(
			"<leader>pl",
			function() persist.load({ last = true }) end,
			{ desc = "Restore the last session" }
		)
		keymap.nnoremap("<leader>pd", function()
			persist.stop()
			vim.notify("Auto session save disabled")
		end, { desc = "Disable session save on exit" })
	end,
}
