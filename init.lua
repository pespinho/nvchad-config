-- Color the nth column of the editor.
vim.opt.colorcolumn = "80"

-- Set english as the language of Neovim.
vim.api.nvim_exec('language en_US', true)

-- Show relative numbers as default.
vim.opt.relativenumber = true
vim.opt.number = true

-- Primeagen Options
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50
