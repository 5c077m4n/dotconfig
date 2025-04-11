---@param mode string|string[]
local function create_keymap_fn(mode)
	mode = mode or "n"

	---@param buttons string
	---@param command string|function
	---@param options? table
	return function(buttons, command, options)
		local opts = vim.tbl_extend("force", { noremap = true, silent = true }, options or {})
		vim.keymap.set(mode, buttons, command, opts)
	end
end

return {
	nnoremap = create_keymap_fn("n"),
	nvnoremap = create_keymap_fn({ "n", "v" }),
	nvcinoremap = create_keymap_fn({ "n", "v", "c", "i" }),
	vnoremap = create_keymap_fn("v"),
	inoremap = create_keymap_fn("i"),
	tnoremap = create_keymap_fn("t"),
	snoremap = create_keymap_fn("s"),
}
