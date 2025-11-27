local map = function(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.cmd([[
" expand %% in the command prompt to the current dir
cabbrev %% <C-r>=fnameescape(expand('%:h'))<CR>

" common typing mistakes
iabbrev functino function
iabbrev seperate separate
iabbrev actino action
iabbrev improt import
iabbrev frmo from
iabbrev teh the

" common command typos
command! -bang W w<bang>
command! -bang Q q<bang>
command! -bang Qa qa<bang>
command! -bang QA qa<bang>
command! -bang Wa wa<bang>
command! -bang WA wa<bang>
command! -bang Wqa wqa<bang>
command! -bang WQa wqa<bang>
command! -bang WQA wqa<bang>
]])

-- make Y behave like C and D
map("", "Y", "y$")

-- -- case insensitive search
-- map('n', '/', "/\\c")

-- swap ' and `
map("", "'", "`")
map("", "`", "'")

-- re-select after indent
map("x", "<", "<gv")
map("x", ">", ">gv")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- an attempt at exclusive folds
map("n", "zj", "zjzMzvzz", { desc = "Jump to the fold below", silent = true })
map("n", "zk", "zkzMzvzz", { desc = "Jump to the fold above", silent = true })
map("n", "za", "zazMzvzz", { desc = "Toggle fold under cursor", silent = true })

-- easy tab size changing
map("n", "<Leader>t2", "<Cmd>setl ts=2 sw=2<CR>", { desc = "Set tabsize to 2", silent = true })
map("n", "<Leader>t4", "<Cmd>setl ts=4 sw=4<CR>", { desc = "Set tabsize to 4", silent = true })
map("n", "<Leader>t8", "<Cmd>setl ts=8 sw=8<CR>", { desc = "Set tabsize to 8", silent = true })

-- quicker :s mappings
-- see also :h c_CTRL-R_CTRL-W
map("n", "<Leader>ss", "<esc>:s///gc<left><left><left>", { desc = ":substitute on current line" })
map("n", "<Leader>sS", "<esc>:%s///gc<left><left><left>", { desc = ":substitute on all lines" })
map("x", "<Leader>ss", ":s///gc<left><left><left>", { desc = ":substitute on selection" })

-- insert timestamp with ctrl-t
map({ "c", "i" }, "<C-t>", '<C-r>=strftime("%FT%TZ")<Left><Left>', { desc = "Insert timestamp", silent = true })

map("n", "<A-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<A-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<A-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<A-l>", "<C-w>l", { desc = "Go to right window" })
map("t", "<A-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
map("t", "<A-j>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
map("t", "<A-k>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
map("t", "<A-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
