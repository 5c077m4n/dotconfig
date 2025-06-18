local function setup()
	vim.o.foldenable = true
	vim.o.foldlevelstart = 10
	vim.o.foldlevel = 99
	vim.o.foldmethod = "expr"
	vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.o.foldtext = ""
	vim.opt.foldcolumn = "0"

	local fold_group_id =
		vim.api.nvim_create_augroup("change_fold_expr_if_lsp_support", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = fold_group_id,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client:supports_method("textDocument/foldingRange") then
				local win = vim.api.nvim_get_current_win()
				vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
			end
		end,
	})
	vim.api.nvim_create_autocmd("LspDetach", {
		group = fold_group_id,
		command = "setl foldexpr<",
	})
end

return { setup = setup }
