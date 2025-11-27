vim.opt.winborder = "rounded"
vim.opt.autoread = true
vim.opt.backspace = "indent,eol,start" -- backspace over everything
-- vim.opt.colorcolumn = { 80 } -- highlight 80th column
vim.opt.confirm = true -- y/n save prompt on quit
vim.opt.equalalways = true
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- fold by expressions
vim.opt.foldlevelstart = 999 -- open all folds by default
vim.opt.foldmethod = "expr"
vim.opt.hidden = true -- switch buffers without saving
vim.opt.hlsearch = true
vim.opt.incsearch = true -- visual searching
vim.opt.ignorecase = true
vim.opt.linebreak = true -- break at word boundaries when wrap enabled
vim.opt.list = true
vim.opt.shiftwidth = 0
vim.opt.tabstop = 2
vim.opt.listchars = { tab = "  ", trail = "★" } -- visible tab chars and trailing spaces
vim.opt.listchars:append({ extends = "»", precedes = "«" }) -- custom line wrap chars
-- vim.opt.listchars:append({ eol = '¬', space = '🞄' })                        -- visible space and eol chars (very noisy)
vim.opt.modeline = true
vim.opt.mouse = "nv" -- mouse on for normal,visual mode (but not insert while typing)
vim.opt.number = true -- toggle with yon                    -- show current line number (0 with rnu)
vim.opt.relativenumber = true -- toggle with yor                    -- line numbers relative to current position
vim.opt.showcmd = true -- visual operator pending
vim.opt.showmode = false -- hide mode indicator from command (already shown in statusline)
vim.opt.showtabline = 2 -- always show tabline
vim.opt.laststatus = 3 -- always show one statusline across all splits
vim.opt.signcolumn = "yes" -- always keep the sign column open
vim.opt.smarttab = true
vim.opt.splitright = false -- split defaults
vim.opt.timeoutlen = 100 -- see help
vim.opt.ttimeoutlen = 100 -- see help
vim.opt.backupcopy = "yes"
vim.opt.backupdir = vim.fn.stdpath("config") .. "/backups//" -- vim backups in vim dir
vim.opt.undodir = vim.fn.stdpath("config") .. "/undo//" -- undofiles in vim dir
vim.opt.directory = vim.fn.stdpath("config") .. "/swaps//" -- swap files in vim dir
vim.opt.undofile = true -- enable persistent undo files
vim.opt.updatetime = 100 -- cursorhold time and writing swap file debounce time in ms,
vim.opt.wrap = false -- toggle with yow                    -- disable linewrap
-- vim.opt.termguicolors = true
--                    ╒══ Disable hlsearch while loading viminfo
--                    │ ╒══ Remember marks for last 500 files
--                    │ │    ╒══ Remember last 1000 commands
--                    │ │    │     ╒══ Remember last 1000 search patterns
--                    │ │    │     │     ╒══ Remember up to 1MB in each register
--                    │ │    │     │     │     ╒═══ Remember up to 10000 lines in each register
--                    │ │    │     │     │     │
--                    │ │    │     │     │     │
vim.cmd([[set viminfo=h,'500,:1000,/1000,s1000,<10000]])

vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
