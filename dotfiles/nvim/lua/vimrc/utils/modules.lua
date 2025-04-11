local reload = require('plenary.reload')
local packer = require('packer')

local utils = require('vimrc.utils')

local M = {}

function M.reload_vimrc()
	reload.reload_module('vimrc')
	vim.cmd.source(vim.env.MYVIMRC)

	vim.loader.reset()
	packer.compile()

	vim.notify('VIMRC has been reloaded successfully', vim.lsp.log_levels.INFO)
end

function M.update_vimrc()
	utils.async_cmd({ 'git', '-C', vim.fn.stdpath('config'), 'pull', '--force', 'origin', 'master' })
end

return M
