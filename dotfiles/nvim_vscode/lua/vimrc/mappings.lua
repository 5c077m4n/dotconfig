local vscode = require("vscode-neovim")

local nnoremap = require("vimrc.utils").nnoremap
local vnoremap = require("vimrc.utils").vnoremap

-- Splits
--- Traversal
nnoremap("<C-h>", "<C-w>h", { desc = "Move to split on the left" })
nnoremap("<C-j>", "<C-w>j", { desc = "Move to split on the bottom" })
nnoremap("<C-k>", "<C-w>k", { desc = "Move to split on the top" })
nnoremap("<C-l>", "<C-w>l", { desc = "Move to split on the right" })
--- Creating/removing
nnoremap("<leader>wq", "<C-w>q", { desc = "Close current split" })
nnoremap("<leader>wv", function()
	vscode.action("workbench.action.splitEditorRight")
end, { desc = "New vertical split" })
nnoremap("<leader>wh", function()
	vscode.action("workbench.action.splitEditorDown")
end, { desc = "New horizontal split" })

-- Tabs
nnoremap("]t", function()
	vscode.action("workbench.action.quickOpenNavigateNextInEditorPicker")
end, { desc = "Next tab" })
nnoremap("[t", function()
	vscode.action("workbench.action.quickOpenNavigatePreviousInEditorPicker")
end, { desc = "Next tab" })

-- Searching
nnoremap("<leader>fs", function()
	vscode.action("workbench.action.findInFiles")
end, { desc = "Search in workspace" })
nnoremap("<leader>f#", function()
	vscode.action("workbench.action.findInFiles", { args = { query = vim.fn.expand("<cword>") } })
end, { desc = "Find current word in workspace" })

-- Formatting
vnoremap("<leader>l", function()
	vscode.action("editor.action.formatDocument")
end, { desc = "Format page" })
vnoremap("<leader>l", function()
	vscode.action("editor.action.formatSelection")
end, { desc = "Format selection" })
