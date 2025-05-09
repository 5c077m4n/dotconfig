---@module 'lazy'
---@type LazyPluginSpec
return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "v1.*",
	config = function()
		local blink_cmp = require("blink.cmp")

		vim.lsp.config("*", { capabilities = blink_cmp.get_lsp_capabilities() })
		blink_cmp.setup({
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			completion = {
				menu = {
					enabled = true,
					border = "single",
				},
				documentation = {
					auto_show = true,
					window = { border = "single" },
				},
			},
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
			signature = {
				enabled = false,
				window = { border = "single" },
			},
			cmdline = {
				completion = {
					menu = { auto_show = true },
				},
			},
			fuzzy = { implementation = "prefer_rust" },
		})
	end,
	opts_extend = { "sources.default" },
}
