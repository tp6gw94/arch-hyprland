-- Treesitter configuration
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"vue",
				"javascript",
				"typescript",
				"markdown",
				"html",
				"css",
				"yaml",
			},
			disable = { "markdown" },
			highlight = { enable = true },
		})
	end,
}
