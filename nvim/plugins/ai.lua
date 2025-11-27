return {
	{
		"https://github.com/zbirenbaum/copilot.lua",
		dependencies = {
			"https://github.com/copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
		},
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_duiring_completion = true,
				keymap = {
					accept = "<Tab>",
					accept_word = "<Right>",
					accept_line = "<End>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			nes = {
				enabled = false, -- requires copilot-lsp as a dependency
				auto_trigger = true,
				keymap = {
					-- accept_and_goto = "<C-y>",
					dismiss = "<C-l>",
				},
			},
		},
	},

	{
		"https://github.com/folke/sidekick.nvim",
		dependencies = {
			{
				"https://github.com/saghen/blink.cmp",
				--- @param opts blink.cmp.Config
				opts = function(_, opts)
					opts.keymap = vim.tbl_deep_extend("force", opts.keymap or {}, {
						["<Tab>"] = {
							"snippet_forward",
							function()
								return require("sidekick").nes_jump_or_apply()
							end,
							function()
								return vim.lsp.inline_completion.get()
							end,
							"fallback",
						},
					})
					return opts
				end,
			},
		},
		opts = {
			cli = {
				win = {
					layout = "right",
				},
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		keys = {
			{
				"<tab>",
				function()
					if not require("sidekick").nes_jump_or_apply() then
						return "<Tab>"
					end
				end,
				expr = true,
				desc = "Goto/Apply Next Edit Suggestion",
				mode = "n",
			},
			-- {"<c-.>", function() require("sidekick.cli").toggle() end, desc = "Sidekick Toggle", mode = { "n", "t", "i", "x" },},
			{
				"<leader>aa",
				function()
					require("sidekick.cli").toggle({ name = "opencode" })
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>as",
				function()
					require("sidekick.cli").select({ filter = { installed = true } })
				end,
				desc = "Select CLI",
			},
			{
				"<leader>ad",
				function()
					require("sidekick.cli").close()
				end,
				desc = "Detach a CLI Session",
			},
			{
				"<leader>at",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>af",
				function()
					require("sidekick.cli").send({ msg = "{file}" })
				end,
				desc = "Send File",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			-- {"<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Sidekick Toggle Claude",},
		},
	},

	{
		"https://github.com/olimorris/codecompanion.nvim",
		dependencies = {
			"https://github.com/nvim-lua/plenary.nvim",
			"https://github.com/nvim-treesitter/nvim-treesitter",
		},
		opts = {
			strategies = {
				cmd = { adapter = "copilot", model = "gpt-5" },
				chat = { adapter = "copilot", model = "gpt-5" },
				inline = { adapter = "copilot", model = "gpt-5" },
			},
			-- NOTE: The log_level is in `opts.opts`
			opts = {
				log_level = "DEBUG", -- or "TRACE"
			},
		},
	},

	{
		"https://github.com/ravitemer/mcphub.nvim",
		dependencies = {
			"https://github.com/nvim-lua/plenary.nvim",
		},
		build = "bun install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
		opts = {
			global_env = function(context)
				local env = {
					ALLOWED_DIRECTORY = vim.fn.getcwd(),
				}
				if context.is_workspace_mode then
					env.ALLOWED_DIRECTORY = context.workspace_root
				end
				return env
			end,
		},
	},

	{
		"https://github.com/sudo-tee/opencode.nvim",
		opts = {
			preferred_completion = "blink",
			preferred_picker = "fzf", -- 'telescope', 'fzf', 'mini.pick', 'snacks', if nil, it will use the best available picker. Note mini.pick does not support multiple selections
			default_mode = "plan",
			keymap = {
				session_picker = {
					delete_session = { "<C-d>" }, -- Delete selected session in the session picker
				},
				permission = {
					accept = "a", -- Accept permission request once (only available when there is a pending permission request)
					accept_all = "A", -- Accept all (for current tool) permission request once (only available when there is a pending permission request)
					deny = "d", -- Deny permission request once (only available when there is a pending permission request)
				},
				editor = {
					["<leader>og"] = {},
					["<leader>oo"] = { "toggle" },
				},
				input_window = {
					["<cr>"] = { "submit_input_prompt", mode = { "n" } }, -- Submit prompt (normal mode and insert mode)
					["<esc>"] = { "cancel", mode = { "n" } }, -- Cancel input (normal mode)
					["<tab>"] = { "switch-mode" },
					["<q>"] = { "close" },
					["<LocalLeader>pa"] = { "permission_accept" }, -- Accept permission request once
					["<LocalLeader>pA"] = { "permission_accept_all" }, -- Accept all (for current tool)
					["<LocalLeader>pd"] = { "permission_deny" }, -- Deny permission request once
				},
				output_window = {
					["<esc>"] = { "cancel" },
					["<q>"] = { "close" },
					["]]"] = { "next_message" }, -- Navigate to next message in the conversation
					["[["] = { "prev_message" }, -- Navigate to previous message in the conversation
					["<tab>"] = { "toggle_pane", mode = { "n", "i" } }, -- Toggle between input and output panes
					["i"] = { "focus_input", "n" }, -- Focus on input window and enter insert mode at the end of the input from the output window
					["<LocalLeader>pa"] = { "permission_accept" }, -- Accept permission request once
					["<LocalLeader>pA"] = { "permission_accept_all" }, -- Accept all (for current tool)
					["<LocalLeader>pd"] = { "permission_deny" }, -- Deny permission request once
				},
			},
			ui = {
				position = "right",
			},
		},
		dependencies = {
			"https://github.com/nvim-lua/plenary.nvim",
			{
				"https://github.com/MeanderingProgrammer/render-markdown.nvim",
				opts = {
					anti_conceal = { enabled = false },
					file_types = { "markdown", "opencode_output" },
				},
				ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
			},
			-- Optional, for file mentions and commands completion, pick only one
			"https://github.com/saghen/blink.cmp",
			-- 'hrsh7th/nvim-cmp',
			-- Optional, for file mentions picker, pick only one
			-- 'nvim-telescope/telescope.nvim',
			"https://github.com/ibhagwan/fzf-lua",
			-- 'nvim_mini/mini.nvim',
		},
	},
}
