local M = {}

function M.check_back_space()
	local col = vim.fn.col(".") - 1
	return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

function M.get_termcode(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.clean_extra_spaces()
	vim.cmd([[silent! %s/\s\+$//]])
end

function M.jump_to_last_visited()
	local line = vim.fn.line

	if line([['"]]) > 1 and line([['"]]) < line("$") then
		vim.cmd([[normal! g'"]])
	end
end

return M
