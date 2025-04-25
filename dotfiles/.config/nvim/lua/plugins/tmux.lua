local utils = require("vimrc.utils")

local keymap = utils.keymapping

return {
	"aserowy/tmux.nvim",
	event = { "VeryLazy" },
	config = function()
		local tmux = require("tmux")

		tmux.setup({
			resize = { enable_default_keybindings = false },
			navigation = { enable_default_keybindings = false },
		})

		keymap.nnoremap(
			"<C-h>",
			tmux.move_left,
			{ desc = "Move to split on the left (handling tmux)" }
		)
		keymap.nnoremap(
			"<C-j>",
			tmux.move_bottom,
			{ desc = "Move to split on the bottom (handling tmux)" }
		)
		keymap.nnoremap(
			"<C-k>",
			tmux.move_top,
			{ desc = "Move to split on the top (handling tmux)" }
		)
		keymap.nnoremap(
			"<C-l>",
			tmux.move_right,
			{ desc = "Move to split on the right (handling tmux)" }
		)
	end,
}
