-- Colorscheme configuration
return {
	"projekt0n/github-nvim-theme",
	name = "github-theme",
	lazy = false,
	priority = 1000,
	config = function()
		require("github-theme").setup({
			groups = {
				github_light_tritanopia = {
					Visual = {
						bg = "#0969da", 
						fg = "#ffffff",
						style = 'bold'
					},

					VisualNOS = {
						bg = "#0969da",
						fg = "#ffffff",
						style = 'bold'
					},
				},
			},
		})

		vim.cmd("colorscheme github_light_tritanopia")
	end,
}

