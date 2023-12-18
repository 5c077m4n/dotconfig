require('vimrc.options')
require('vimrc.filetypes')
require('vimrc.mappings')
require('vimrc.augroups')

if not vim.g.vscode then
	vim.loader.enable()

	require('vimrc.plugins').setup()
	require('vimrc.utils').signals.handle_usr1()
end
