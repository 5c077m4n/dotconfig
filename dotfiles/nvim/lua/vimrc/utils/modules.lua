local M = {}

local function unload_background_buffers()
	local buffer_list = vim.fn.getbufinfo()

	for _, buffer in ipairs(buffer_list) do
		if buffer.hidden == 1 and buffer.loaded == 1 and buffer.changed == 0 then
			vim.cmd.bunload(buffer.bufnr)
		end
	end
end

function M.reload_vimrc()
	vim.cmd.source(vim.env.MYVIMRC)
	vim.loader.reset()
	vim.cmd.LspRestart()

	unload_background_buffers()

	vim.notify('Reload successful', vim.lsp.log_levels.INFO, { title = 'VIMRC' })
end

function M.update_vimrc()
	require('plenary.job')
		:new({
			command = 'git',
			args = { 'pull', '--rebase', '--autostash', 'origin', 'master' },
			cwd = vim.fn.stdpath('config'),
			on_exit = function(j, status_code)
				if status_code == 0 then
					vim.notify(j:result(), vim.log.levels.INFO, { title = 'VIMRC Update' })
				else
					vim.notify(j:result(), vim.log.levels.ERROR, { title = 'VIMRC Update' })
				end
			end,
		})
		:sync()
end

return M
