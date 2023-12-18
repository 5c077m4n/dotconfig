local vscode = require('vscode-neovim')

---@param mode string|table
local function create_keymap_fn(mode)
	mode = mode or 'n'

	---@param buttons string
	---@param command string|function
	---@param options table|nil
	return function(buttons, command, options)
		local opts = vim.tbl_extend('force', { remap = true, silent = true }, options or {})
		vim.keymap.set(mode, buttons, command, opts)
	end
end

local nnoremap = create_keymap_fn('n')
local vnoremap = create_keymap_fn('v')

-- Splits
--- Traversal
nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')
--- Creating/removing
nnoremap('<leader>wq', '<C-w>q', { desc = 'Close split' })
nnoremap('<leader>wv', vim.cmd.vsplit, { desc = 'New vertical split' })
nnoremap('<leader>wh', vim.cmd.split, { desc = 'New horizontal split' })

-- Searching
nnoremap('<leader>f#', function()
	vscode.action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })
end)
nnoremap('<leader>fs', function()
	vscode.action('workbench.action.terminal.searchWorkspace')
end)

-- Filetree
nnoremap('<leader>tf', function()
	vscode.action('explorer.openAndPassFocus')
end)

-- Formatting
vnoremap('<leader>l', function()
	vscode.action('editor.action.formatDocument')
end, { desc = 'Format page' })
vnoremap('<leader>l', function()
	vscode.action('editor.action.formatSelection')
end)
