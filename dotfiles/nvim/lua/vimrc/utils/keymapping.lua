local M = {}

---@param mode string|table
local function create_keymap_fn(mode)
	mode = mode or 'n'

	---@param buttons string
	---@param command string|function
	---@param options table|nil
	return function(buttons, command, options)
		local opts = vim.tbl_extend('force', { noremap = true, silent = true }, options or {})
		vim.keymap.set(mode, buttons, command, opts)
	end
end

M.nnoremap = create_keymap_fn('n')
M.nvnoremap = create_keymap_fn({ 'n', 'v' })
M.vnoremap = create_keymap_fn('v')
M.inoremap = create_keymap_fn('i')
M.tnoremap = create_keymap_fn('t')
M.snoremap = create_keymap_fn('s')

return M
