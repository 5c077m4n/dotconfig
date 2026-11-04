local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local telescope_config = require("telescope.config")
local telescope_builtin = require("telescope.builtin")
local trouble_sources_telescope = require("trouble.sources.telescope")

local utils = require("vimrc.utils")

---@param args string[]
---@return string[]|nil
local function git(args)
	local out = vim.fn.systemlist(vim.list_extend({ "git" }, args))
	return vim.v.shell_error == 0 and out or nil
end

---@return string[]|nil
local function branch_changed_files()
	local root = (git({ "rev-parse", "--show-toplevel" }) or {})[1]
	if not root then
		vim.notify("Not a git repository", vim.log.levels.ERROR)
		return nil
	end

	local base_ref = (git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }) or {})[1]
	if not base_ref then
		for _, candidate in ipairs({ "origin/main", "origin/master", "main", "master" }) do
			if git({ "rev-parse", "--verify", "--quiet", candidate }) then
				base_ref = candidate
				break
			end
		end
	end
	local merge_base = base_ref and (git({ "merge-base", "HEAD", base_ref }) or {})[1] or "HEAD"

	---@type string[]
	local files = vim.iter({
		git({ "-C", root, "diff", "--name-only", "--diff-filter=d", merge_base }) or {},
		git({ "-C", root, "ls-files", "--others", "--exclude-standard" }) or {},
	})
		:flatten()
		:filter(function(path) return path ~= "" end)
		:map(function(path) return vim.fs.joinpath(root, path) end)
		:filter(vim.uv.fs_stat)
		:totable()

	if #files == 0 then
		vim.notify("No changed files in current branch", vim.log.levels.INFO)
		return nil
	end
	return files
end

---@class BranchGrepOpts
---@field default_text? string

---@param opts? BranchGrepOpts
---@return nil
local function grep_branch_changed(opts)
	local files = branch_changed_files()
	if not files then return end

	telescope_builtin.live_grep(vim.tbl_extend("force", {
		search_dirs = files,
		prompt_title = "Live Grep (branch changes)",
	}, opts or {}))
end

---@param opts table|nil
---@return nil
local function find_branch_changed(opts)
	local files = branch_changed_files()
	if not files then return end

	telescope_builtin.find_files(vim.tbl_extend("force", {
		prompt_title = "Find Files (branch changes)",
		find_command = vim.list_extend({ "printf", "%s\\n" }, files),
	}, opts or {}))
end

