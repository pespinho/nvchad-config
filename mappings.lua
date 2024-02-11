local M = {}

M.general = {
    n = {
        ["<C-h>"] = { "<cmd> TmuxNavigateLeft<CR>", "window left" },
        ["<C-l>"] = { "<cmd> TmuxNavigateRight<CR>", "window right" },
        ["<C-j>"] = { "<cmd> TmuxNavigateDown<CR>", "window down" },
        ["<C-k>"] = { "<cmd> TmuxNavigateUp<CR>", "window up" },
        ["<C-d>"] = { "<C-d>zz", "scroll half page down and center" },
        ["<C-u>"] = { "<C-u>zz", "scroll half page up and center" },
        ["<n>"] = { "nzzzv", "search next and center" },
        ["<N>"] = { "Nzzzv", "search previous and center" },
        ["<leader>ca"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "code action" },
        ["zR"] = { function() require('ufo').openAllFolds() end, "open all folds" },
        ["zM"] = { function() require('ufo').closeAllFolds() end, "close all folds" },
        ["K"] = {
            function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
            "hover"
        }
    },
    v = {
        ["J"] = { ":m '>+1<CR>gv=gv", "move line down" },
        ["K"] = { ":m '<-2<CR>gv=gv", "move line up" },
    },
    t = {
        ["<C-h>"] = { "<C-\\><C-N><C-w>h", "window left" },
        ["<C-l>"] = { "<C-\\><C-N><C-w>l", "window right" },
        ["<C-j>"] = { "<C-\\><C-N><C-w>j", "window down" },
        ["<C-k>"] = { "<C-\\><C-N><C-w>k", "window up" },
    }
}

return M
