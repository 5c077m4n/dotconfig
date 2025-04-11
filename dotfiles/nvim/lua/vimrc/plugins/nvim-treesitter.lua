require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'javascript',
		'typescript',
		'css',
		'html',
		'json',
		'jsdoc',
		'rust',
		'graphql',
		'regex',
		'tsx',
		'python',
		'yaml',
		'lua',
		'bash',
		'vimdoc',
		'git_config',
		'ssh_config',
	},
	ignore_install = {},
	highlight = {
		enable = true,
		disable = {}, -- list of language that will be disabled
	},
})