---@return nil
local function config()
	local keymap = utils.keymapping
	local is_git_repo = utils.misc.is_git_repo
	local get_visual_selection = utils.misc.get_visual_selection

	local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
	table.insert(vimgrep_arguments, "--hidden")
	table.insert(vimgrep_arguments, "--glob")
	table.insert(vimgrep_arguments, "!**/.git/*")

	telescope.setup({
		defaults = {
			vimgrep_arguments = vimgrep_arguments,
			mappings = {
				i = {
					["<C-k>"] = telescope_actions.cycle_history_next,
					["<C-j>"] = telescope_actions.cycle_history_prev,
					["<C-h>"] = telescope_actions.select_horizontal,
					["<C-v>"] = telescope_actions.select_vertical,
					["<C-t>"] = telescope_actions.select_tab,
					["<C-x>"] = trouble_sources_telescope.open,
				},
				n = {
					["<C-k>"] = telescope_actions.cycle_history_next,
					["<C-j>"] = telescope_actions.cycle_history_prev,
					["<C-[>"] = telescope_actions.close,
					["<C-h>"] = telescope_actions.select_horizontal,
					["<C-v>"] = telescope_actions.select_vertical,
					["<C-t>"] = telescope_actions.select_tab,
					["<C-x>"] = trouble_sources_telescope.open,
				},
			},
		},
		pickers = {
			find_files = {
				find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			},
		},
		extensions = { fzf = {} },
	})
	telescope.load_extension("fzf")

	keymap.nnoremap("<leader>fls", function()
		if is_git_repo() then
			telescope_builtin.git_files()
		else
			telescope_builtin.find_files()
		end
	end, { desc = "Find project files" })
	keymap.nnoremap(
		"<C-p>",
		function() telescope_builtin.find_files({ cwd = vim.fn.getcwd() }) end,
		{ desc = "Find project files (from current work directory)" }
	)
	keymap.nnoremap(
		"<leader>fs",
		function() telescope_builtin.live_grep({ cwd = vim.fn.getcwd() }) end,
		{ desc = "Search project for a string (from current work directory)" }
	)
	keymap.vnoremap(
		"<leader>fs",
		function() telescope_builtin.grep_string({ cwd = vim.fn.getcwd() }) end,
		{ desc = "Search project for the current selection (from current work directory)" }
	)
	keymap.vnoremap("<C-p>", function()
		local selected_text = get_visual_selection()
		telescope_builtin.find_files({ cwd = vim.fn.getcwd(), default_text = selected_text })
	end, { desc = "Find files named like the selection (from current work directory)" })
	keymap.nnoremap("<leader>f:", telescope_builtin.commands, { desc = "Search commands" })
	keymap.nnoremap(
		"<leader>f;",
		telescope_builtin.command_history,
		{ desc = "Search command history" }
	)
	keymap.nnoremap("<leader>f/", telescope_builtin.search_history, { desc = "Search history" })
	keymap.nnoremap("<leader>fr", telescope_builtin.registers, { desc = "Search registers" })
	keymap.inoremap("<C-r>", telescope_builtin.registers, { desc = "Search registers" })
	keymap.nnoremap("<leader>fb", telescope_builtin.buffers, { desc = "Search buffers" })
	keymap.nnoremap("<leader>fm", telescope_builtin.marks, { desc = "Search bookmarks" })
	keymap.nnoremap("<leader>fh", telescope_builtin.help_tags, { desc = "Search vim helpdocs" })
	keymap.nnoremap("<leader>fd", telescope_builtin.diagnostics, { desc = "Search diagnostics" })
	keymap.nnoremap(
		"<leader>fo",
		function() telescope_builtin.oldfiles({ only_cwd = true }) end,
		{ desc = "Search recently opened files" }
	)
	keymap.nnoremap(
		"<leader>fc",
		telescope_builtin.git_commits,
		{ desc = "Search through git commits" }
	)
	keymap.nnoremap(
		"<leader>fgs",
		telescope_builtin.git_status,
		{ desc = "List git status changes" }
	)
	keymap.nnoremap("<leader>fgb", telescope_builtin.git_branches, { desc = "List git branches" })

	vim.api.nvim_create_user_command(
		"TelescopeBranchGrep",
		---@param cmd vim.api.keyset.create_user_command.command_args
		function(cmd) grep_branch_changed({ default_text = cmd.args ~= "" and cmd.args or nil }) end,
		{ nargs = "?", desc = "Live grep in files changed in the current branch" }
	)
	vim.api.nvim_create_user_command(
		"TelescopeBranchFiles",
		function() find_branch_changed() end,
		{ desc = "Find files changed in the current branch" }
	)
	keymap.nnoremap(
		"<leader>fsc",
		grep_branch_changed,
		{ desc = "Search string in branch-changed files" }
	)
	keymap.vnoremap(
		"<leader>fsc",
		function() grep_branch_changed({ default_text = get_visual_selection() }) end,
		{ desc = "Search selection in branch-changed files" }
	)
	keymap.nnoremap("<leader>fsn", find_branch_changed, { desc = "Find branch-changed files" })
	keymap.vnoremap(
		"<leader>fsn",
		function() find_branch_changed({ default_text = get_visual_selection() }) end,
		{ desc = "Find branch-changed files named like the selection" }
	)
	keymap.nnoremap(
		"<leader>ffc",
		telescope_builtin.git_bcommits,
		{ desc = "Search through the current file's git commits" }
	)
	keymap.nnoremap(
		"<leader>ffs",
		telescope_builtin.current_buffer_fuzzy_find,
		{ desc = "Current file fuzzy finder" }
	)
	keymap.vnoremap("<leader>ffs", function()
		local selected_text = get_visual_selection()
		telescope_builtin.current_buffer_fuzzy_find({ default_text = selected_text })
	end, { desc = "Current selection file fuzzy finder" })
	keymap.nnoremap(
		"<leader>ffy",
		telescope_builtin.lsp_document_symbols,
		{ desc = "Current file's LSP symbols" }
	)
	keymap.nnoremap("<leader>fft", telescope_builtin.filetypes, { desc = "Change filetype" })
end

---@module 'lazy'
---@type LazyPluginSpec
return {
	"nvim-telescope/telescope.nvim",
	event = { "VeryLazy" },
	dependencies = {
		"nvim-lua/popup.nvim",
		"nvim-lua/plenary.nvim",
		"sharkdp/fd",
		"BurntSushi/ripgrep",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"folke/trouble.nvim",
	},
	config = config,
}
