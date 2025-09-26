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
			{ "<C-p>", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			completions = { lsp = { enabled = true } },
		},
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
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		---@module 'obsidian'
		---@type obsidian.config
		opts = {
			legacy_commands = false,
			ui = {
				enable = false,
			},
			workspaces = {
				{
					name = "personal",
					path = "~/vaults/personal",
				},
				{
					name = "work",
					path = "~/vaults/work",
				},
			},
		},
		config = function(_, opts)
			require("obsidian").setup(opts)

			vim.keymap.set("n", "<leader>os", "<CMD>Obsidian search<CR>")
			vim.keymap.set("n", "<leader>ow", "<CMD>Obsidian workspace<CR>")
			vim.keymap.set("n", "<leader>on", "<CMD>Obsidian new_from_template<CR>")
			vim.keymap.set("n", "<leader>ot", "<CMD>Obsidian today<CR>")
			vim.keymap.set("n", "<leader>om", "<CMD>Obsidian<CR>")
		end,
	},
}
