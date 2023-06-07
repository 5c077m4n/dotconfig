return {
	'kylechui/nvim-surround',
	event = 'InsertEnter',
	tag = '*',
	config = function()
		require('nvim-surround').setup({})
	end,
}
