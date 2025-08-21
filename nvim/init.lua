-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Keymap

vim.keymap.set('n', '<Esc>', '<cmd>nohl<cr>')
vim.keymap.set('i', 'jk', '<Esc>')

vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- terminal mode use ctrl+hjkl to move cursor
vim.keymap.set('c', '<C-h>', '<Left>', { noremap = true })
vim.keymap.set('c', '<C-j>', '<Down>', { noremap = true })
vim.keymap.set('c', '<C-k>', '<Up>', { noremap = true })
vim.keymap.set('c', '<C-l>', '<Right>', { noremap = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

vim.keymap.set('n', '<C-s>', '<C-W>s', { desc = 'Split Window Below', remap = true })
vim.keymap.set('n', '<C-v>', '<C-W>v', { desc = 'Split Window Right', remap = true })
vim.keymap.set('n', '<leader>wd', '<C-W>c', { desc = 'Delete Window', remap = true })


vim.keymap.set('n', '<leader>f', "<CMD>Pick files tool='git'<CR>", { desc = "Find File" })

vim.keymap.set('n', '<leader>bf', "<CMD>Pick buffers<CR>", { desc = "Find Buffer" })
vim.keymap.set('n', '<leader>b/', "<CMD>FzfLua blines<CR>", { desc = "Search Current Bufer Line" })
vim.keymap.set('n', '<leader>/', "<CMD>FzfLua live_grep_native<CR>", { desc = "Grep" })
vim.keymap.set('n', "<leader>'", "<CMD>FzfLua resume<CR>", { desc = "Resume fzf" })
vim.keymap.set('n', "<C-p>", "<CMD>FzfLua global<CR>", {desc = "Global Picker"})
vim.keymap.set('n', '<leader>bd', '<CMD>bd<CR>', { desc = "Delete Buffer" })


vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set('n', '<leader>z', '<C-w>_<C-w>|')
vim.keymap.set('n', '<leader>Z', '<C-w>=')

vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = "Code Format" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set('n', '<leader>cA', function() vim.lsp.buf.code_action({ context = { only = { "source" } } }) end)
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = "Line Diangostics" })
vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = "Reanem" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, { desc = "Signature Help" })
-- Autocmd
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'qf', 'help' },
	callback = function()
		vim.keymap.set('n', 'q', '<CMD>bd<CR>', { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	callback = function()
		vim.cmd([[Trouble qflist open]])
	end,
})

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.swapfile = false
vim.opt.wrap = false

vim.opt.showmode = false

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true

vim.opt.background = "light"

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes:1"

vim.opt.timeoutlen = 500

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.scrolloff = 12

vim.opt.numberwidth = 1
vim.opt.statuscolumn = "%l%s"

vim.opt.tabstop = 2
vim.opt.winborder = "rounded"

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = {
		current_line = true,
		source = "if_many",
		spacing = 4
	}
})


require("lazy").setup({
	spec = {
		{
			"zenbones-theme/zenbones.nvim",
			-- Optionally install Lush. Allows for more configuration or extending the colorscheme
			-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
			-- In Vim, compat mode is turned on as Lush only works in Neovim.
			dependencies = "rktjmp/lush.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.g.zenbones_darken_comments = 45
				vim.cmd("colorscheme zenwritten")
			end
		},
		{
			'echasnovski/mini.nvim',
			version = '*',
			config = function()
				require('mini.comment').setup()
				require('mini.pairs').setup()
				require('mini.surround').setup({
					mappings = {
						add = "ms",
						delete = "md",
						find_left = "",
						highlight = "",
						replace = "mr"
					}
				})
				require('mini.bracketed').setup()
				require('mini.diff').setup()
				require('mini.jump2d').setup()
				require('mini.pick').setup()
				require('mini.cursorword').setup()
				local hipatterns = require('mini.hipatterns')
				hipatterns.setup({
					highlighters = {
						-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
						fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
						hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
						todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
						note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

						-- Highlight hex color strings (`#rrggbb`) using that color
						hex_color = hipatterns.gen_highlighter.hex_color(),
					},
				})
				require('mini.icons').setup()
				require('mini.indentscope').setup()
				require('mini.statusline').setup()
				require('mini.fuzzy').setup()
			end
		},
		{
			'stevearc/oil.nvim',
			---@module 'oil'
			---@type oil.SetupOpts
			opts = {
				keymaps = {
					["<C-h>"] = false,
					["<C-s>"] = { "actions.select", opts = { horizontal = true } },
					["<C-v>"] = { "actions.select", opts = { vertical = true } },
					["q"] = { "actions.close", mode = "n" }
				}
			},
			-- Optional dependencies
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
			-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
			lazy = false,
		},
		{
			"mason-org/mason.nvim",
			opts = {}
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				vim.lsp.enable({ "lua_ls", "vtsls" })
			end
		},
		{
			'saghen/blink.cmp',
			-- optional: provides snippets for the snippet source
			dependencies = { 'rafamadriz/friendly-snippets' },

			-- use a release tag to download pre-built binaries
			version = '1.*',
			-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
			-- build = 'cargo build --release',
			-- If you use nix, you can build from source using latest nightly rust with:
			-- build = 'nix run .#build-plugin',

			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = 'default' },

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = 'mono'
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = { documentation = { auto_show = false } },

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning" }
			},
			opts_extend = { "sources.default" }
		},
		{
			'kevinhwang91/nvim-ufo',
			dependencies = { 'kevinhwang91/promise-async' },
			config = function()
				vim.o.foldcolumn = '1' -- '0' is not bad
				vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities.textDocument.foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true
				}
				local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
				for _, ls in ipairs(language_servers) do
					require('lspconfig')[ls].setup({
						capabilities = capabilities
						-- you can add other fields for setting up lsp server in this table
					})
				end
				require('ufo').setup()
			end
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "echasnovski/mini.icons" },
			opts = {},
			config = function()
				local config = require("fzf-lua.config")
				local actions = require("trouble.sources.fzf").actions
				config.defaults.actions.files["ctrl-t"] = actions.open
			end
		},
		{
			"folke/trouble.nvim",
			opts = {
				focus = true
			},
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"gd",
					"<cmd>Trouble lsp_definitions focus=true win.position=bottom<cr>"
				},
				{
					"gr",
					"<cmd>Trouble lsp_references focus=true win.position=bottom<cr>"
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp focus=true win.postion=bottom<cr>"
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local harpoon = require('harpoon')
				harpoon:setup()

				vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
				vim.keymap.set("n", "<leader><space>",
					function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

				vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
				vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
				vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
				vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)
			end
		}
	},
	install = { colorscheme = { "zenwritten" } }
})
