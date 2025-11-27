return {
	-- operators
	"https://github.com/tpope/vim-repeat", -- enables repeat `.` for plugins
	-- "https://github.com/tpope/vim-commentary", -- toggle comments `gc<motion>`
	{ "https://github.com/numToStr/Comment.nvim", opts = {} }, -- toggle comments `gc<motion>`
	"https://github.com/tpope/vim-surround", -- manage surrounding pairs `ds.. cs.. ys..`
	"https://github.com/tommcdo/vim-exchange", -- swap selections `cx<motion>` in normal `X` in visual
	{ "https://github.com/nvim-mini/mini.splitjoin", -- smarter `gJ` joins and split with `gS`
		versions = "*",
		opts = {},
	},
	"https://github.com/tpope/vim-speeddating", -- ctrl-x/a works on dates
	"https://github.com/Konfekt/vim-CtrlXA", -- ctrl-x/a works on other stuff
	"https://github.com/christoomey/vim-titlecase", -- Title Case mappings
	{ "https://github.com/johmsalas/text-case.nvim",
		opts = {}
	},
	{ "https://github.com/nvim-mini/mini.align",
		version = "*",
		opts = true
	},
	{ "https://github.com/dahu/Insertlessly", -- insert newline with enter
		init = function()
			vim.g.insertlessly_insert_newlines = 1
			vim.g.insertlessly_open_newlines = 0
			vim.g.insertlessly_backspace_past_bol = 1
			vim.g.insertlessly_delete_at_eol_joins = 1
			vim.g.insertlessly_insert_spaces = 0
			vim.g.insertlessly_cleanup_trailing_ws = 0
			vim.g.insertlessly_cleanup_all_ws = 0
			vim.g.insertlessly_adjust_cursor = 1
		end,
	},

	-- motions
	{
		"https://github.com/nvim-mini/mini.ai",
		opts = {
			custom_textobjects = {
			},
		}
	},
	{ "https://github.com/justinmk/vim-sneak", -- linewise `fFtT;,` and two char sneak `s.. S..`
		keys = {
			{ "s", "<Plug>Sneak_s", desc = "Sneak forwards" },
			{ "S", "<Plug>Sneak_S", desc = "Sneak backwards" },
			{ "f", "<Plug>Sneak_f", desc = "Move to next char" },
			{ "F", "<Plug>Sneak_F", desc = "Move to previous char" },
			{ "t", "<Plug>Sneak_t", desc = "Move before next char" },
			{ "T", "<Plug>Sneak_T", desc = "Move before previous char" },
			{ "z", "<Plug>Sneak_s", desc = "Sneak forwards", mode = "o" },
			{ "Z", "<Plug>Sneak_S", desc = "Sneak backwards", mode = "o" },
			{ ";", "<Plug>SneakNext" },
			{ ",", "<Plug>SneakPrevious" },
		},
	},
	{ "https://github.com/haya14busa/vim-asterisk", -- improved * search
		keys = {
			{ "*", "<Plug>(asterisk-z*)<Plug>(is-nohl-1)" },
			{ "#", "<Plug>(asterisk-z#)<Plug>(is-nohl-1)" },
			{ "g*", "<Plug>(asterisk-gz*)<Plug>(is-nohl-1)" },
			{ "g#", "<Plug>(asterisk-gz#)<Plug>(is-nohl-1)" },
		},
	},
	"https://github.com/andymass/vim-matchup", -- extended `%` jumping
	-- "https://github.com/wellle/targets.vim", -- extended motions `vin)`
	{ "https://github.com/kana/vim-textobj-indent", -- indent textobj `vii` event = { "BufReadPre", "BufNewFile" },
		dependencies = { "https://github.com/kana/vim-textobj-user" }, -- custom textobj engine, more textobj: https://github.com/kana/vim-textobj-user/wiki
	},
	{ "https://github.com/glts/vim-textobj-comment", -- comment textobj `vac`
		dependencies = { "https://github.com/kana/vim-textobj-user" },
	},
}
