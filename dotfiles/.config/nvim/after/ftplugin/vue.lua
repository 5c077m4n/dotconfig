local buffer_num = vim.api.nvim_get_current_buf()
local group =
	vim.api.nvim_create_augroup("restart_lsp_on_vue_enter_" .. buffer_num, { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	buffer = buffer_num,
	group = group,
	callback = function(args)
		local names = vim.iter(vim.lsp.get_clients({ bufnr = args.buf }))
			:map(function(client) return client.name end)
			:totable()
		if #names > 0 then vim.cmd.lsp("restart " .. table.concat(names, " ")) end
	end,
	desc = "Restart LSP clients attached to Vue buffers on enter",
})
