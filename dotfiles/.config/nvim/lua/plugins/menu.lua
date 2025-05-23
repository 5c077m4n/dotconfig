---@module 'lazy'
---@type LazyPluginSpec
return {
	"nvzone/menu",
	dependencies = {
		{ "nvzone/volt", lazy = true },
	},
	event = { "VeryLazy" },
	lazy = true,
	config = function()
		local menu = require("menu")
		local menu_utils = require("menu.utils")

		vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
			menu_utils.delete_old_menus()
			vim.cmd.exec('"normal! \\<RightMouse>"')

			local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
			local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

			menu.open(options, { mouse = true })
		end, {})
	end,
}
