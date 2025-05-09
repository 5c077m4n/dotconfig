return {
	"phaazon/hop.nvim",
	event = { "FocusGained", "BufEnter" },
	config = function()
		local hop = require("hop")
		local keymap = require("vimrc.utils").keymapping

		hop.setup({ keys = "etovxqpdygfblzhckisuran" })
		keymap.nvnoremap("<C-f>", hop.hint_words)
	end,
}
