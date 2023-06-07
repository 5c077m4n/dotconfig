return {
	'folke/which-key.nvim',
	config = function()
		require('which-key').setup({
			plugins = {
				marks = true,
				registers = true,
				spelling = { enabled = false, suggestions = 20 },
			},
		})
	end,
}
