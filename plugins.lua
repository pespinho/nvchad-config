local plugins = {
    {
        "NvChad/nvterm",
        config = function()
            require("nvterm").setup {
                terminals = {
                    shell = "bash --login",
                },
            }
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            return vim.tbl_deep_extend("force", require "plugins.configs.cmp", require "custom.configs.cmp")
        end,
        config = function(_, opts)
            require("cmp").setup(opts)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        opts = {
            ensure_installed = { "lua", "c", "cpp", "bash", "markdown", "markdown_inline", "regex", "c_sharp" },
        },
    },
    {
        "nvim-treesitter/playground",
        init = function()
            require("core.utils").lazy_load "playground"
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>fg", require("telescope.builtin").git_files, desc = "Find in repo" },
        },
    },
    {
        "theprimeagen/harpoon",
        keys = {
            { "<leader>aa", function() require("harpoon.mark").add_file() end,        desc = "Harpoon add", },
            { "<leader>am", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon menu", },
            { "<leader>a1", function() require("harpoon.ui").nav_file(1) end,         desc = "Harpoon nav 1", },
            { "<leader>a2", function() require("harpoon.ui").nav_file(2) end,         desc = "Harpoon nav 2", },
            { "<leader>a3", function() require("harpoon.ui").nav_file(3) end,         desc = "Harpoon nav 3", },
            { "<leader>a4", function() require("harpoon.ui").nav_file(4) end,         desc = "Harpoon nav 4", },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader><F5>", ":UndotreeToggle<CR>", desc = "Toggle Undotree" },
        },
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        lazy = false,
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {                            -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(function() vim.cmd([[MasonUpdate]]) end)
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required

        },
        init = function()
            local lsp = require('lsp-zero').preset({})

            lsp.on_attach(
                function(client, bufnr)
                    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "LSP declaration" })
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "LSP hover" })
                    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end,
                        { desc = "LSP implementation" })
                    vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.signature_help() end,
                        { desc = "LSP signature help" })
                    vim.keymap.set("n", "<leader>D", function() vim.lsp.buf.type_definition() end,
                        { desc = "LSP definition help" })
                    vim.keymap.set("n", "<leader>ra", function() require("nvchad.renamer").open() end,
                        { desc = "LSP rename" })
                    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
                        { desc = "LSP code action" })
                    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, { desc = "LSP references" })
                    vim.keymap.set("n", "<leader>fd", function() vim.diagnostic.open_float() { border = "rounded" } end,
                        { desc = "Floating diagnostic" })
                    vim.keymap.set("n", "<leader>dp",
                        function() vim.diagnostic.goto_prev { float = { border = "rounded" } } end,
                        { desc = "Goto prev" })
                    vim.keymap.set("n", "<leader>dn",
                        function() vim.diagnostic.goto_next { float = { border = "rounded" } } end,
                        { desc = "Goto next" })
                    vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist() end,
                        { desc = "Diagnostic setloclist" })
                    vim.keymap.set("n", "<leader>wa", function() vim.lsp.buf.add_workspace_folder() end,
                        { desc = "Add workspace folder" })
                    vim.keymap.set("n", "<leader>wr", function() vim.lsp.buf.remove_workspace_folder() end,
                        { desc = "Remove workspace folder" })
                    vim.keymap.set("n", "<leader>wl",
                        function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
                        { desc = "List workspace folders" })

                    lsp.buffer_autoformat()
                end
            )

            require('lspconfig').clangd.setup({
                on_init = function(client)
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

            -- (Optional) Configure lua language server for neovim
            local luaSetup = lsp.nvim_lua_ls()
            luaSetup.on_init = function(client)
                if luaSetup.on_init ~= nil then
                    luaSetup.on_init(client)
                end
                client.server_capabilities.semanticTokensProvider = nil
            end

            luaSetup.settings.Lua.format = {
                defaultConfig = {
                    ident_size = 4
                },
                enable = true
            }

            require('lspconfig').lua_ls.setup(luaSetup)

            lsp.setup()
        end
    },
    -- {
    --   "dense-analysis/ale",
    --   lazy = false,
    --   init = function()
    --     -- This will avoid ALE to output messages everytime the cursor moves.
    --     vim.g.ale_hover_cursor = 0
    --   end,
    --   config = function()
    --     vim.g.ale_use_neovim_diagnostics_api = 1
    --   end
    -- },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            { "<leader>tx", "<cmd>TroubleToggle<cr>", desc = "Trouble toggle" }
        }
    },
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        config = function()
            require "custom.configs.dap"
        end,
        keys = {
            { '<F5>',    function() require('dap').continue() end,          desc = "Debug continue" },
            { '<S-F5>',  function() require('dap').terminate() end,         desc = "Debug terminate" },
            { '<F10>',   function() require('dap').step_over() end,         desc = "Step Over" },
            { '<F11>',   function() require('dap').step_into() end,         desc = "Step Into" },
            { '<S-F11>', function() require('dap').step_out() end,          desc = "Step Out" },
            { '<F9>',    function() require('dap').toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            {
                '<leader>dh',
                function() require('dap.ui.widgets').hover() end,
                mode = { "n", "v" },
                desc =
                "DAP Hover"
            },
            {
                '<leader>dp',
                function() require('dap.ui.widgets').preview() end,
                mode = { "n", "v" },
                desc =
                "DAP Preview"
            },
            {
                '<leader>df',
                function()
                    local widgets = require('dap.ui.widgets')
                    widgets.centered_float(widgets.frames)
                end,
                mode = { "n" },
                desc = "DAP Frames"
            },
            {
                '<leader>ds',
                function()
                    local widgets = require('dap.ui.widgets')
                    widgets.centered_float(widgets.scopes)
                end,
                mode = { "n" },
                desc = "DAP Scopes"
            },
        }
    },
    {
        "rcarriga/nvim-dap-ui",
        lazy = false,
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        lazy = false,
        config = function()
            require 'treesitter-context'.setup {
                enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
                max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
                min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
                line_numbers = true,
                multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
                trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
                mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
                -- Separator between context and content. Should be a single character string, like '-'.
                -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
                separator = nil,
                zindex = 20,     -- The Z-index of the context window
                on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
            }
        end
    },
    {
        "jlcrochet/vim-razor",
        lazy = false
    },
    {
        "ggandor/leap.nvim",
        lazy = false,
        config = function()
            require('leap').add_default_mappings()
        end
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
        end
    }
}

return plugins
