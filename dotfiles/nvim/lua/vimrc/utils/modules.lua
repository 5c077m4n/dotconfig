local utils = require('vimrc.utils')

local M = {}

function M.reload_vimrc()
	require('packer').compile()
	vim.loader.reset()

	vim.notify('The vimrc has been reloaded successfully', vim.lsp.log_levels.INFO)
end

function M.update_vimrc()
	utils.async_cmd({ 'git', '-C', vim.fn.stdpath('config'), 'pull', '--force', 'origin', 'master' })
end

return M
