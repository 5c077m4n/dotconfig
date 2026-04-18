---@module 'lazy'
---@type LazyPluginSpec
return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{
			"mason-org/mason.nvim",
			event = { "VeryLazy" },
			build = function() vim.cmd.MasonUpdate() end,
			config = function() require("mason").setup({ ui = { border = "single" } }) end,
		},
	},
	event = { "VeryLazy" },
	config = function()
		local lsp_config = require("vimrc.lsp")

		---@type string[]
		local mason_supported_servers = vim.iter(lsp_config.SERVER_LIST)
			:filter(
				function(server)
					return server ~= "gleam"
						and server ~= "fish_lsp"
						and server ~= "swift"
						and server ~= "nil_ls"
						and server ~= "terraform_ls"
				end
			)
			:totable()
		require("mason-lspconfig").setup({
			PATH = "append",
			automatic_installation = true,
			automatic_enable = false,
			ensure_installed = mason_supported_servers,
		})
	end,
}
