local reload = require('plenary.reload')
local Job = require('plenary.job')
local packer = require('packer')

local M = {}

function M.reload_vimrc()
	reload.reload_module('vimrc')
	vim.cmd.source(vim.env.MYVIMRC)

	vim.loader.reset()
	packer.compile()

	vim.notify('VIMRC has been reloaded successfully', vim.lsp.log_levels.INFO)
end

function M.update_vimrc()
	Job:new({
		command = 'git',
		args = { 'pull', '--force', 'origin', 'master' },
		cwd = vim.fn.stdpath('config'),
		on_exit = function(j, status_code)
			if status_code == 0 then
				vim.notify(j:result(), vim.log.levels.INFO)
			else
				vim.notify(j:result(), vim.log.levels.ERROR)
			end
		end,
	}):sync()
end

return M
