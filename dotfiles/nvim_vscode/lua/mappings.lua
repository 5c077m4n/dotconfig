local vscode = require('vscode-neovim')

-- Formatting
vim.keymap.set('n', '<leader>l', function()
	vscode.action('editor.action.formatDocument')
end, { desc = 'Format page' })
vim.keymap.set('v', '<leader>l', function()
	vscode.call('editor.action.formatSelection')
end)

-- Searching
vim.keymap.set('n', '<leader>f#', function()
	vscode.action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })
end)
vim.keymap.set('n', '<leader>fs', function()
	vscode.action('workbench.action.terminal.searchWorkspace')
end)
