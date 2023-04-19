local lspconfig = require('lspconfig')
local lsp_installer = require('mason')
local lsp_installer_config = require('mason-lspconfig')
local cmp_lsp = require('cmp_nvim_lsp')
local neodev = require('neodev')
local navic = require('nvim-navic')
local telescope_builtin = require('telescope.builtin')

local keymap = require('vimrc.utils.keymapping')
local lsp_fns = require('vimrc.utils.lsp')

local SERVER_LIST = {
	'taplo',
	'pylsp',
	'bashls',
	'tsserver',
	'rust_analyzer',
	'html',
	'lua_ls',
	'jsonls',
	'yamlls',
	'eslint',
	'cssls',
	'tailwindcss',
	'marksman',
	'denols',
	'dockerls',
}
local SEVERITY = {
	vim.log.levels.ERROR,
	vim.log.levels.WARN,
	vim.log.levels.INFO,
	vim.log.levels.INFO, -- map both hint and info to info
}

local function on_attach(client, buffer_num)
	local lsp = vim.lsp
	local diagnostic = vim.diagnostic

	if vim.bo.filetype ~= 'lua' then
		vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
	end

	lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'single' })
	lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = 'single' })
	lsp.handlers['$/progress'] = lsp_fns.lsp_progress
	---@diagnostic disable-next-line: unused-local, duplicate-set-field
	lsp.handlers['window/showMessage'] = function(_err, method, params, _client_id)
		vim.notify(method.message, SEVERITY[params.type])
	end
	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, buffer_num)
	end

	keymap.nnoremap('gd', telescope_builtin.lsp_definitions, { buffer = buffer_num, desc = 'Go to LSP definition' })
	keymap.nnoremap(
		'gD',
		telescope_builtin.lsp_dynamic_workspace_symbols,
		{ buffer = buffer_num, desc = 'Go to declaration' }
	)
	keymap.nnoremap(
		'gs',
		telescope_builtin.lsp_document_symbols,
		{ buffer = buffer_num, desc = 'Get document symbols' }
	)
	keymap.nnoremap(
		'gS',
		telescope_builtin.lsp_workspace_symbols,
		{ buffer = buffer_num, desc = 'Get workspace symbols' }
	)
	keymap.nnoremap('K', lsp.buf.hover, { buffer = buffer_num, desc = 'Show docs in hover' })
	keymap.nnoremap('<C-s>', lsp.buf.signature_help, { buffer = buffer_num, desc = 'Show function signature' })
	keymap.inoremap('<C-s>', lsp.buf.signature_help, { buffer = buffer_num, desc = 'Show function signature' })
	keymap.nnoremap('gi', telescope_builtin.lsp_implementations, { buffer = buffer_num, desc = 'Go to implementation' })
	keymap.nnoremap('<leader>gD', lsp.buf.type_definition, { buffer = buffer_num, desc = 'Go to type definition' })
	keymap.nnoremap('<leader>rn', lsp.buf.rename, { buffer = buffer_num, desc = 'LSP rename' })
	keymap.nnoremap('gr', telescope_builtin.lsp_references, { buffer = buffer_num, desc = 'Find references' })
	keymap.nnoremap('g?', function()
		diagnostic.open_float({ bufnr = buffer_num, scope = 'line', border = 'single' })
	end, { buffer = buffer_num, desc = 'Open diagnostics floating window' })
	keymap.nnoremap('g[', function()
		diagnostic.goto_prev({ float = { border = 'single' } })
	end, { buffer = buffer_num, desc = 'Go to previous diagnostic' })
	keymap.nnoremap('g]', function()
		diagnostic.goto_next({ float = { border = 'single' } })
	end, { buffer = buffer_num, desc = 'Go to next diagnostic' })
	keymap.nvnoremap('<leader>ca', lsp.buf.code_action, { buffer = buffer_num, desc = 'Code action' })
	keymap.nvnoremap('<leader>l', function()
		vim.lsp.buf.format({
			filter = function(formatter)
				return formatter.name == 'null-ls'
			end,
			bufnr = buffer_num,
			async = true,
		})
	end, { buffer = buffer_num, desc = 'Format selected page/range' })
end

---@param options? table
local function make_config(options)
	local capabilities = cmp_lsp.default_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.foldingRange = {
		dynamicRegistration = false,
		lineFoldingOnly = true,
	}

	local base_config = {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = { debounce_text_changes = 100 },
	}
	if type(options) == 'table' then
		base_config = vim.tbl_extend('force', base_config, options)
	end
	return base_config
end

lsp_installer.setup({
	ui = {
		icons = {
			package_installed = 'V',
			package_pending = '>',
			package_uninstalled = 'X',
		},
		border = 'single',
	},
})
lsp_installer_config.setup({
	ensure_installed = SERVER_LIST,
	automatic_installation = true,
})

for _, server in ipairs(SERVER_LIST) do
	local opts = make_config()
	if server == 'lua_ls' then
		neodev.setup({})
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
	elseif server == 'tsserver' then
		opts.root_dir = lspconfig.util.root_pattern('package.json', 'package-lock.json', 'tsconfig.json')
		opts.single_file_support = false
	end

	lspconfig[server].setup(opts)
	vim.cmd([[do User LspAttachBuffers]])
end
