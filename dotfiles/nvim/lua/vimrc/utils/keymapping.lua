local M = {}

local function create_keymap_fn(mode)
	mode = mode or 'n'

	return function(lhs, rhs, options)
		options = options or {}
		options.noremap = true
		if options.silent == nil then
			options.silent = true
		end

		vim.keymap.set(mode, lhs, rhs, options)
	end
end

M.nnoremap = create_keymap_fn('n')
M.nvnoremap = create_keymap_fn({ 'n', 'v' })
M.vnoremap = create_keymap_fn('v')
M.inoremap = create_keymap_fn('i')
M.tnoremap = create_keymap_fn('t')
M.snoremap = create_keymap_fn('s')

return M
