local M = {}

function M.clean_extra_spaces()
	vim.cmd([[silent! %s/\s\+$//]])
end

function M.jump_to_last_visited()
	local line = vim.fn.line

	if line([['"]]) > 1 and line([['"]]) < line("$") then
		vim.cmd([[normal! g'"]])
	end
end

---@return boolean
function M.is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

---@return string
function M.get_visual_selection()
	---@type number, number, number, number
	local _, line_start, column_start, _ = unpack(vim.fn.getpos("v"))
	---@type number, number, number, number
	local _, line_end, column_end, _ = unpack(vim.fn.getcurpos())

	if line_start > line_end or (line_start == line_end and column_start > column_end) then
		line_start, line_end = line_end, line_start
		column_start, column_end = column_end, column_start
	end

	local selected_lines =
		vim.api.nvim_buf_get_text(0, line_start - 1, column_start - 1, line_end - 1, column_end, {})
	return vim.fn.join(selected_lines, "\\n")
end

return M
