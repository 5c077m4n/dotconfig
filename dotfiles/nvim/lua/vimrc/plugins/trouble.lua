return {
	'folke/trouble.nvim',
	requires = {
		{ 'nvim-tree/nvim-web-devicons', opt = true },
	},
	config = function()
		vim.cmd.packadd('nvim-web-devicons')

		require('trouble').setup({
			fold_open = 'v',
			fold_closed = '>',
			indent_lines = true,
			signs = { error = 'E', warning = 'W', hint = 'H', information = 'I' },
		})

		local keymap = require('vimrc.utils.keymapping')

		keymap.nnoremap('<leader>xx', vim.cmd.TroubleToggle, { desc = 'Toggle trouble panel' })
		keymap.nnoremap('<leader>xw', function()
			vim.cmd.TroubleToggle('workspace_diagnostics')
		end, { desc = 'Toggle trouble workspace diagnostics' })
		keymap.nnoremap('<leader>xd', function()
			vim.cmd.TroubleToggle('document_diagnostics')
		end, { desc = 'Toggle trouble document diagnostics' })
		keymap.nnoremap('<leader>xq', function()
			vim.cmd.TroubleToggle('quickfix')
		end, { desc = 'Toggle trouble quick fix panel' })
		keymap.nnoremap('<leader>xl', function()
			vim.cmd.TroubleToggle('loclist')
		end, { desc = 'Toggle trouble loclist panel' })
	end,
}
