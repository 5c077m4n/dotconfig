return {
	"windwp/nvim-ts-autotag",
	event = { "VeryLazy", "InsertEnter" },
	config = function()
		require("nvim-ts-autotag").setup({
			filetypes = {
				"html",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"markdown",
			},
		})
	end,
}
