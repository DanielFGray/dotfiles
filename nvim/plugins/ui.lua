return {
	-- { 'https://github.com/flazz/vim-colorschemes',                               -- lots of colorschemes
	--   priority = 100,
	-- },
	"https://github.com/noahfrederick/vim-noctu", -- a simple terminal-based theme
	{
		"https://github.com/catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			transparent_background = true,
			dim_inactive = {
				enabled = false,
			},
		},
	},
	{
		"https://github.com/Mofiqul/dracula.nvim",
		opts = {
			italic_comment = true,
			colors = {
				bg = "NONE",
				-- menu = '#282A36',
			},
		},
	},
	{
		"https://github.com/folke/which-key.nvim", -- visual keybind navigator
		-- dependencies = { "https://github.com/afreakk/unimpaired-which-key.nvim" },
		keys = { "<leader>", "[", "]", "g", "v", "c", "d", "y", '"', "z", "<C-w>", "=", "@" },
		opts = {
			preset = "helix",
			spec = {
				{ "<leader>a", group = "ai" },
				{ "<leader>d", group = "db" },
				{ "<leader>e", group = "edit" },
				{ "<leader>f", group = "files" },
				{ "<leader>g", group = "git" },
				-- { "<leader>n", group = "narrow" },
				{ "<leader>l", group = "list" },
				{ "<leader>c", group = "code" },
				{ "<leader>t", group = "toggles/tabs" },
				{ "<leader>s", group = "swap/sub" },
				{ "<leader>se", group = "session" },
				{ "<leader>x", group = "tmux" },
			},
		},
	},
	{
		"https://github.com/goolord/alpha-nvim", -- fancy startup screen
		dependencies = {
			"https://github.com/nvim-tree/nvim-web-devicons",
			"https://github.com/folke/persistence.nvim",
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			dashboard.section.header.val = {
				"                                        ",
				"                                        ",
				"                                        ",
				"                                        ",
				"         //                 /*          ",
				"      ,(/(//,               *###        ",
				"    ((((((////.             /####%*     ",
				" ,/(((((((/////*            /########   ",
				"/*///((((((//////.          *#########/ ",
				"//////((((((((((((/         *#########/.",
				"////////((((((((((((*       *#########/.",
				"/////////(/(((((((((((      *#########(.",
				"//////////.,((((((((((/(    *#########(.",
				"//////////.  /(((((((((((,  *#########(.",
				"(////////(.    (((((((((((( *#########(.",
				"(////////(.     ,#((((((((((##########(.",
				"((//////((.       /#((((((((##%%######(.",
				"((((((((((.         #(((((((####%%##%#(.",
				"((((((((((.          ,((((((#####%%%%%(.",
				" .#(((((((.            (((((#######%%   ",
				"    /(((((.             .(((#%##%%/*    ",
				"      ,(((.               /(#%%#        ",
				"        ./.                 #*          ",
				"                                        ",
				"                                        ",
				"                                        ",
			}
			dashboard.section.buttons.val = {
				dashboard.button("r", "󰋚  Restore session", function()
					require("persistence").load({ last = true })
				end),
				dashboard.button("e", "󰈔  New file", ":enew <BAR> startinsert<CR>"),
				dashboard.button("o", "󰄉  Recent files", ":FzfLua oldfiles<CR>"),
				dashboard.button("p", "󰃰  Projects", function()
					require("snacks").picker.projects()
				end),
				dashboard.button("s", "󰍉  Search text", ":FzfLua live_grep<CR>"),
				dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
				dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
				dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
			}
			alpha.setup(dashboard.config)
		end,
	},
	"https://github.com/markonm/traces.vim", -- visual substitution highlight
	{
		"https://github.com/pocco81/true-zen.nvim", -- toggle ui elements
		keys = {
			{ "<Leader>tz", "<Cmd>TZAtaraxis<CR>", desc = "Toggle zenmode", mode = "n", silent = true },
		},
		opts = {
			callbacks = {
				open_pre = function()
					require("lualine").hide()
					require("barbecue.ui").toggle(false)
				end,
				close_pos = function()
					require("lualine").hide({ unhide = true })
					require("barbecue.ui").toggle(true)
					vim.cmd([[ Limelight! ]])
				end,
			},
		},
	},
	{
		"https://github.com/DanielFGray/DistractionFree.vim", -- toggle UI elements
		keys = {
			{ "<Leader>td", "<Cmd>DistractionsToggle<CR>", desc = "Toggle distractions", mode = "n", silent = true },
		},
	},
	{
		"https://github.com/junegunn/limelight.vim", -- helps focus on current paragraph
		cmd = { "Limelight" },
		lazy = true,
		init = function()
			vim.g.limelight_conceal_ctermfg = "black"
		end,
		keys = {
			{ "<Leader>tl", "<Cmd>Limelight!!<CR>", mode = "n", desc = "Toggle limelight", silent = true },
		},
	},
	{
		"https://github.com/nvim-mini/mini.indentscope",
		version = false,
		opts = {
			symbol = "│",
		},
		-- ignore these filetypes
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				desc = "Disable indentscope for certain filetypes",
				pattern = {
					"aerial",
					"alpha",
					"dashboard",
					"help",
					"lazy",
					"leetcode.nvim",
					"mason",
					"neo-tree",
					"NvimTree",
					"neogitstatus",
					"notify",
					"startify",
					"toggleterm",
					"Trouble",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
	{
		"https://github.com/SmiteshP/nvim-navic",
		opts = {
			highlight = true,
			depth_limit = 5,
			depth_limit_indicator = "...",
			separator = "  ",
			-- separator = '  ',
			lsp = {
				auto_attach = true,
			},
		},
	},
	{
		"https://github.com/nvim-lualine/lualine.nvim", -- fancy statusline
		event = "VeryLazy",
		dependencies = {
			"https://github.com/nvim-tree/nvim-web-devicons",
			"https://github.com/SmiteshP/nvim-navic",
			{ "https://github.com/jcdickinson/wpm.nvim", opts = {} },
			-- 'https://github.com/arkav/lualine-lsp-progress',
		},
		opts = function()
			local wpm = require("wpm")
			return {
				options = {
					-- disabled_filetypes = { statusline = { "alpha" } },
					globalstatus = true,
				},
				extensions = {
					"fzf",
					"fugitive",
					"nvim-tree",
					"neo-tree",
					"lazy",
				},
				sections = {
					lualine_c = {
						"filename",
						{ "navic", color_correction = "dynamic" },
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { "filetype" },
				},
			}
		end,
	},
	{
		"https://github.com/gorbit99/codewindow.nvim", -- minimap
		keys = {
			{
				"<Leader>tm",
				function()
					require("codewindow").toggle_minimap()
				end,
				mode = "n",
				desc = "Toggle minimap",
				silent = true,
			},
		},
		config = function()
			require("codewindow").setup({
				exclude_filetypes = { "help", "NvimTree", "Trouble" },
				window_border = "rounded",
			})
			vim.api.nvim_set_hl(0, "CodewindowBackground", { bg = "#222730" })
			vim.api.nvim_set_hl(0, "CodewindowError", { bg = "#ff0000" })
			vim.api.nvim_set_hl(0, "CodewindowWarn", { bg = "#ebcb8b" })
			vim.api.nvim_set_hl(0, "CodewindowAddition", {}) -- the color of the addition git sign
			vim.api.nvim_set_hl(0, "CodewindowDeletion", {}) -- the color of the deletion git sign
			vim.api.nvim_set_hl(0, "CodewindowUnderline", {}) -- the color of the underlines on the minimap
		end,
	},
	{
		"https://github.com/NvChad/nvim-colorizer.lua",
		lazy = true,
		opts = {
			buftypes = {
				"!prompt",
				"!popup",
				"!mason",
			},
			user_default_options = {
				tailwind = true,
			},
		},
	},
	{
		"https://github.com/akinsho/bufferline.nvim", -- visual "tabs" for buffers up top aka tabline
		event = "VeryLazy",
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"[b",
				function()
					require("bufferline").cycle(-1)
				end,
				desc = "Prev buffer",
				mode = "n",
				silent = true,
			},
			{
				"]b",
				function()
					require("bufferline").cycle(1)
				end,
				desc = "Next buffer",
				mode = "n",
				silent = true,
			},
			{
				"[B",
				function()
					require("bufferline").move(-1)
				end,
				desc = "Move buffer left",
				mode = "n",
				silent = true,
			},
			{
				"]B",
				function()
					require("bufferline").move(1)
				end,
				desc = "Move buffer right",
				mode = "n",
				silent = true,
			},
		},
		opts = {
			options = {
				separator_style = "slant",
				-- style_preset = bufferline.style_preset.default,
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				hover = { enabled = true },
			},
		},
	},
}
