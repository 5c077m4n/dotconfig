return {
	'rcarriga/nvim-notify',
	config = function()
		local notify = require('notify')

		notify.setup({ stages = 'slide', render = 'compact', fps = 60 })
		vim.notify = notify
	end,
}
