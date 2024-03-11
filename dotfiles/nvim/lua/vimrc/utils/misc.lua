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

function M.is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	return vim.v.shell_error == 0
end

return M
