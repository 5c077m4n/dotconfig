---@module 'lazy'
---@type LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	event = { "VeryLazy" },
	config = function()
		local cc = require("codecompanion")
		local cc_adapters = require("codecompanion.adapters")

		cc.setup({
			adapters = {
				deepseek_r1_small = function()
					local name = "deepseek-r1:1.5b"

					return cc_adapters.extend("ollama", {
						name = name,
						schema = {
							model = { default = name },
							num_ctx = { default = 16384 },
							num_predict = { default = -1 },
						},
					})
				end,
				qwen_coder_small = function()
					local name = "qwen2.5-coder:1.5b"

					return cc_adapters.extend("ollama", {
						name = name,
						schema = {
							model = { default = name },
							num_ctx = { default = 16384 },
							num_predict = { default = -1 },
						},
					})
				end,
			},
			strategies = {
				chat = { adapter = "deepseek_r1_small" },
				inline = { adapter = "deepseek_r1_small" },
				cmd = { adapter = "deepseek_r1_small" },
			},
			display = {
				chat = { show_settings = true },
				inline = {
					---@type "vertical" | "horizontal" | "buffer"
					layout = "buffer",
				},
			},
		})
	end,
}
