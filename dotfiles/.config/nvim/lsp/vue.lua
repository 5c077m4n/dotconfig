---@type vim.lsp.Config
return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	root_markers = { "package.json" },
	init_options = {
		vue = { hybridMode = true },
	},
	before_init = function()
		local vue_language_server_path = vim.fn.stdpath("data")
			.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

		vim.lsp.config("ts_ls", {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vue_language_server_path,
						languages = { "vue" },
					},
				},
			},
		})
		vim.lsp.enable("ts_ls", true)
	end,
	on_attach = function()
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			once = true,
			group = vim.api.nvim_create_augroup(
				"toggle_semantic_token_provider_full",
				{ clear = true }
			),
			callback = function(args)
				local client = vim.lsp.get_clients({ bufnr = args.buf, name = "ts_ls" })[1]
				if not client then return end

				client.server_capabilities.semanticTokensProvider.full = vim.bo.filetype ~= "vue"
			end,
		})
	end,
}
