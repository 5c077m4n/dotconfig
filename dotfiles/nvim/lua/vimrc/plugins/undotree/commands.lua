local keymap = require('vimrc.utils.keymapping')

keymap.nnoremap({ 'silent' }, '<leader>u', ':UndotreeToggle<CR>')
