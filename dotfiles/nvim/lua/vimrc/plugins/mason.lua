return {
	'williamboman/mason.nvim',
	run = function()
		vim.cmd.MasonUpdate()
	end,
	config = function()
		require('mason').setup({
			ui = { border = 'single' },
		})
	end,
}
