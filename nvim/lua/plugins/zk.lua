-- Zk note-taking plugin
return {
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
}
