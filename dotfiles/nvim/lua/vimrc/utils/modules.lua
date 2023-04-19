local utils = require('vimrc.utils')

local M = {}

function M.reload_vimrc()
	require('plenary.reload').reload_module('vimrc')
	require('vimrc')
	require('packer').compile()

	vim.notify('The vimrc has been reloaded successfully', vim.lsp.log_levels.INFO)
end

function M.update_vimrc()
	utils.async_cmd({ 'git', '-C', vim.env.HOME .. '/.config/nvim', 'pull', '--force', 'origin', 'master' })
end

function M.yarn_global_install(pkg_name_list)
	utils.async_cmd({ 'yarn', 'global', 'add', unpack(pkg_name_list) })
end

function M.is_plugin_loaded(pkg_name)
	---@diagnostic disable-next-line: undefined-global
	return packer_plugins and packer_plugins[pkg_name] and packer_plugins[pkg_name].loaded
end

return M
