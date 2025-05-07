vim.loader.enable()

require("vimrc.options")
require("vimrc.mappings")
require("vimrc.augroups")
require("vimrc.plugins").setup()
require("vimrc.lsp").setup()
require("vimrc.utils").signals.handle_usr1()
