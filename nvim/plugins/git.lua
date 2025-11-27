return {
	{
		"https://github.com/tpope/vim-fugitive",
		lazy = false,
		dependencies = { "https://github.com/tpope/vim-rhubarb" },
		keys = {
			{ "<Leader>gc", "<Cmd>Git commit --verbose<CR>", desc = "Commit", mode = "n" },
		},
	},
	{
		"https://github.com/lewis6991/gitsigns.nvim", -- git markers
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text_pos = "right_align",
			},
			current_line_blame_formatter = "<author> <author_time:%R> <summary>",
			-- signcolumn = false,
			preview_config = {
				border = "single",
			},
			-- word_diff = true,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				vim.keymap.set("n", "[g", gitsigns.prev_hunk, { buffer = bufnr, desc = "Jump to previous hunk" })
				vim.keymap.set("n", "]g", gitsigns.next_hunk, { buffer = bufnr, desc = "Jump to next hunk" })
				vim.keymap.set("n", "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
				vim.keymap.set(
					"n",
					"<leader>gu",
					gitsigns.undo_stage_hunk,
					{ buffer = bufnr, desc = "Undo stage hunk" }
				)
				vim.keymap.set("n", "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
				vim.keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
				vim.keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
				vim.keymap.set(
					"n",
					"<leader>gb",
					gitsigns.blame_line,
					{ buffer = bufnr, desc = "Show blame information" }
				)
				vim.keymap.set(
					"n",
					"<leader>gS",
					gitsigns.stage_buffer,
					{ buffer = bufnr, desc = "Stage entire buffer" }
				)
				vim.keymap.set("n", "<leader>gD", gitsigns.diffthis, { buffer = bufnr, desc = "Diff buffer" })
				vim.keymap.set(
					"n",
					"<leader>gT",
					gitsigns.toggle_current_line_blame,
					{ buffer = bufnr, desc = "Toggle blame on current line" }
				)
				vim.keymap.set(
					"n",
					"<leader>tg",
					gitsigns.toggle_current_line_blame,
					{ buffer = bufnr, desc = "Toggle blame on current line" }
				)
				vim.keymap.set("n", "<leader>gD", gitsigns.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted" })
			end,
		},
	},
}
