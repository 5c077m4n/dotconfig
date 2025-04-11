local lspconfig = require('lspconfig')
local lsp_installer = require('nvim-lsp-installer')
local telescope_builtin = require('telescope.builtin')
local which_key = require('which-key')
local cmp_lsp = require('cmp_nvim_lsp')

local mod_utils = require('vimrc.utils.modules')
local keymap = require('vimrc.utils.keymapping')
local lsp_fns = require('vimrc.utils.lsp')

local SERVER_LIST = {
	'taplo',
	'pylsp',
	'bashls',
	'tsserver',
	'rust_analyzer',
	'html',
	'sumneko_lua',
	'jsonls',
	'yamlls',
	'eslint',
	'cssls',
	'solang',
	'tflint',
	'tailwindcss',
}

local function on_attach(_client, buffer_num)
	local lsp = vim.lsp
	local diagnostic = vim.diagnostic
	local create_command = vim.api.nvim_create_user_command

	vim.api.nvim_buf_set_option(buffer_num, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'single' })
	lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.signature_help, { border = 'single' })
	lsp.handlers['$/progress'] = lsp_fns.lsp_progress

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
	keymap.nnoremap('gi', telescope_builtin.lsp_implementations, { buffer = buffer_num, desc = 'Go to implementation' })
	keymap.nnoremap('<leader>gD', lsp.buf.type_definition, { buffer = buffer_num, desc = 'Go to type definition' })
	keymap.nnoremap('<leader>rn', lsp.buf.rename, { buffer = buffer_num, desc = 'LSP rename' })
	keymap.nnoremap('gr', telescope_builtin.lsp_references, { buffer = buffer_num, desc = 'Find references' })
	keymap.nnoremap('g[', function()
		diagnostic.goto_prev({ popup_opts = { border = 'single' } })
	end, { buffer = buffer_num, desc = 'Go to previous diagnostic' })
	keymap.nnoremap('g]', function()
		diagnostic.goto_next({ popup_opts = { border = 'single' } })
	end, { buffer = buffer_num, desc = 'Go to next diagnostic' })
	keymap.nnoremap('<leader>ca', lsp.buf.code_action, { buffer = buffer_num, desc = 'Code action' })
	keymap.vnoremap('<leader>ca', lsp.buf.range_code_action, { buffer = buffer_num, desc = 'Code action for range' })
	-- TODO: remove legacy `if` when 0.8 is out
	keymap.nnoremap('<leader>l', function()
		if type(lsp.buf.format) == 'function' then
			vim.lsp.buf.format({
				filter = function(client)
					return client.name == 'null-ls'
				end,
				bufnr = buffer_num,
			})
		else
			lsp.buf.formatting({})
		end
	end, { buffer = buffer_num, desc = 'Format page' })
	keymap.vnoremap('<leader>l', lsp.buf.range_formatting, { buffer = buffer_num, desc = 'Format page' })

	create_command('Format', lsp.buf.formatting, { desc = 'Format page' })
	create_command('FormatRange', lsp.buf.range_formatting, { desc = 'Format range' })

	which_key.register({
		gD = 'Declaration',
		gd = 'Definition',
		gh = 'LSP Finder',
		K = 'Show docs',
		gi = 'Show implementations',
		gr = 'Show refs',
		['g]'] = 'Next diagnostics result',
		['g['] = 'Previous diagnostics result',
		['g?'] = 'Show diagnostics result in popup',
		['<leader>rn'] = 'Rename',
		['<leader>l'] = 'Format',
	}, {
		buffer = buffer_num,
		silent = true,
	})
end

local function make_config(options)
	local client_capabilities = vim.lsp.protocol.make_client_capabilities()
	local capabilities = cmp_lsp.update_capabilities(client_capabilities)

	local base_config = {
		on_attach = on_attach,
		capabilities = capabilities,
		flags = { debounce_text_changes = 400 },
	}
	if type(options) == 'table' then
		for key, value in pairs(options) do
			base_config[key] = value
		end
	end
	return base_config
end

local function setup_servers()
	local is_exec = vim.fn.executable
	local cmd = vim.cmd

	lsp_installer.setup({
		ensure_installed = SERVER_LIST,
		automatic_installation = true,
		ui = {
			icons = {
				server_installed = '✓',
				server_pending = '➜',
				server_uninstalled = '✗',
			},
		},
	})

	for _, server in ipairs(SERVER_LIST) do
		local opts
		if server == 'sumneko_lua' then
			opts = require('lua-dev').setup({
				lspconfig = {
					on_attach = on_attach,
					settings = {
						Lua = {
							telemetry = { enable = false },
						},
					},
				},
			})
		else
			opts = make_config()
		end
		lspconfig[server].setup(opts)

		cmd([[do User LspAttachBuffers]])
	end

	if not (is_exec('prettier') and is_exec('eslint_d') and is_exec('diagnostic-languageserver')) then
		mod_utils.yarn_global_install({ 'prettier', 'eslint_d', 'diagnostic-languageserver' })
	end
end

setup_servers()
