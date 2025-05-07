return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		{
			"williamboman/mason.nvim",
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
			ensure_installed = mason_supported_servers,
			automatic_installation = true,
		})
	end,
}
