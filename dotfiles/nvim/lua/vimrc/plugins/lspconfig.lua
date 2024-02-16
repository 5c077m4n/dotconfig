local SERVER_LIST = {
	"pylsp",
	"denols",
	"tsserver",
	"bashls",
	"lua_ls",
	"jsonls",
	"yamlls",
	"cssls",
	"html",
	"tailwindcss",
	"marksman",
	"sqlls",
	"taplo",
	"dockerls",
	"gopls",
	"rust_analyzer",
	"zls",
}

---@param options? table
local function make_config(options)
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	vim.tbl_extend("force", capabilities, {
		textDocument = {
			completion = {
				completionItem = { snippetSupport = true },
			},
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	})

	local base_config = {
		capabilities = capabilities,
		flags = { debounce_text_changes = 100 },
	}
	if type(options) == "table" then
		base_config = vim.tbl_extend("force", base_config, options)
	end
	return base_config
end

return {
	SERVER_LIST = SERVER_LIST,
	setup = function()
		require("neoconf").setup({})
		local lspconfig = require("lspconfig")

		local servers_needing_lsp_setup = vim.tbl_filter(function(server)
			return server ~= "tsserver" and server ~= "rust_analyzer" and server ~= "gopls"
		end, SERVER_LIST)

		for _, server in pairs(servers_needing_lsp_setup) do
			local opts = make_config()

			if server == "lua_ls" then
				require("neodev").setup({})

				opts.settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						telemetry = { enable = false },
						workspace = {
							checkThirdParty = false,
							library = { "${3rd}/luv/library" },
						},
						diagnostics = {
							globals = { "vim", "string" },
						},
					},
				}
			elseif server == "tailwindcss" then
				opts.filetypes = { "javascriptreact", "typescriptreact", "html" }
				opts.root_dir = lspconfig.util.root_pattern("tailwind.config.js")
			elseif server == "denols" then
				vim.g.markdown_fenced_languages = { "ts=typescript" }
				opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock")
			end

			lspconfig[server].setup(opts)
			vim.cmd([[do User LspAttachBuffers]])
		end
	end,
}
