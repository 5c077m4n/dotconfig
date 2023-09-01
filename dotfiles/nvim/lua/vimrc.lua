vim.loader.enable()

require('vimrc.options')
require('vimrc.filetypes')
require('vimrc.mappings')
require('vimrc.augroups')
require('vimrc.plugins').setup()
