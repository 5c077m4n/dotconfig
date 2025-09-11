---@module 'lazy'
---@type LazyPluginSpec[]
return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		config = function()
			local dap = require("dap")
			local keymap = require("vimrc.utils").keymapping

			keymap.nnoremap("<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			keymap.nnoremap("<leader>dc", dap.continue, { desc = "DAP start/continue" })
			keymap.nnoremap("<leader>dD", dap.disconnect, { desc = "DAP stop" })
			keymap.nnoremap("<Up>", dap.restart_frame, { desc = "Restart frame" })
			keymap.nnoremap("<Down>", dap.step_over, { desc = "Step over breakpoint" })
			keymap.nnoremap("<Left>", dap.step_out, { desc = "Step out of breakpoint" })
			keymap.nnoremap("<Right>", dap.step_into, { desc = "Step into breakpoint" })
		end,
		dependencies = {
			{
				"igorlfs/nvim-dap-view",
				config = function()
					local dap_view = require("dap-view")

					dap_view.setup({ auto_toggle = true })
					vim.api.nvim_create_autocmd({ "FileType" }, {
						pattern = { "dap-view", "dap-view-term", "dap-repl" },
						callback = function(args)
							vim.keymap.set("n", "q", "<C-w>q", { buffer = args.buf })
						end,
					})
				end,
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			local dapui = require("dapui")
			local keymap = require("vimrc.utils").keymapping

			keymap.nnoremap("<leader>du", dapui.toggle, { desc = "Open the DAP UI" })
			keymap.nnoremap("<leader>dfe", dapui.float_element, { desc = "DAP UI float element" })
			keymap.nnoremap("<leader>k", dapui.eval, { desc = "Evaluate current element" })
		end,
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				dependencies = { "mfussenegger/nvim-dap" },
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
				dependencies = { "mfussenegger/nvim-dap" },
				lazy = true,
				config = function() require("dap-python").setup("python3") end,
			},
			{ "nvim-neotest/nvim-nio" },
			{
				"theHamsta/nvim-dap-virtual-text",
				config = true,
				dependencies = { "mfussenegger/nvim-dap" },
			},
		},
	},
}
