local plugins = {
  {
    "NvChad/nvterm",
    config = function ()
      require("nvterm").setup({
        terminals = {
          shell = "bash --login"
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "clangd",
        "cpplint",
        "clang-format"
      },
    },
  },
  {
    "neovim/nvim-lspconfig",

     dependencies = {
       "jose-elias-alvarez/null-ls.nvim",
       config = function()
         require "custom.configs.null-ls"
       end,
     },

    config = function()
        require "plugins.configs.lspconfig"
        require "custom.configs.lspconfig"
    end,
  }
}

return plugins
