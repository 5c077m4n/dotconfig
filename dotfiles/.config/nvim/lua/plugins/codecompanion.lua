---@module 'lazy'
---@type LazyPluginSpec
return {
	"olimorris/codecompanion.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
	event = { "VeryLazy" },
	config = function()
		require("codecompanion").setup({
			adapters = {
				deepseek_r1_small = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "deepseek-r1:1.5b",
						schema = {
							model = { default = "deepseek-r1:1.5b" },
							num_ctx = { default = 16384 },
							num_predict = { default = -1 },
						},
					})
				end,
				qwen_coder_small = function()
					return require("codecompanion.adapters").extend("ollama", {
						name = "qwen2.5-coder:1.5b",
						schema = {
							model = { default = "qwen2.5-coder:1.5b" },
							num_ctx = { default = 16384 },
							num_predict = { default = -1 },
						},
					})
				end,
			},
			strategies = {
				chat = { adapter = "anthropic" },
				inline = { adapter = "anthropic" },
				cmd = { adapter = "anthropic" },
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
