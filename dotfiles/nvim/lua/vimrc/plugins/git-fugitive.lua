local keymap = require('vimrc.utils.keymapping')

-- Git mergetool
keymap.nnoremap('<leader>gs', [[:Gstatus<CR>]])
keymap.nnoremap('<leader>gm', [[:G mergetool<CR>]])
keymap.nnoremap('<leader>gdd', [[:Gvdiffsplit!<CR>]])
keymap.nnoremap('<leader>gdh', [[:diffget //2<CR>]])
keymap.nnoremap('<leader>gdl', [[:diffget //3<CR>]])
keymap.nnoremap('<leader>gdD', [[:diffoff<CR>]])
