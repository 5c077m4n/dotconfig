---@module 'lazy'
---@type LazyPluginSpec
return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{
			"mason-org/mason.nvim",
			event = { "VeryLazy" },
			cmd = { "MasonPackagesUpdateAll" },
			build = function() vim.cmd.MasonUpdate() end,
			config = function()
				local mason = require("mason")
				local mason_registry = require("mason-registry")

				mason.setup({ ui = { border = "single" } })

				vim.api.nvim_create_user_command("MasonPackagesUpdateAll", function()
					mason_registry.refresh()

					local handles = vim.iter(mason_registry.get_installed_packages())
						:filter(
							function(pkg)
								return pkg:get_installed_version() ~= pkg:get_latest_version()
							end
						)
						:map(function(pkg)
							print(
								("Updating %s %s -> %s\n"):format(
									pkg.name,
									pkg:get_installed_version(),
									pkg:get_latest_version()
								)
							)
							return pkg:install({}, function(success)
								if not success then
									print(("Failed updating %s\n"):format(pkg.name))
								end
							end)
						end)
						:totable()

					vim.wait(600000, function()
						return vim.iter(handles):all(function(handle) return handle:is_closed() end)
					end)
				end, { desc = "Update all installed Mason packages" })
			end,
		},
	},
	event = { "VeryLazy" },
	config = function()
		local lsp_config = require("vimrc.lsp")

		---@type string[]
		local mason_supported_servers = vim.iter(lsp_config.SERVER_LIST)
			:filter(
				function(server)
					return server ~= "gleam"
						and server ~= "fish_lsp"
						and server ~= "swift"
						and server ~= "nil_ls"
						and server ~= "terraform_ls"
				end
			)
			:totable()
		require("mason-lspconfig").setup({
			PATH = "append",
			automatic_installation = true,
			automatic_enable = false,
			ensure_installed = mason_supported_servers,
		})
	end,
}
