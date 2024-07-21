local o = vim.opt_local

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

-- folds based on indentation https://neovim.io/doc/user/fold.html#fold-indent
-- if you are a heavy user of folds, consider using `nvim-ufo`
o.foldmethod = "indent"
