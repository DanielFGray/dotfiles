return {
	-- utils/commands/maps
	{
		"https://github.com/ibhagwan/fzf-lua",
		opts = {
			"telescope",
			fzf_opts = {
				-- ["--style"] = "full",
				["--reverse"] = "",
				["--info"] = "inline-right",
			},
		},
		cmd = { "FzfLua" },
		keys = {
			-- { "<Leader>ff", function() require("fzf-lua").files() end, desc = "List project files", mode = "n", silent = true },
			-- { "<Leader>fr", function() require("fzf-lua").oldfiles() end, desc = "List recent files", mode = "n", silent = true },
			{
				"<leader>ecf",
				function()
					require("fzf-lua").files({ cwd = "~/.config/nvim/lua" })
				end,
				desc = "edit config files",
				mode = "n",
				silent = true,
			},
			{
				"<Leader>/",
				function()
					require("fzf-lua").live_grep()
				end,
				desc = "Live Grep",
				mode = "n",
				silent = true,
			},
			-- { "<Leader>;", function() require("fzf-lua").commands() end, desc = "List commands", mode = "n", silent = true },
			-- { "<Leader><space>", function() require("fzf-lua").keymaps() end, desc = "List keymaps", mode = "n", silent = true },
			-- { "<leader>tc", function() require("fzf-lua").colorschemes() end, desc = "Toggle colorschemes", mode = "n", silent = true },
			-- { "<leader>tf", function() require("fzf-lua").resume() end, desc = "Toggle/resume fzf picker", mode = "n", silent = true },
			-- { "z=", function() require("fzf-lua").spell_suggest() end, desc = "Spelling suggestions", mode = "n", silent = true },
		},
	},
	{
		"https://github.com/folke/snacks.nvim",
		keys = {
			{
				"<leader>ff",
				function()
					require("snacks").picker.files()
				end,
				desc = "find files",
				mode = "n",
			},
			{
				"<leader>;",
				function()
					require("snacks").picker.commands()
				end,
				desc = "list commands",
				mode = "n",
			},
			{
				"<leader><leader>",
				function()
					require("snacks").picker.keymaps()
				end,
				desc = "list keymaps",
				mode = "n",
			},
			{
				"<leader>fr",
				function()
					require("snacks").picker.recent()
				end,
				desc = "Recent Files",
				mode = "n",
			},
			{
				"<leader>ee",
				function()
					require("snacks").explorer()
				end,
				desc = "File Explorer",
				mode = "n",
			},
			{
				"<leader>b",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "buffers",
				mode = "n",
			},
			{
				"<leader>lp",
				function()
					require("snacks").picker.projects()
				end,
				desc = "projects",
				mode = "n",
			},
			{
				"<leader>lu",
				function()
					require("snacks").picker.undo()
				end,
				desc = "undo history",
				mode = "n",
			},
			{
				"<leader>cR",
				function()
					require("snacks").rename.rename_file()
				end,
				desc = "Rename File",
				mode = "n",
			},
			{
				"<leader>tt",
				function()
					require("snacks").terminal.toggle()
				end,
				desc = "Toggle Terminal",
				mode = "n",
			},
			{
				"<leader>ecp",
				function()
					require("snacks").picker.lazy()
				end,
				desc = "pick plugins",
				mode = "n",
			},
			{
				"<leader>gG",
				function()
					require("snacks").lazygit()
				end,
				desc = "open lazygit",
				mode = "n",
			},
		},
		init = function()
			local Snacks = require("snacks")

			Snacks.toggle.inlay_hints():map("<leader>th")
			Snacks.toggle.option("expandtab", { name = "wrap" }):map("yoe")

			vim.api.nvim_create_user_command("Snacks", function()
				Snacks.picker.pickers()
			end, { nargs = 0 })

			---@type snacks.Config
			return {
				bigfile = { enabled = true },
				dashboard = { enabled = false },
				explorer = { replace_netrw = true },
				indent = { enabled = false },
				input = { enabled = false },
				picker = {
					explorer = {},
				},
				notifier = { enabled = true },
				quickfile = {},
				scope = { enabled = false },
				scroll = {},
				statuscolumn = { enabled = false },
				words = { enabled = false },
			}
		end,
	},
	"https://github.com/vim-utils/vim-husk", -- readline command maps
	"https://github.com/tpope/vim-abolish", -- extended subsititions and replacements `:S :Ab`
	"https://github.com/tpope/vim-eunuch", -- simple commands for common linux tasks
	"https://github.com/tpope/vim-sleuth", -- better indent/buffer type detection
	{
		"https://github.com/tummetott/unimpaired.nvim",
		event = "VeryLazy",
		opts = {
			keymaps = {
				bnext = false,
				bprevious = false,
				bfirst = false,
				blast = false,
			},
		},
	},
	"https://github.com/tpope/vim-dotenv", -- make .env vars accessible
	"https://github.com/haya14busa/is.vim", -- better incsearch highlighting
	{
		"https://github.com/haolian9/nag.nvim",
		keys = {
			{
				"<leader>est",
				function()
					require("nag").tab()
				end,
				desc = "open selection in new tab",
				mode = "x",
			},
			{
				"<leader>esl",
				function()
					require("nag").split("right")
				end,
				desc = "open selection in right split",
				mode = "x",
			},
			{
				"<leader>esh",
				function()
					require("nag").split("left")
				end,
				desc = "open selection in left split",
				mode = "x",
			},
			{
				"<leader>esk",
				function()
					require("nag").split("above")
				end,
				desc = "open selection in top split",
				mode = "x",
			},
			{
				"<leader>esj",
				function()
					require("nag").split("below")
				end,
				desc = "open selection in bottom split",
				mode = "x",
			},
		},
	},
	"https://github.com/zx2c4/password-store", -- disable viminfo etc for files in ~/.password-store
	{
		"https://github.com/sustech-data/wildfire.nvim",
		event = "VeryLazy",
		dependencies = { "https://github.com/nvim-treesitter/nvim-treesitter" },
		opts = {
			keymaps = {
				init_selection = "grx",
				node_incremental = "+",
				node_decremental = "-",
			},
		},
	},
	{
		"https://github.com/nvim-treesitter/nvim-treesitter", -- highlighting driven by syntax parsers
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		dependencies = {
			"https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
			"https://github.com/RRethy/nvim-treesitter-endwise",
			{ "https://github.com/andymass/vim-matchup", keys = { "%" } },
			"https://github.com/windwp/nvim-ts-autotag",
			"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",
			-- TODO: 'https://github.com/CKolkey/ts-node-action',
			-- TODO: 'https://github.com/RRethy/nvim-treesitter-textsubjects',
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"clojure",
					"cmake",
					"cpp",
					"css",
					"dockerfile",
					"gitignore",
					"graphql",
					"haskell",
					"html",
					"javascript",
					"json",
					"json5",
					"jsonc",
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"perl",
					"python",
					"regex",
					"rust",
					"sql",
					"tsx",
					"typescript",
					"vim",
					"vimdoc",
					"yaml",
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				endwise = { enable = true },
				matchup = { enable = true },
				autotag = { enable = true },
				textobjects = { enable = true },
				incremental_selection = { enable = true },
			})
		end,
	},
	{
		"https://github.com/aaronik/treewalker.nvim",
		keys = {
			{ "<leader>sh", "<Cmd>Treewalker SwapLeft<CR>", mode = "n", desc = "Swap left" },
			{ "<leader>sj", "<Cmd>Treewalker SwapDown<CR>", mode = "n", desc = "Swap down" },
			{ "<leader>sk", "<Cmd>Treewalker SwapUp<CR>", mode = "n", desc = "Swap up" },
			{ "<leader>sl", "<Cmd>Treewalker SwapRight<CR>", mode = "n", desc = "Swap right" },
		},
		opts = {},
	},
	{ "https://github.com/folke/lazydev.nvim", config = true, ft = "lua" },
	{ "https://github.com/stevearc/stickybuf.nvim", opts = {} },
	{
		"https://github.com/folke/trouble.nvim",
		dependencies = {
			"https://github.com/nvim-tree/nvim-web-devicons",
			{ "https://github.com/folke/todo-comments.nvim", lazy = false, opts = {} },
		},
		---@class trouble.Mode: trouble.Config,trouble.Section.spec
		opts = {
			auto_close = true,
			focus = true,
		},
		cmd = { "Trouble", "TroubleClose", "TroubleToggle", "TroubleRefresh" },
		-- keys = {
		-- 	{ "<Leader>tT", "<Cmd>TodoTrouble<CR>", mode = "n", desc = "Toggle TODOs" },
		-- 	{ "<leader>gd", "<Cmd>Trouble lsp open<CR>", mode = "n", desc = "LSP definitions/references" },
		-- 	{ "<Leader>ls", "<Cmd>Trouble symbols open<CR>", mode = "n", desc = "List symbols" },
		-- 	{ "<Leader>ld", "<Cmd>Trouble diagnostics open<CR>", mode = "n", desc = "List diagnostics" },
		-- 	{ "<Leader>tt", "<Cmd>TroubleToggle<CR>", mode = "n", desc = "Toggle trouble" },
		-- },
	},
	{
		"https://github.com/esneider/YUNOcommit.vim",
		lazy = true,
		event = "InsertLeave",
		init = function()
			vim.g.YUNOcommit_after = 5
		end,
	},
	{ "https://github.com/andrewferrier/wrapping.nvim", opts = {} },
	{
		"https://github.com/folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		-- stylua: ignore
		keys = {
			{ "<leader>se", "", desc = "Session", mode = {"n"} },
			{ "<leader>ses", function() require("persistence").load() end, desc = "Restore Session", mode = {"n"} },
			{ "<leader>seS", function() require("persistence").select() end,desc = "Select Session", mode = {"n"} },
			{ "<leader>sel", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session", mode = {"n"} },
			{ "<leader>sed", function() require("persistence").stop() end, desc = "Don't Save Current Session", mode = {"n"} },
		},
	},

	-- filetype specific
	{
		"https://github.com/davidmh/mdx.nvim",
		dependencies = { "https://github.com/nvim-treesitter/nvim-treesitter" },
		opts = {},
	},

	-- {
	-- 	"https://github.com/martineausimon/nvim-lilypond-suite",
	-- 	event = "VeryLazy",
	-- 	ft = { "lilypond" },
	-- 	dependencies = {
	-- 		{
	-- 			"https://github.com/saghen/blink.cmp",
	-- 			dependencies = "https://github.com/Kaiser-Yang/blink-cmp-dictionary",
	-- 			--- @param opts blink.cmp.Config
	-- 			opts = function(_, opts)
	-- 				vim.list_extend(opts.sources.providers.dictionary, { "dictionary", 2 })
	-- 				opts.sources.providers = opts.sources.providers or {}
	-- 				opts.sources.providers.dictionary = {
	-- 					module = "blink-cmp-dictionary",
	-- 					name = "Dict",
	-- 					min_keyword_length = 3,
	-- 					max_items = 8,
	-- 					opts = {
	-- 						dictionary_files = function()
	-- 							if vim.bo.filetype == "lilypond" then -- Add lilypond words to sources
	-- 								return vim.fn.glob(vim.fn.expand("$LILYDICTPATH") .. "/*", true, true)
	-- 							end
	-- 						end,
	-- 					},
	-- 				}
	-- 				return opts
	-- 			end,
	-- 		},
	-- 	},
	-- 	opts = {},
	-- },

	-- {
	-- 	"https://github.com/nvim-mini/mini.files",
	-- 	version = false,
	-- 	opts = {},
	-- 	config = function ()
	--
	-- 	end,
	-- 	keys = {
	-- 		{
	-- 			"-",
	-- 			function()
	-- 				require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
	-- 			end,
	-- 			desc = "Open File Explorer",
	-- 			mode = "n",
	-- 			silent = true,
	-- 		},
	-- 	},
	-- },
	{
		"https://github.com/nvzone/typr",
		dependencies = {
			"https://github.com/nvzone/volt",
			{ "https://github.com/jcdickinson/wpm.nvim", opts = {} },
		},
		opts = {},
		cmd = { "Typr", "TyprStats" },
	},
	{
		"https://github.com/nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"https://github.com/nvim-lua/plenary.nvim",
			"https://github.com/nvim-tree/nvim-web-devicons",
			"https://github.com/MunifTanjim/nui.nvim",
			{ "https://github.com/miversen33/netman.nvim", opts = true },
		},
		lazy = true,
		keys = {
			{
				"-",
				"<Cmd>Neotree focus filesystem right reveal_force_cwd<CR>",
				desc = "Show file in filetree",
				mode = "n",
				silent = true,
			},
			-- { "gO", "<Cmd>Neotree focus document_symbols right<CR>", desc = "Show document outline", mode = "n", silent = true },
		},
		cmd = { "Neotree" },
		opts = {
			follow_current_file = { enabled = true },
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = false,
			open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
			sources = {
				"filesystem",
				"buffers",
				"document_symbols",
				"git_status",
				"netman.ui.neo-tree",
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
			source_selector = {
				-- winbar = true,
				statusline = false,
				sources = {
					{ source = "document_symbols", display_name = " 󰌗 Symbols " },
					{ source = "filesystem", display_name = " 󰉓 Files " },
					{ source = "buffers", display_name = " 󰉓 Buffers " },
					{ source = "git_status", display_name = " 󰊢 Git " },
				},
			},
			filesystem = {
				hijack_netrw_behavior = "open_current",
				window = {
					mappings = {
						["-"] = "navigate_up",
					},
				},
			},
		},
	},
	-- { 'https://github.com/anuvyklack/pretty-fold.nvim', -- prettier/configurable folds
	--   opts = {
	--     keep_indentation = true,
	--     fill_char = ' ',
	--     process_comment_signs = true,
	--   },
	-- },
	{
		"https://github.com/hkupty/iron.nvim", -- interactive repl
		config = true,
		lazy = true,
	},
	{
		"https://github.com/kristijanhusak/vim-dadbod-ui", -- UI for interacting with a db
		dependencies = {
			"https://github.com/tpope/vim-dispatch",
			"https://github.com/tpope/vim-dadbod",
			-- https://github.com/xero/dotfiles/blob/f3507c2a50890cbc0e1a1cf5fa0c6fc89f1b85c7/neovim/.config/nvim/lua/plugins/dadbod.lua
			"https://github.com/kristijanhusak/vim-dadbod-completion",
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		ft = { "sql" },
		keys = {
			{ "<Leader>db", "<Cmd>DBUIToggle<CR>", desc = "Open database schemas", mode = "n", silent = true },
			{ "<Leader>db", ":DB<CR>", desc = "Execute code", mode = "x", silent = true },
		},
		init = function()
			vim.g.db_ui_env_variable_url = "DATABASE_URL"
			vim.g.db_ui_hide_schemas = { "migrations", "information_schema", "pg_catalog" }
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_table_helpers = {
				postgresql = {
					Count = "SELECT count(*) FROM {optional_schema}{table}",
					Explain = "EXPLAIN ANALYZE\n{last_query}",
				},
			}
		end,
	},
	{
		"https://github.com/mistweaverco/kulala.nvim",
		keys = {
			{ "<leader>R", group = "Request" },
			{ "<leader>Rs", desc = "Send request" },
			{ "<leader>Ra", desc = "Send all requests" },
			{ "<leader>Rb", desc = "Open scratchpad" },
		},
		ft = { "http", "rest" },
		opts = {
			global_keymaps = false,
			global_keymaps_prefix = "<leader>R",
			kulala_keymaps_prefix = "",
		},
	},
	{
		"https://github.com/cshuaimin/ssr.nvim",
		keys = {
			{
				"<Leader>sr",
				function()
					require("ssr").open()
				end,
				mode = { "n", "x" },
				desc = "Structural replace",
				silent = true,
			},
		},
		opts = {
			min_width = 50,
			min_height = 5,
			max_width = 120,
			max_height = 25,
			keymaps = {
				close = "q",
				next_match = "n",
				prev_match = "N",
				replace_confirm = "<CR>",
				replace_all = "<Leader><CR>",
			},
		},
	},
	{ "https://github.com/stevearc/dressing.nvim", opts = { input = { insert_only = false } } },
	"https://github.com/Eandrju/cellular-automaton.nvim",
}
