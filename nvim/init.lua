-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Keymap
vim.keymap.set("n", "<Esc>", "<cmd>nohl<cr>")
vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- terminal mode use ctrl+hjkl to move cursor
vim.keymap.set("c", "<C-h>", "<Left>", { noremap = true })
vim.keymap.set("c", "<C-j>", "<Down>", { noremap = true })
vim.keymap.set("c", "<C-k>", "<Up>", { noremap = true })
vim.keymap.set("c", "<C-l>", "<Right>", { noremap = true })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

vim.keymap.set("n", "<C-s>", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<C-v>", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

vim.keymap.set("n", "<leader>q", "<CMD>bd<CR>", { desc = "Delete Buffer" })

vim.keymap.set("n", "U", "<C-r>", { noremap = true })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>cA", function()
	vim.lsp.buf.code_action({ context = { only = { "source" } } })
end)
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diangostics" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Reanem" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- Autocmd
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "qf", "help" },
	callback = function()
		vim.keymap.set("n", "q", "<CMD>bd<CR>", { silent = true, buffer = true })
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd([[cclose]])
        vim.cmd([[Trouble qflist open]])
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	callback = function()
		vim.cmd([[Trouble qflist open]])
	end,
})

vim.api.nvim_create_user_command("CopyRelPath", function()
	local path = vim.fn.expand("%:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, {})

vim.api.nvim_create_user_command("CopyAbsPath", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, {})

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.o.swapfile = false
vim.opt.wrap = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4

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
vim.opt.ttimeoutlen = 10

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
		spacing = 4,
	},
})

