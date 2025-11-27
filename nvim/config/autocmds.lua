vim.api.nvim_create_user_command("ReadUrl", function(opts)
	local url = opts.fargs[1]
	vim.cmd(string.format("0r !curl -sL %s", url))
end, { nargs = 1, bang = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			-- on_visual = false,
			timeout = 750,
		})
	end,
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	pattern = "*",
})

-- vim.api.nvim_create_autocmd('BufReadPost', {
--   callback = function()
--     local mark = vim.api.nvim_buf_get_mark(0, '"')
--     local lcount = vim.api.nvim_buf_line_count(0)
--     if mark[1] > 0 and mark[1] <= lcount then
--       pcall(vim.api.nvim_win_set_cursor, 0, mark)
--     end
--   end,
-- })

-- open :Alpha when all buffers are deleted
vim.api.nvim_create_autocmd("BufUnload", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("AlphaOnEmpty", { clear = true }),
	callback = function()
		if #vim.api.nvim_list_wins() == 0 then
			vim.cmd("Alpha")
		end
	end,
})

-- restore last known cursor position
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})

vim.cmd([[
augroup Vim
" always wrap autocmds in an augroup
" reset the augroup so autocmds don't stack on reload
autocmd!

"" enable treesitter by default
" autocmd BufReadPre *
" \ TSEnable highlight

" reload init.lua on save
autocmd BufWritePost $MYVIMRC
\ execute 'luafile %'

" start git commits in insert mode with spelling and textwidth
autocmd FileType gitcommit
\ setlocal spell textwidth=72 |
\ startinsert

" use q to close non-files (help, quickfix, etc)
autocmd BufEnter *
\ if &buftype != '' |
\   nnoremap <silent><buffer> q :<C-u>bw<CR> |
\ endif

" open :help to the right at 80 columns
autocmd FileType help
\ wincmd L |
\ vert resize 81

" open :Alpha when all buffers are deleted
autocmd BufUnload *
\ if bufnr('$') <= 1 | Alpha | endif

" expand help when focused
autocmd BufEnter *
\ if &filetype ==? 'help' |
\   execute 'normal 0' |
\   vert resize 81 |
\ endif

autocmd TermOpen *
\ setlocal nonu nornu signcolumn=no

autocmd FileType sql let b:did_ftplugin=1

augroup END
colorscheme catppuccin-mocha
]])
