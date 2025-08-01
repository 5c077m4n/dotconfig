local os = require("os")

local function bootstrap()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

	if not vim.uv.fs_stat(lazypath) then
		local lazyrepo = "https://github.com/folke/lazy.nvim.git"
		local out = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=stable",
			lazyrepo,
			lazypath,
		})
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
				{ out, "WarningMsg" },
				{ "\nPress any key to exit..." },
			}, true, {})
			vim.fn.getchar()

			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)
end

local function setup()
	bootstrap()

	require("lazy").setup({
		spec = {
			{ import = "plugins" },
		},
		install = { colorscheme = { "github_dark_colorblind" } }, -- colorscheme that will be used when installing plugins.
		ui = { border = "rounded" },
	})
end

return { setup = setup }
