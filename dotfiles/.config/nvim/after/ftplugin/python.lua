local o = vim.opt_local
local cmd = vim.cmd

-- use pep8 standards
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

-- folds based on indentation https://neovim.io/doc/user/fold.html#fold-indent
-- if you are a heavy user of folds, consider using `nvim-ufo`
o.foldmethod = "indent"

-- automatically capitalize boolean values. Useful if you come from a
-- different language, and lowercase them out of habit.
cmd.inoreabbrev("<buffer> true True")
cmd.inoreabbrev("<buffer> false False")

-- in the same way, we can fix habits regarding comments or None
cmd.inoreabbrev("<buffer> -- #")
cmd.inoreabbrev("<buffer> // #")
cmd.inoreabbrev("<buffer> null None")
cmd.inoreabbrev("<buffer> none None")
cmd.inoreabbrev("<buffer> nil None")
