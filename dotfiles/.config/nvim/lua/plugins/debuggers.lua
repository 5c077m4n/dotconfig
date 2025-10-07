local create_autocmd = vim.api.nvim_create_autocmd
local create_augroup = vim.api.nvim_create_augroup

---@module 'lazy'
---@type LazyPluginSpec
local nvim_dap = {
	"mfussenegger/nvim-dap",
	lazy = true,
	config = function()
		local dap = require("dap")
		local keymap = require("vimrc.utils").keymapping

		keymap.nnoremap("<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		keymap.nnoremap("<leader>dc", dap.continue, { desc = "DAP start/continue" })
		keymap.nnoremap("<leader>dD", dap.disconnect, { desc = "DAP stop" })

		create_autocmd({ "FileType" }, {
			group = create_augroup("setup_dap_keybinds", { clear = true }),
			pattern = { "dap-view", "dap-view-term", "dap-repl" },
			callback = function(args)
				local buffer = args.buf

				keymap.nnoremap(
					"<Up>",
					dap.restart_frame,
					{ buffer = buffer, desc = "Restart frame" }
				)
				keymap.nnoremap(
					"<Down>",
					dap.step_over,
					{ buffer = buffer, desc = "Step over breakpoint" }
				)
				keymap.nnoremap(
					"<Left>",
					dap.step_out,
					{ buffer = buffer, desc = "Step out of breakpoint" }
				)
				keymap.nnoremap(
					"<Right>",
					dap.step_into,
					{ buffer = buffer, desc = "Step into breakpoint" }
				)
			end,
		})
	end,
}

---@module 'lazy'
---@type LazyPluginSpec
return {
	"rcarriga/nvim-dap-ui",
	config = function()
		local dapui = require("dapui")
		local keymap = require("vimrc.utils").keymapping

		keymap.nnoremap("<leader>du", dapui.toggle, { desc = "Open the DAP UI" })
		keymap.nnoremap("<leader>dfe", dapui.float_element, { desc = "DAP UI float element" })
		keymap.nnoremap("<leader>k", dapui.eval, { desc = "Evaluate current element" })
	end,
	dependencies = {
		nvim_dap,
		{
			"igorlfs/nvim-dap-view",
			dependencies = { nvim_dap },
			config = function()
				local dap_view = require("dap-view")

				dap_view.setup({ auto_toggle = true })
				create_autocmd({ "FileType" }, {
					group = create_augroup("setup_dap_view_keybinds", { clear = true }),
					pattern = { "dap-view", "dap-view-term", "dap-repl" },
					callback = function(args)
						local keymap = require("vimrc.utils").keymapping
						local buffer = args.buf

						keymap.nnoremap("q", "<C-w>q", { buffer = buffer, desc = "Quit" })
					end,
				})
			end,
		},
		{
			"leoluz/nvim-dap-go",
			dependencies = { nvim_dap },
			lazy = true,
			config = function()
				local keymap = require("vimrc.utils").keymapping
				keymap.nnoremap(
					"<leader>dt",
					function() require("dap-go").debug_test() end,
					{ desc = "Debug test" }
				)
			end,
		},
		{
			"mfussenegger/nvim-dap-python",
			dependencies = { nvim_dap },
			lazy = true,
			config = function() require("dap-python").setup("python3") end,
			enabled = false,
		},
		{ "nvim-neotest/nvim-nio", lazy = true },
	},
}
