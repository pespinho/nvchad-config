-- Color the nth column of the editor.
vim.opt.colorcolumn = { "80", "120" }

-- Show relative numbers as default.
vim.opt.relativenumber = true
vim.opt.number = true

vim.lsp.set_log_level("debug")

-- Primeagen Options
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50
