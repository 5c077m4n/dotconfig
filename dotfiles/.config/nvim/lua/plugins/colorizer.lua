---@module 'lazy'
---@type LazyPluginSpec
return {
	"catgoose/nvim-colorizer.lua",
	event = { "VeryLazy" },
	config = function()
		require("colorizer").setup({
			options = {
				display = {
					mode = "virtualtext",
					virtualtext = { position = "eol" },
				},
				parsers = {
					tailwind = {
						enable = false,
						update_names = false,
						lsp = { enable = true, disable_document_color = true },
					},
				},
				debounce_ms = 400,
			},
		})
	end,
}
