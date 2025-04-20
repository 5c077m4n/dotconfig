local blink_cmp = require("blink.cmp")

---@param options? table
---@return table
local function make_config(options)
	local cmp_capabilities = blink_cmp.get_lsp_capabilities()

	local merged_capabilities = vim.tbl_deep_extend("force", cmp_capabilities, {
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
		capabilities = merged_capabilities,
		flags = { debounce_text_changes = 400 },
	}
	if type(options) == "table" then
		base_config = vim.tbl_deep_extend("force", base_config, options)
	end
	return base_config
end

---@type table<string, fun(): table | nil>
local SERVER_CONFIG_MAP = {
	ts_ls = function()
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
			root_dir = lspconfig.util.root_pattern("tailwind.config.js", "tailwind.config.ts"),
		})
	end,
	denols = function()
		local lspconfig = require("lspconfig")

		vim.g.markdown_fenced_languages = { "ts=typescript" }
		return make_config({
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
		})
	end,
	biome = function()
		local lspconfig = require("lspconfig")

		return make_config({
			root_dir = lspconfig.util.root_pattern("biome.json", "biome.jsonc"),
		})
	end,
	bashls = function()
		return make_config()
	end,
	lua_ls = function()
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
					hint = {
						enable = true,
						arrayIndex = "Enable",
						setType = true,
					},
				},
			},
		})
	end,
	ruff = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)

				if client and client.name == "ruff" then
					-- Disable hover in favor of Pyright
					client.server_capabilities.hoverProvider = false
				end
			end,
			desc = "LSP: Disable hover capability from Ruff",
		})

		return make_config()
	end,
	pyright = function()
		return make_config({
			settings = {
				python = {
					analysis = { ignore = { "*" } },
				},
			},
		})
	end,
	rust_analyzer = function()
		return make_config({
			settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = { group = "module" },
						prefix = "self",
					},
					cargo = {
						buildScripts = { enable = true },
					},
					procMacro = { enable = true },
				},
			},
		})
	end,
	gopls = function()
		return make_config({
			settings = {
				gopls = {
					analyses = { undparams = true },
					staticcheck = true,
				},
			},
		})
	end,
	golangci_lint_ls = function()
		return make_config({ filetypes = { "go", "gomod" } })
	end,
	nil_ls = function()
		if vim.fn.executable("nix") == 1 then
			return make_config({
				settings = {
					["nil"] = {
						nix = {
							flake = { autoArchive = true },
						},
					},
				},
			})
		end
	end,
	jsonls = function()
		local schemastore = require("schemastore")

		return make_config({
			settings = {
				json = {
					schemas = schemastore.json.schemas(),
					validate = { enable = true },
				},
			},
		})
	end,
	yamlls = function()
		local schemastore = require("schemastore")

		return make_config({
			settings = {
				yaml = {
					schemaStore = {
						-- You must disable built-in schemaStore support if you want to use
						-- this plugin and its advanced options like `ignore`.
						enable = false,
						-- Avoid "TypeError: Cannot read properties of undefined (reading 'length')"
						url = "",
					},
					schemas = schemastore.yaml.schemas(),
				},
			},
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
	gleam = function()
		return make_config()
	end,
	svelte = function()
		return make_config()
	end,
}

return {
	-- This hack is needed untill Mason will add `gleam` to its registery
	SERVER_LIST = vim.tbl_filter(function(server)
		return server ~= "gleam"
	end, vim.tbl_keys(SERVER_CONFIG_MAP)),

	setup = function()
		local lspconfig = require("lspconfig")

		for server, config_fn in pairs(SERVER_CONFIG_MAP) do
			local server_config = config_fn()

			if type(server_config) == "table" then
				lspconfig[server].setup(server_config)
				vim.cmd([[do User LspAttachBuffers]])
			end
		end
	end,
}
