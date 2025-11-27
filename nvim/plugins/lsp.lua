return {
	{
		"https://github.com/neovim/nvim-lspconfig", -- main LSP config
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			-- Mason must be loaded before its dependents so we need to set it up here.
			-- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
			{
				"https://github.com/mason-org/mason.nvim",
				opts = {
					handlers = {
						-- The first item matches everything
						function(package)
							-- Use the default installer for non-npm packages
							require("mason.builtin-handlers.default")(package)
						end,
						-- This item overrides the handler for packages where the install command starts with npx
						["^npm"] = function(package)
							local install_cmd = { "bun", package.name }
							require("mason.install").install_package(package, install_cmd)
						end,
						["^npx"] = function(package)
							local install_cmd = { "bunx", package.name }
							require("mason.install").install_package(package, install_cmd)
						end,
					},
				},
			},
			"https://github.com/mason-org/mason-lspconfig.nvim",
			"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			"https://github.com/j-hui/fidget.nvim",

			-- Allows extra capabilities provided by blink.cmp
			"https://github.com/saghen/blink.cmp",
			"https://github.com/SmiteshP/nvim-navic",
		},
		config = function()
			-- Brief aside: **What is LSP?**
			--
			-- LSP is an initialism you've probably heard, but might not understand what it is.
			--
			-- LSP stands for Language Server Protocol. It's a protocol that helps editors
			-- and language tooling communicate in a standardized fashion.
			--
			-- In general, you have a "server" which is some tool built to understand a particular
			-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
			-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
			-- processes that communicate with some "client" - in this case, Neovim!
			--
			-- LSP provides Neovim with features like:
			--  - Go to definition
			--  - Find references
			--  - Autocompletion
			--  - Symbol Search
			--  - and more!
			--
			-- Thus, Language Servers are external tools that must be installed separately from
			-- Neovim. This is where `mason` and related plugins come into play.
			--
			-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
			-- and elegantly composed help section, `:help lsp-vs-treesitter`

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
					vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show Diagnostic" })

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					vim.keymap.set("n", "grn", vim.lsp.buf.rename, { desc = "Rename" })

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					vim.keymap.set({ "n", "x" }, "gra", vim.lsp.buf.code_action, { desc = "Goto Code Action" })

					-- Find references for the word under your cursor.
					vim.keymap.set("n", "grr", require("fzf-lua").lsp_references, { desc = "Goto References" })

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					vim.keymap.set("n", "gri", require("fzf-lua").lsp_implementations, { desc = "Goto Implementation" })

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					vim.keymap.set("n", "grd", require("fzf-lua").lsp_definitions, { desc = "Goto Definition" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					vim.keymap.set("n", "grD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					vim.keymap.set(
						"n",
						"gO",
						require("fzf-lua").lsp_document_symbols,
						{ desc = "Open Document Symbols" }
					)

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					-- vim.keymap.set('n', 'gW', require('fzf-lua').lsp_dynamic_workspace_symbols, { desc = 'Open Workspace Symbols' })

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					-- vim.keymap.set('n', 'grt', require('fzf-lua').lsp_type_definitions, { desc = 'Goto Type Definition' })

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if client.server_capabilities.documentSymbolProvider then
						require("nvim-navic").attach(client, event.buf)
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					-- if
					-- 	client
					-- 	and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					-- then
					-- 	vim.keymap.set("n", "<leader>th", function()
					-- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					-- 	end, { desc = "Toggle Inlay Hints" })
					-- end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				},
				update_in_insert = false,
				virtual_text = {
					source = "if_many",
					spacing = 2,
					prefix = "●",
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine

				-- vtsls = {
				-- 	-- explicitly add default filetypes, so that we can extend
				-- 	-- them in related extras
				-- 	filetypes = {
				-- 		"javascript",
				-- 		"javascriptreact",
				-- 		"javascript.jsx",
				-- 		"typescript",
				-- 		"typescriptreact",
				-- 		"typescript.tsx",
				-- 	},
				-- 	settings = {
				-- 		complete_function_calls = true,
				-- 		vtsls = {
				-- 			enableMoveToFileCodeAction = true,
				-- 			autoUseWorkspaceTsdk = true,
				-- 			experimental = {
				-- 				maxInlayHintLength = 30,
				-- 				completion = {
				-- 					enableServerSideFuzzyMatch = true,
				-- 				},
				-- 			},
				-- 		},
				-- 		typescript = {
				-- 			tsserver = { pluginPaths = { "./node_modules" } },
				-- 			updateImportsOnFileMove = { enabled = "always" },
				-- 			suggest = {
				-- 				completeFunctionCalls = true,
				-- 			},
				-- 			inlayHints = {
				-- 				enumMemberValues = { enabled = true },
				-- 				functionLikeReturnTypes = { enabled = true },
				-- 				parameterNames = { enabled = "literals" },
				-- 				parameterTypes = { enabled = true },
				-- 				propertyDeclarationTypes = { enabled = true },
				-- 				variableTypes = { enabled = false },
				-- 			},
				-- 		},
				-- 	},
				-- },

				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"https://github.com/saghen/blink.cmp", -- autocompletion plugin
		event = "InsertEnter",
		version = "1.*",
		dependencies = {
			"https://github.com/nvim-lua/plenary.nvim",
			{ -- Snippet Engine
				"https://github.com/L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					{
						"https://github.com/rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
			"https://github.com/folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- 'default' (recommended) for mappings similar to built-in completions
				--   <c-y> to accept ([y]es) the completion.
				--    This will auto-import if your LSP supports it.
				--    This will expand snippets if the LSP sent a snippet.
				-- 'super-tab' for tab to accept
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- For an understanding of why the 'default' preset is recommended,
				-- you will need to read `:help ins-completion`
				--
				-- No, but seriously. Please read `:help ins-completion`, it is really good!
				--
				-- All presets have the following mappings:
				-- <tab>/<s-tab>: move to right/left of your snippet expansion
				-- <c-space>: Open menu or open docs if already open
				-- <c-n>/<c-p> or <up>/<down>: Select next/previous item
				-- <c-e>: Hide menu
				-- <c-k>: Toggle signature help
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				preset = "enter",

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps

				["<C-u>"] = { "scroll_signature_up", "fallback" },
				["<C-d>"] = { "scroll_signature_down", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				-- By default, you may press `<c-space>` to show the documentation.
				-- Optionally, set `auto_show = true` to show the documentation after a delay.
				documentation = { auto_show = true, auto_show_delay_ms = 0 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},

			snippets = { preset = "luasnip" },

			-- Blink.cmp includes an optional, recommended rust fuzzy matcher,
			-- which automatically downloads a prebuilt binary when enabled.
			--
			-- By default, we use the Lua implementation instead, but you may enable
			-- the rust implementation via `'prefer_rust_with_warning'`
			--
			-- See :h blink-cmp-config-fuzzy for more information
			fuzzy = { implementation = "lua" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
	{
		"https://github.com/stevearc/conform.nvim", -- code formatter
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "n",
				desc = "Format buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
	{
		"https://github.com/j-hui/fidget.nvim", -- LSP status updates
		tag = "legacy",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			text = { spinner = "dots_negative" },
			display = { render_limit = 1 },
			timer = { spinner_rate = 150 },
		},
	},
	{
		"https://github.com/folke/lazydev.nvim", -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins used for completion, annotations and signatures of Neovim apis
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"https://github.com/oribarilan/lensline.nvim", -- configurable inlay hints
		event = "LspAttach",
		branch = "release/2.x",
		opts = {
			profiles = {
				{
					name = "minimal",
					style = {
						placement = "inline",
						prefix = "🔍", -- search icon,
						render = "focused", -- optionally render lenses only for focused function
					},
				},
			},
			debug_mode = true,
		},
	},
	{ "https://github.com/folke/neoconf.nvim", cmd = "Neoconf", opts = {} },
	{
		"https://github.com/rcarriga/nvim-dap-ui", -- Debug Adapter Protocol UI
		dependencies = {
			"https://github.com/mfussenegger/nvim-dap",
			{
				"https://github.com/mxsdev/nvim-dap-vscode-js",
				opts = {
					debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
					adapters = { "node-terminal", "pwa-node", "pwa-firefox" },
				},
			},
		},
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close
			local js_based_languages = { "typescript", "javascript", "typescriptreact" }
			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = 'Start Chrome with "localhost"',
						url = "http://localhost:3000",
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
					},
				}
			end
		end,
		keys = {
			{
				"<leader>dub",
				function()
					require("dap").toggle_breakpoint()
				end,
				mode = "n",
				desc = "Toggle breakpoint",
			},
			{
				"<leader>duB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				mode = "n",
				desc = "Conditional breakpoint",
			},
			{
				"<leader>duc",
				function()
					require("dap").continue()
				end,
				mode = "n",
				desc = "Continue",
			},
			{
				"<leader>dui",
				function()
					require("dap").step_into()
				end,
				mode = "n",
				desc = "Step into",
			},
			{
				"<leader>duu",
				function()
					require("dapui").toggle()
				end,
				mode = "n",
				desc = "Show debugger ui",
			},
			{
				"<leader>duo",
				function()
					require("dap").step_over()
				end,
				mode = "n",
				desc = "Step over",
			},
			{
				"<leader>duO",
				function()
					require("dap").step_out()
				end,
				mode = "n",
				desc = "Step out",
			},
			{
				"<leader>dus",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dut",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			-- { '<leader>du', function() require('dap').() end, mode = 'n', desc = '' },
		},
	},
}
