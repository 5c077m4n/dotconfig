return {
	'windwp/nvim-ts-autotag',
	event = 'InsertEnter',
	config = function()
		require('nvim-ts-autotag').setup({
			filetypes = {
				'html',
				'javascript',
				'javascript.tsx',
				'typescript',
				'typescript.tsx',
				'javascriptreact',
				'typescriptreact',
				'markdown',
			},
		})
	end,
}
