local M = {}

local function create_keymap_fn(mode)
	mode = mode or 'n'

	return function(lhs, rhs, options)
		local opts = vim.tbl_extend('force', { noremap = true, silent = true }, options or {})
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

M.nnoremap = create_keymap_fn('n')
M.nvnoremap = create_keymap_fn({ 'n', 'v' })
M.vnoremap = create_keymap_fn('v')
M.inoremap = create_keymap_fn('i')
M.tnoremap = create_keymap_fn('t')
M.snoremap = create_keymap_fn('s')

return M
