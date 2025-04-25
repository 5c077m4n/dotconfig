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
		local original_server_list = require("vimrc.lsp-servers").SERVER_LIST
		local server_list = vim.tbl_filter(
			function(server) return server ~= "gleam" end,
			original_server_list
		)

		require("mason-lspconfig").setup({
			ensure_installed = server_list,
			automatic_installation = true,
		})
	end,
}
