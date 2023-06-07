return {
	'jose-elias-alvarez/typescript.nvim',
	requires = { 'neovim/nvim-lspconfig' },
	after = 'nvim-lspconfig',
	config = function()
		require('typescript').setup({
			go_to_source_definition = { fallback = true },
			server = {
				on_attach = require('vimrc.plugins.lspconfig').on_attach,
				root_dir = require('lspconfig').util.root_pattern('package.json', 'package-lock.json', 'tsconfig.json'),
			},
		})
	end,
}
