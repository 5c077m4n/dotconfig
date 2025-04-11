local keymap = require('vimrc.utils.keymapping')

keymap.nnoremap('<leader>xx', '<Cmd>TroubleToggle<CR>')
keymap.nnoremap('<leader>xw', '<Cmd>TroubleToggle lsp_workspace_diagnostics<CR>')
keymap.nnoremap('<leader>xd', '<Cmd>TroubleToggle lsp_document_diagnostics<CR>')
keymap.nnoremap('<leader>xq', '<Cmd>TroubleToggle quickfix<CR>')
keymap.nnoremap('<leader>xl', '<Cmd>TroubleToggle loclist<CR>')
