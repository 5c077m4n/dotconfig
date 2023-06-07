return {
	'onsails/lspkind-nvim',
	config = function()
		require('lspkind').init({ mode = 'text' }) -- Icons in autocomplete popup
	end,
}
