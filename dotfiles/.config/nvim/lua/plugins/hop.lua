local utils = require("vimrc.utils")

local keymap = utils.keymapping

return {
	"phaazon/hop.nvim",
	event = { "FocusGained", "BufEnter" },
	config = function()
		local hop = require("hop")

		hop.setup({ keys = "etovxqpdygfblzhckisuran" })
		keymap.nvnoremap("<C-f>", hop.hint_words)
	end,
}
