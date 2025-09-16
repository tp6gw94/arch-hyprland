-- Markdown plugins
return {
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			-- add options here
			-- or leave it empty to use the default settings
		},
		keys = {
			-- suggested keymap
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		-- For `nvim-treesitter` users.
		priority = 49,
		-- For blink.cmp's completion
		-- source
		dependencies = {
			"saghen/blink.cmp",
		},
		config = function()
			local presets = require("markview.presets")

			require("markview").setup({
				markdown = {
					headings = {
						heading_1 = { icon = "[%d] " },
						heading_2 = { icon = "[%d.%d] " },
						heading_3 = { icon = "[%d.%d.%d] " },
					},
					horizontal_rules = presets.horizontal_rules.thick,
					tables = presets.tables.rounded,
					code_blocks = {
						sign = false,
					},
				},
			})
			require("markview.extras.checkboxes").setup()
			require("markview.extras.headings").setup()
			require("markview.extras.editor").setup()
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}