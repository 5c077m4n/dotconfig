local keymap = require("vimrc.utils").keymapping

keymap.nnoremap("<leader>tf", vim.cmd.Neotree)
keymap.nnoremap("<leader>tt", function()
	vim.cmd.Neotree("toggle")
end)
