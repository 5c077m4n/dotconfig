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
		flags = { debounce_text_changes = 400 },
	}
	if type(options) == "table" then
		base_config = vim.tbl_extend("force", base_config, options)
	end
	return base_config
end

---@type table<string, fun(): table | nil>
local SERVER_CONFIG_MAP = {
	tsserver = function() end,
	rust_analyzer = function() end,
	gopls = function() end,
	jdtls = function() end,
	denols = function()
		local lspconfig = require("lspconfig")

		vim.g.markdown_fenced_languages = { "ts=typescript" }
		return make_config({
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
		})
	end,
	bashls = function()
		return make_config()
	end,
	lua_ls = function()
		require("neodev").setup({})

		return make_config({
			settings = {
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
			},
		})
	end,
	jsonls = function()
		return make_config()
	end,
	yamlls = function()
		return make_config()
	end,
	cssls = function()
		return make_config()
	end,
	html = function()
		return make_config()
	end,
	tailwindcss = function()
		local lspconfig = require("lspconfig")

		return make_config({
			filetypes = { "javascriptreact", "typescriptreact", "html" },
			root_dir = lspconfig.util.root_pattern("tailwind.config.js"),
		})
	end,
	marksman = function()
		return make_config()
	end,
	sqlls = function()
		return make_config()
	end,
	taplo = function()
		return make_config()
	end,
	dockerls = function()
		return make_config()
	end,
	zls = function()
		return make_config()
	end,
	pyright = function()
		return make_config()
	end,
}

return {
	SERVER_LIST = vim.tbl_keys(SERVER_CONFIG_MAP),
	setup = function()
		local neoconf = require("neoconf")
		local lspconfig = require("lspconfig")

		neoconf.setup({})

		for server, config_fn in pairs(SERVER_CONFIG_MAP) do
			local server_config = config_fn()

			if type(server_config) == "table" then
				lspconfig[server].setup(server_config)
				vim.cmd([[do User LspAttachBuffers]])
			end
		end
	end,
}
