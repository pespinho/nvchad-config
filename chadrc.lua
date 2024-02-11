---@type ChadrcConfig
local M = {}
M.ui = { theme = 'catppuccin' }
M.plugins = 'custom.plugins'
M.mappings = require "custom.mappings"
M.lazy_nvim = require "custom.configs.lazy_nvim" -- config for lazy.nvim startup options
return M
