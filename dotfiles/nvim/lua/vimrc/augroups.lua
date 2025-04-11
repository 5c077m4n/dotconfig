local utils = require("vimrc.utils")

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

local autoread_on_buffer_change_id = create_augroup("autoread_on_buffer_change", { clear = true })
create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = autoread_on_buffer_change_id,
	command = "checktime",
	desc = "Re-read file when re-entering it and when idle",
})

local last_read_point_on_file_open_id =
	create_augroup("last_read_point_on_file_open", { clear = true })
create_autocmd({ "BufReadPost" }, {
	group = last_read_point_on_file_open_id,
	callback = utils.misc.jump_to_last_visited,
	desc = "Goto last visited line in file",
})

local highlight_yank_id = create_augroup("highlight_yank", { clear = true })
create_autocmd({ "TextYankPost" }, {
	group = highlight_yank_id,
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
	desc = "Highlight copied text",
})

local delete_trailing_spaces_on_save_id =
	create_augroup("delete_trailing_spaces_on_save", { clear = true })
create_autocmd({ "BufWritePre" }, {
	group = delete_trailing_spaces_on_save_id,
	callback = utils.misc.clean_extra_spaces,
	desc = "Delete trailing whitespaces from line ends on save",
})

local highlight_cursor_line_id = create_augroup("highlight_cursor_line", { clear = true })
create_autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
	group = highlight_cursor_line_id,
	callback = function()
		vim.opt.cursorline = true
	end,
	desc = "Highlight cursor line in buffer",
})
create_autocmd({ "WinLeave" }, {
	group = highlight_cursor_line_id,
	callback = function()
		vim.opt.cursorline = false
	end,
	desc = "Remove highlight cursor line when exiting buffer",
})

local lsp_attach_id = create_augroup("lsp_attach", { clear = true })
create_autocmd({ "LspAttach" }, {
	group = lsp_attach_id,
	callback = function(args)
		local telescope_builtin = require("telescope.builtin")
		local keymap = utils.keymapping

		local lsp = vim.lsp
		local diagnostic = vim.diagnostic

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buffer_num = args.buf

		lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, { border = "single" })
		lsp.handlers["textDocument/signatureHelp"] =
			lsp.with(lsp.handlers.signature_help, { border = "single" })
		---@diagnostic disable-next-line: unused-local, duplicate-set-field
		lsp.handlers["window/showMessage"] = function(_err, method, params, _client_id)
			vim.notify(
				method.message,
				({
					vim.log.levels.ERROR,
					vim.log.levels.WARN,
					vim.log.levels.INFO,
					vim.log.levels.INFO, -- map both hint and info to info
				})[params.type]
			)
		end
		if client.server_capabilities.documentSymbolProvider then
			require("nvim-navic").attach(client, buffer_num)
		end

		keymap.nnoremap(
			"gd",
			telescope_builtin.lsp_definitions,
			{ buffer = buffer_num, desc = "Go to LSP definition" }
		)
		keymap.nnoremap(
			"gD",
			telescope_builtin.lsp_dynamic_workspace_symbols,
			{ buffer = buffer_num, desc = "Go to declaration" }
		)
		keymap.nnoremap(
			"gs",
			telescope_builtin.lsp_document_symbols,
			{ buffer = buffer_num, desc = "Get document symbols" }
		)
		keymap.nnoremap(
			"gS",
			telescope_builtin.lsp_workspace_symbols,
			{ buffer = buffer_num, desc = "Get workspace symbols" }
		)
		keymap.nnoremap("K", lsp.buf.hover, { buffer = buffer_num, desc = "Show docs in hover" })
		keymap.nnoremap(
			"<C-s>",
			lsp.buf.signature_help,
			{ buffer = buffer_num, desc = "Show function signature" }
		)
		keymap.inoremap(
			"<C-s>",
			lsp.buf.signature_help,
			{ buffer = buffer_num, desc = "Show function signature" }
		)
		keymap.nnoremap(
			"gi",
			telescope_builtin.lsp_implementations,
			{ buffer = buffer_num, desc = "Go to implementation" }
		)
		keymap.nnoremap(
			"<leader>gD",
			lsp.buf.type_definition,
			{ buffer = buffer_num, desc = "Go to type definition" }
		)
		keymap.nnoremap("<leader>rn", lsp.buf.rename, { buffer = buffer_num, desc = "LSP rename" })
		keymap.nnoremap(
			"gr",
			telescope_builtin.lsp_references,
			{ buffer = buffer_num, desc = "Find references" }
		)
		keymap.nnoremap("g?", function()
			diagnostic.open_float({ bufnr = buffer_num, scope = "line", border = "single" })
		end, { buffer = buffer_num, desc = "Open diagnostics floating window" })
		keymap.nnoremap("[d", function()
			diagnostic.goto_prev({ float = { border = "single" } })
		end, { buffer = buffer_num, desc = "Go to previous diagnostic" })
		keymap.nnoremap("]d", function()
			diagnostic.goto_next({ float = { border = "single" } })
		end, { buffer = buffer_num, desc = "Go to next diagnostic" })
		keymap.nnoremap("[e", function()
			diagnostic.goto_prev({
				severity = vim.diagnostic.severity.ERROR,
				float = { border = "single" },
			})
		end, { buffer = buffer_num, desc = "Go to previous diagnostic error" })
		keymap.nnoremap("]e", function()
			diagnostic.goto_next({
				severity = vim.diagnostic.severity.ERROR,
				float = { border = "single" },
			})
		end, { buffer = buffer_num, desc = "Go to next diagnostic error" })
		keymap.nvnoremap(
			"<leader>ca",
			lsp.buf.code_action,
			{ buffer = buffer_num, desc = "Code action" }
		)
		keymap.nvnoremap("<leader>l", function()
			vim.lsp.buf.format({
				filter = function(formatter)
					return formatter.name == "null-ls"
				end,
				bufnr = buffer_num,
				async = true,
			})
		end, { buffer = buffer_num, desc = "Format selected page/range" })

		vim.notify(
			client.name .. " LSP server connected successfully (buffer #" .. buffer_num .. ")",
			vim.log.levels.INFO,
			{ timeout = 1000, title = "LSP" }
		)
	end,
	desc = "Setup LSP config on attach",
})
