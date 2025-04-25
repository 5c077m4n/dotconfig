return {
	"rcarriga/nvim-notify",
	event = { "VeryLazy" },
	config = function()
		local notify = require("notify")

		notify.setup({ stages = "slide", render = "compact", fps = 60 })
		vim.notify = notify
	end,
}
