local utils = require("vimrc.utils")

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd
local vim_log_levels = vim.log.levels

---@type number[]
local LOG_LEVELS = {
	vim_log_levels.ERROR,
	vim_log_levels.WARN,
	vim_log_levels.INFO,
	vim_log_levels.INFO, -- map both hint and info to info
}

create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = create_augroup("autoread_on_buffer_change", { clear = true }),
	command = "checktime",
	desc = "Re-read file when re-entering and idle",
})

create_autocmd({ "BufReadPost" }, {
	group = create_augroup("last_read_point_on_file_open", { clear = true }),
	callback = utils.misc.jump_to_last_visited,
	desc = "Goto last visited line in file",
})

create_autocmd({ "TextYankPost" }, {
	group = create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
	desc = "Highlight copied text",
})

create_autocmd({ "BufWritePre" }, {
	group = create_augroup("delete_trailing_spaces_on_save", { clear = true }),
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

create_autocmd({ "LspAttach" }, {
	group = create_augroup("lsp_attach", { clear = true }),
	callback = function(args)
		local telescope_builtin = require("telescope.builtin")
		local keymap = utils.keymapping

		local lsp = vim.lsp
		local diagnostic = vim.diagnostic

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local buffer_num = args.buf

		lsp.handlers["window/showMessage"] = function(err, result)
			vim.notify(
				result and result.message or "",
				LOG_LEVELS[err and err.code or 3],
				{ title = "LSP Message" }
			)
		end
		if client and client.server_capabilities.documentSymbolProvider then
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
			{ buffer = buffer_num, desc = "Show dynamic workspace symbols" }
		)
		keymap.nnoremap(
			"gs",
			telescope_builtin.lsp_document_symbols,
			{ buffer = buffer_num, desc = "Show document symbols" }
		)
		keymap.nnoremap(
			"gS",
			telescope_builtin.lsp_workspace_symbols,
			{ buffer = buffer_num, desc = "Show workspace symbols" }
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
		keymap.nnoremap("gh", function()
			lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = nil }))
		end, { buffer = buffer_num, desc = "Toggle inlay hints" })
		keymap.nnoremap("g?", function()
			diagnostic.open_float({ bufnr = buffer_num, scope = "line", border = "single" })
		end, { buffer = buffer_num, desc = "Open diagnostics floating window" })
		keymap.nnoremap("[e", function()
			diagnostic.jump({
				count = 1,
				severity = vim.diagnostic.severity.ERROR,
			})
		end, { buffer = buffer_num, desc = "Go to previous diagnostic error in current buffer" })
		keymap.nnoremap("]e", function()
			diagnostic.jump({
				count = -1,
				severity = vim.diagnostic.severity.ERROR,
			})
		end, { buffer = buffer_num, desc = "Go to next diagnostic error in current buffer" })
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

		vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
			local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
			pcall(vim.diagnostic.reset, ns)
			return true
		end

		vim.notify(
			(client and client.name or "Some")
				.. " Connected successfully (buffer #"
				.. buffer_num
				.. ")",
			vim.log.levels.TRACE,
			{ timeout = 400, title = "LSP server connected" }
		)
	end,
	desc = "Setup LSP config on attach",
})

create_autocmd({ "BufReadCmd" }, {
	pattern = { "*.whl" },
	group = create_augroup("open_python_wheel", { clear = true }),
	callback = function()
		vim.fn["zip#Browse"](vim.fn.expand("<amatch>"))
	end,
	desc = "View python `*.whl` files",
})

create_autocmd("TermOpen", {
	group = create_augroup("term_open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		vim.cmd.startinsert()
	end,
	desc = "Make the Nvim terminal feel native",
})
