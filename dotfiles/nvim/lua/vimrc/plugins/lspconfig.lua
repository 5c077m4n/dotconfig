local cmp_lsp = require('cmp_nvim_lsp')

local SERVER_LIST = {
	'taplo',
	'pylsp',
	'bashls',
	'html',
	'lua_ls',
	'jsonls',
	'yamlls',
	'cssls',
	'tailwindcss',
	'marksman',
	'denols',
	'dockerls',
	'zls',
}

---@param options? table
local function make_config(options)
	local capabilities = cmp_lsp.default_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	local base_config = {
		capabilities = capabilities,
		flags = { debounce_text_changes = 100 },
	}
	if type(options) == 'table' then
		base_config = vim.tbl_extend('force', base_config, options)
	end
	return base_config
end

return {
	SERVER_LIST = SERVER_LIST,
	setup = function()
		local lspconfig = require('lspconfig')

		for _, server in ipairs(SERVER_LIST) do
			local opts = make_config()

			if server == 'lua_ls' then
				require('neodev').setup({})

				opts.settings = {
					Lua = {
						completion = { callSnippet = 'Replace' },
						telemetry = { enable = false },
						workspace = {
							checkThirdParty = false,
							library = '${3rd}/luv/library',
						},
						diagnostics = {
							globals = { 'vim', 'string' },
						},
					},
				}
			elseif server == 'tailwindcss' then
				opts.filetypes = { 'javascriptreact', 'javascript.jsx', 'typescriptreact', 'typescript.tsx', 'html' }
				opts.root_dir = lspconfig.util.root_pattern('tailwind.config.js')
			elseif server == 'denols' then
				vim.g.markdown_fenced_languages = { 'ts=typescript' }
				opts.root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc', 'deno.lock')
			end

			lspconfig[server].setup(opts)
			vim.cmd([[do User LspAttachBuffers]])
		end
	end,
}
