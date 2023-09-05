local M = {}

function M.system_name()
	if vim.fn.has('mac') == 1 then
		return 'macOS'
	elseif vim.fn.has('unix') == 1 then
		return 'Linux'
	elseif vim.fn.has('win32') == 1 then
		return 'Windows'
	end
end

function M.check_back_space()
	local col = vim.fn.col('.') - 1

	if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
		return true
	else
		return false
	end
end

function M.get_termcode(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.clean_extra_spaces()
	vim.cmd([[silent! %s/\s\+$//]])
end

function M.jump_to_last_visited()
	local line = vim.fn.line

	if line([['"]]) > 1 and line([['"]]) < line('$') then
		vim.cmd([[normal! g'"]])
	end
end

return M
