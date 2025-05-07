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
		local full_server_list = require("vimrc.lsp").SERVER_LIST
		local mason_supported_servers = vim.tbl_filter(
			function(server) return server ~= "gleam" end,
			full_server_list
		)

		require("mason-lspconfig").setup({
			automatic_installation = true,
			automatic_enable = false,
			ensure_installed = mason_supported_servers,
		})
	end,
}
