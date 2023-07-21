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
  },
  v = {
    ["J"] = { ":m '>+1<CR>gv=gv", "move line down" },
    ["K"] = { ":m '>-2<CR>gv=gv", "move line up" },
  }
}

return M
