-- Mini.nvim plugins suite
return {
	"echasnovski/mini.nvim",
	version = "*",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", "folke/trouble.nvim" },
	lazy = false,
	config = function()
		require("ts_context_commentstring").setup({
			enable_autocmd = false,
		})
		require("mini.comment").setup({
			options = {
				custom_commentstring = function()
					return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
				end,
			},
		})
		require("mini.pairs").setup()
		require("mini.surround").setup({
			mappings = {
				add = "ms",
				delete = "md",
				find_left = "",
				highlight = "",
				replace = "mr",
			},
		})
		require("mini.bracketed").setup()
		require("mini.diff").setup()
		require("mini.jump2d").setup({
			mappings = {
				start_jumping = "ss",
			},
		})
		require("mini.cursorword").setup()
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
				fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
				hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
				todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
				note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
		require("mini.icons").setup()
		require("mini.indentscope").setup()
		require("mini.statusline").setup()
		require("mini.pick").setup({
			mappings = {
				choose_marked = "<C-q>",
			},
			source = {
				choose_marked = function(items)
					MiniPick.default_choose_marked(items, { list_type = "quickfix" })
					-- close quickfix from mini pick
					vim.defer_fn(function()
						vim.cmd("cclose")
					end, 10)
					require("trouble").open("qflist")
				end,
			},
		})
		require("mini.extra").setup()
		require("mini.files").setup()
		require("mini.misc").setup()

		-- Setup SmartPick
		local smartpick = require("config.smartpick")
		smartpick.setup()

		vim.api.nvim_set_hl(0, "MiniPickBorder", {
			fg = "#0969da",
			bg = "NONE",
		})

		vim.api.nvim_set_hl(0, "MiniPickBorderBusy", {
			fg = "#cf222e",
			bg = "NONE",
		})

		vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", {
			bg = "#0366d6",
			fg = "#ffffff",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniPickMatchMarked", {
			bg = "#fb8500",
			fg = "#ffffff",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniPickMatchRanges", {
			bg = "#ffd60a",
			fg = "#000000",
		})

		vim.api.nvim_set_hl(0, "MiniPickNormal", {
			bg = "#ffffff",
			fg = "#24292f",
		})

		vim.api.nvim_set_hl(0, "MiniPickPrompt", {
			fg = "#0969da",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniPickPromptCaret", {
			fg = "#cf222e",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniPickBorderText", {
			fg = "#24292f",
			bg = "NONE",
		})

		vim.api.nvim_set_hl(0, "MiniPickHeader", {
			fg = "#0969da",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniPickPreviewLine", {
			bg = "#28a745",
			fg = "#ffffff",
		})

		vim.api.nvim_set_hl(0, "MiniPickPreviewRegion", {
			bg = "#6f42c1",
			fg = "#ffffff",
		})

		vim.api.nvim_set_hl(0, "MiniFilesBorder", {
			fg = "#0969da",
			bg = "NONE",
		})

		vim.api.nvim_set_hl(0, "MiniFilesBorderModified", {
			fg = "#cf222e",
			bg = "NONE",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniFilesCursorLine", {
			bg = "#0366d6",
			fg = "#ffffff",
		})

		vim.api.nvim_set_hl(0, "MiniFilesDirectory", {
			fg = "#6f42c1",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniFilesFile", {
			fg = "#24292f",
		})

		vim.api.nvim_set_hl(0, "MiniFilesNormal", {
			bg = "#ffffff",
			fg = "#24292f",
		})

		vim.api.nvim_set_hl(0, "MiniFilesTitle", {
			fg = "#0969da",
			bg = "#f6f8fa",
			bold = true,
		})

		vim.api.nvim_set_hl(0, "MiniFilesTitleFocused", {
			fg = "#ffffff",
			bg = "#0969da",
			bold = true,
		})

		-- SmartPick highlight groups
		vim.api.nvim_set_hl(0, "SmartPickBuffer", {
			bg = "#f6f8fa",
		})
		vim.api.nvim_set_hl(0, "SmartPickPath", {
			fg = "#6e7781",
		})
		vim.api.nvim_set_hl(0, "SmartPickPathMatch", {
			fg = "#0969da",
			bold = true,
		})
	end,
	keys = {
		{
			"<leader>e",
			"<CMD>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>",
			{ desc = "MiniFiles directory of current file" },
		},
		{
			"<leader>E",
			"<CMD>lua MiniFiles.open(nil, false)<CR>",
			{ desc = "MiniFiles current working directory" },
		},
		{
			"<leader>wz",
			"<CMD>lua MiniMisc.zoom()<CR>",
			{ desc = "Zoom" },
		},
		{
			"<leader>f",
			function()
				require("config.smartpick").picker()
			end,
			desc = "Smart Pick (Files + Buffers)",
		},
		{
			"<leader>b",
			function()
				require("mini.pick").builtin.buffers()
			end,
			desc = "Find Buffer",
		},
		{
			"<leader>/",
			function()
				require("mini.extra").pickers.buf_lines()
			end,
			desc = "Search Current Buffer Line",
		},
		{
			"<leader>lg",
			function()
				require("mini.pick").builtin.grep_live()
			end,
			desc = "Grep",
		},
		{
			"<leader>'",
			function()
				require("mini.pick").builtin.resume()
			end,
			desc = "Resume picker",
		},
		{
			"<C-p>",
			function()
				require("mini.extra").pickers.commands()
			end,
			desc = "Command picker",
		},
	},
}
