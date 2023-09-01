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

function M.async_cmd(command, opts)
	local output = ''
	local notification
	local notify = function(msg, level)
		local notify_opts =
			vim.tbl_extend('keep', opts or {}, { title = table.concat(command, ' '), replace = notification })
		notification = vim.notify(msg, level, notify_opts)
	end
	local on_data = function(_, data)
		output = output .. table.concat(data, '\n')
		notify(output, 'info')
	end
	vim.fn.jobstart(command, {
		on_stdout = on_data,
		on_stderr = on_data,
		on_exit = function(_, code)
			if #output == 0 then
				notify('No output of command, exit code: ' .. code, 'warn')
			end
		end,
	})
end

return M
