local keymap = require('vimrc.utils.keymapping')
local g = vim.g

keymap.nnoremap('<leader>rr', ':Ranger<CR>')

g.ranger_map_keys = 0
g.ranger_command_override = [[ranger --cmd "set show_hidden=true"]]
