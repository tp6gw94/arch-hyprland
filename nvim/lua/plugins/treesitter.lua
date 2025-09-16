-- Treesitter configuration
return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "OXY2DEV/markview.nvim" },
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"vue",
				"javascript",
				"typescript",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"yaml",
			},
			auto_install = true,
			highlight = { enable = true },
		})
	end,
}