require("lazy").setup({
	spec = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"nvim-mini/mini.nvim",
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
						require("mini.pick").builtin.files()
					end,
					desc = "Find File",
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
		},
		{
			"stevearc/oil.nvim",
			---@module 'oil'
			---@type oil.SetupOpts
			opts = {
				keymaps = {
					["<C-h>"] = false,
					["<C-s>"] = { "actions.select", opts = { horizontal = true } },
					["<C-v>"] = { "actions.select", opts = { vertical = true } },
					["q"] = { "actions.close", mode = "n" },
				},
			},
			dependencies = { { "echasnovski/mini.icons", opts = {} } },
			lazy = false,
		},
		{
			"mason-org/mason.nvim",
			opts = {},
		},
		{
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
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
				local vue_language_server_path = vim.fn.stdpath("data")
					.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
				local vue_plugin = {
					name = "@vue/typescript-plugin",
					location = vue_language_server_path,
					languages = { "vue" },
					configNamespace = "typescript",
				}
				local vtsls_config = {
					settings = {
						vtsls = {
							tsserver = {
								globalPlugins = {
									vue_plugin,
								},
							},
						},
					},
					filetypes = tsserver_filetypes,
				}
				local vue_ls_config = {}
				vim.lsp.config("vtsls", vtsls_config)
				vim.lsp.config("vue_ls", vue_ls_config)

				vim.lsp.enable({
					"lua_ls",
					"vtsls",
					"vue_ls",
					"eslint",
					"tailwindcss",
					"markdown_oxide",
					"zk",
					"cssls",
				})
			end,
		},
		{
			"stevearc/conform.nvim",
			opts = {},
			config = function()
				local prettier = { "prettierd", "prettier", sto_after_first = true }
				local conform = require("conform")
				conform.setup({
					formatters_by_ft = {
						lua = { "stylua" },
						markdown = prettier,
						javascript = prettier,
						javascriptreact = prettier,
						typescript = prettier,
						typescriptreact = prettier,
						vue = prettier,
						json = prettier,
						jsonc = prettier,
					},
				})
				vim.keymap.set("n", "<leader>cf", function(args)
					conform.format()
				end)
			end,
		},
		{
			"mfussenegger/nvim-lint",
			config = function()
				require("lint").linters_by_ft = {}

				vim.api.nvim_create_autocmd({ "BufWritePost" }, {
					callback = function()
						require("lint").try_lint()
						require("lint").try_lint("cspell")
					end,
				})
			end,
		},
		{
			"saghen/blink.cmp",
			dependencies = { "rafamadriz/friendly-snippets" },
			version = "1.*",
			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				keymap = { preset = "default" },
				appearance = {
					nerd_font_variant = "mono",
				},
				completion = { documentation = { auto_show = true } },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			"kevinhwang91/nvim-ufo",
			dependencies = { "kevinhwang91/promise-async" },
			config = function()
				vim.o.foldcolumn = "1" -- '0' is not bad
				vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
				vim.o.foldlevelstart = 99
				vim.o.foldenable = true

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities.textDocument.foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				}
				local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
				for _, ls in ipairs(language_servers) do
					require("lspconfig")[ls].setup({
						capabilities = capabilities,
					})
				end
				require("ufo").setup()
			end,
			cond = function()
				return vim.bo.filetype ~= "markdown"
			end,
		},
		{
			"folke/trouble.nvim",
			opts = {
				focus = true,
				auto_preview = false,
				keys = {
					["<Tab>"] = "toggle_preview",
				},
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
					"<leader>cl",
					"<cmd>Trouble lsp focus=true win.postion=bottom<cr>",
				},
				{
					"gr",
					"<cmd>Trouble lsp_references focus=true win.position=bottom<cr>",
				},
				{
					"gD",
					"<cmd>Trouble lsp_declarations focus=true win.position=bottom<cr>",
				},
				{
					"gt",
					"<cmd>Trouble lsp_type_definitions focus=true win.position=bottom<cr>",
				},
				{
					"gd",
					"<cmd>Trouble lsp_definitions focus=true win.position=bottom<cr>",
				},
				{
					"gi",
					"<cmd>Trouble lsp_implementations focus=true win.position=bottom<cr>",
				},
				{
					"gci",
					"<cmd>Trouble lsp_incoming_calls focus=true win.position=bottom<cr>",
				},
				{
					"gco",
					"<cmd>Trouble lsp_outgoing_calls focus=true win.position=bottom<cr>",
				},
			},
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local harpoon = require("harpoon")
				harpoon:setup()

				vim.keymap.set("n", "<leader>a", function()
					harpoon:list():add()
				end)
				vim.keymap.set("n", "<leader><space>", function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end)

				vim.keymap.set("n", "<C-1>", function()
					harpoon:list():select(1)
				end)
				vim.keymap.set("n", "<C-2>", function()
					harpoon:list():select(2)
				end)
				vim.keymap.set("n", "<C-3>", function()
					harpoon:list():select(3)
				end)
				vim.keymap.set("n", "<C-4>", function()
					harpoon:list():select(4)
				end)
				vim.keymap.set("n", "<C-5>", function()
					harpoon:list():select(5)
				end)
			end,
		},
		{
			"greggh/claude-code.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim", -- Required for git operations
			},
			config = function()
				require("claude-code").setup({
					window = {
						position = "float",
						float = {
							width = "90%", -- Take up 90% of the editor width
							height = "90%", -- Take up 90% of the editor height
							row = "center", -- Center vertically
							col = "center", -- Center horizontally
							relative = "editor",
							border = "double", -- Use double border style
						},
					},
				})
			end,
		},
		{
			"projekt0n/github-nvim-theme",
			name = "github-theme",
			lazy = false,
			priority = 1000,
			config = function()
				require("github-theme").setup()

				vim.cmd("colorscheme github_light_tritanopia")
			end,
		},
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
		{
			"zk-org/zk-nvim",
			config = function()
				require("zk").setup({
					picker = "minipick",

					lsp = {
						config = {
							name = "zk",
							cmd = { "zk", "lsp" },
							filetypes = { "markdown" },
						},
						auto_attach = {
							enabled = true,
						},
					},
				})

				-- Custom commands
				local commands = require("zk.commands")

				-- ZkMenu - custom menu for creating notes
				commands.add("ZkMenu", function(opts)
					require("mini.pick").start({
						source = {
							items = { "Index", "Notes", "Work", "Meeting" },
							name = "ZkMenu",
							choose = function(choice)
								if not choice then
									return
								end

								if choice == "Index" then
									-- Edit index.md directly
									local index_path = vim.fn.expand("$ZK_NOTEBOOK_DIR/index.md")
									if vim.fn.filereadable(index_path) == 0 then
										index_path = vim.fn.getcwd() .. "/index.md"
									end
									vim.cmd("edit " .. index_path)
								elseif choice == "Notes" or choice == "Work" or choice == "Meeting" then
									local dir_map = {
										Notes = "notes",
										Work = "work/notes",
										Meeting = "work/meeting",
									}
									local target_dir = dir_map[choice]

									-- Create new note in specific directory
									vim.ui.input({ prompt = "Note title: " }, function(title)
										if choice == "Notes" then
											-- Notes requires title
											if title and title ~= "" then
												require("zk").new({
													title = title,
													dir = target_dir,
													edit = true,
												})
											else
												vim.notify("Title is required for Notes")
											end
										else
											-- Work and Meeting can use random ID if no title
											if title and title ~= "" then
												require("zk").new({
													title = title,
													dir = target_dir,
													edit = true,
												})
											else
												-- Generate random unique ID
												local random_id = string.format("%04x", math.random(0, 65535))
												require("zk").new({
													title = random_id,
													dir = target_dir,
													edit = true,
												})
											end
										end
									end)
								end
							end,
						},
					})
				end)

				-- ZkNewMeeting - quick command for creating meeting notes
				commands.add("ZkNewMeeting", function(opts)
					opts = vim.tbl_extend("force", { dir = "work/meeting" }, opts or {})
					require("zk").new(opts)
				end)

				-- ZkSearch - unified search with create fallback
				commands.add("ZkSearch", function(opts)
					require("mini.pick").start({
						source = {
							items = { "Index", "Notes", "Work", "Meeting", "All" },
							name = "ZkSearch",
							choose = function(choice)
								if not choice then
									return
								end

								if choice == "Index" then
									-- Edit index.md directly
									local index_path = vim.fn.expand("$ZK_NOTEBOOK_DIR/index.md")
									if vim.fn.filereadable(index_path) == 0 then
										index_path = vim.fn.getcwd() .. "/index.md"
									end
									vim.cmd("edit " .. index_path)
									return
								end

								-- Prompt for search query
								vim.ui.input({ prompt = "Search in " .. choice .. ": " }, function(query)
									if not query or query == "" then
										return
									end

									local search_opts = {
										match = { query },
										sort = { "modified" },
										select = {
											"title",
											"absPath",
											"path",
										},
									}

									-- Add directory filter unless searching All
									if choice ~= "All" then
										local dir_map = {
											Notes = "notes",
											Work = "work/notes",
											Meeting = "work/meeting",
										}
										search_opts.hrefs = { dir_map[choice] }
									end

									-- Search for notes
									require("zk.api").list(nil, search_opts, function(err, notes)
										if err then
											vim.notify("Error: " .. err.message)
											return
										end

										if notes and #notes > 0 then
											-- Found notes, show picker
											require("zk.ui").pick_notes(notes, {
												title = "Found notes for: " .. query,
												multi_select = false,
											}, function(selected_note)
												if selected_note then
													local file_path = selected_note.absPath or selected_note.path
													if file_path then
														vim.cmd("edit " .. vim.fn.fnameescape(file_path))
													end
												end
											end)
										else
											-- No notes found, offer to create
											if choice == "All" then
												-- Ask where to create when searching in All
												vim.ui.select(
													{ "Notes", "Work", "Meeting", "Cancel" },
													{ prompt = "No notes found. Create '" .. query .. "' in:" },
													function(create_choice)
														if not create_choice or create_choice == "Cancel" then
															return
														end

														local dir_map = {
															Notes = "notes",
															Work = "work/notes",
															Meeting = "work/meeting",
														}

														require("zk").new({
															title = query,
															dir = dir_map[create_choice],
															edit = true,
														})
													end
												)
											else
												-- Create in the selected directory
												vim.ui.select({ "Yes", "No" }, {
													prompt = "No notes found. Create '"
														.. query
														.. "' in "
														.. choice
														.. "?",
												}, function(confirm)
													if confirm == "Yes" then
														local dir_map = {
															Notes = "notes",
															Work = "work/notes",
															Meeting = "work/meeting",
														}

														require("zk").new({
															title = query,
															dir = dir_map[choice],
															edit = true,
														})
													end
												end)
											end
										end
									end)
								end)
							end,
						},
					})
				end)
			end,
			keys = {
				{
					"<leader>zm",
					"<Cmd>ZkMenu<CR>",
					desc = "Zk Menu (Index/Notes/Work/Meeting)",
				},
				{
					"<leader>zo",
					"<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
					desc = "Open all notes",
				},
				{
					"<leader>zf",
					function()
						vim.ui.input({ prompt = "Search: " }, function(query)
							if query and query ~= "" then
								vim.cmd("ZkNotes { sort = { 'modified' }, match = { '" .. query .. "' } }")
							end
						end)
					end,
					desc = "Find notes",
				},
				{
					"<leader>zf",
					":'<,'>ZkMatch<CR>",
					mode = "v",
					desc = "Search notes matching selection",
				},
				{
					"<leader>zi",
					"<Cmd>ZkIndex<CR>",
					desc = "Index zk notebook",
				},
				{
					"<leader>z/",
					"<Cmd>ZkSearch<CR>",
					desc = "Search notes by directory",
				},
			},
		},
	},
	install = { colorscheme = { "github_light_tritanopia" } },
})
