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
            ensure_installed = { "lua", "c", "cpp", "bash", "markdown", "markdown_inline", "regex", "c_sharp", "jsonc",
                "yaml", "xml" },
            auto_install = true,
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
        dependencies = {
            { 'nvim-lua/plenary.nvim' }
        },
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
                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = "LSP definition" })
                    -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = "LSP hover" })
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
                    vim.keymap.set("n", "<leader>fd", function() vim.diagnostic.open_float({ border = "rounded" }) end,
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

            -- Tell the server the capability of foldingRange,
            -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }

            local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}

            for _, ls in ipairs(language_servers) do
                require('lspconfig')[ls].setup({
                    capabilities = capabilities
                })
            end

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
    },
    {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        version = "v2.*",
        build = "make install_jsregexp",
        opts = {
            history = true,
            updateevents = "TextChanged,TextChangedI",
            region_check_events = "InsertEnter",
            delete_check_events = "TextChanged,InsertLeave",
        },
    },
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        init = function()
            require("core.utils").load_mappings "nvimtree"
        end,
        opts = function()
            local options = require "plugins.configs.nvimtree"
            options.actions.open_file.resize_window = false
            return options
        end,
        config = function(_, opts)
            dofile(vim.g.base46_cache .. "nvimtree")
            require("nvim-tree").setup(opts)
        end,
    },
    {
        'javiorfo/nvim-soil',
        lazy = false,
        ft = "plantuml",
        config = function()
            -- If you want to change default configurations
        end
    },
    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "nvimtools/none-ls.nvim",
        lazy = false,
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.formatting.markdownlint,
                },
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        dependencies = {
            { "nvim-treesitter/nvim-treesitter" }
        },
        config = function()
            require 'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = { query = "@function.outer", desc = "Select function outer" },
                            ["if"] = { query = "@function.inner", desc = "Select function inner" },
                            ["ab"] = { query = "@block.outer", desc = "Select block outer" },
                            ["ib"] = { query = "@block.inner", desc = "Select block inner" },
                            ["ap"] = { query = "@parameter.outer", desc = "Select parameter outer" },
                            ["ip"] = { query = "@parameter.inner", desc = "Select parameter inner" },
                            ["ac"] = { query = "@call.outer", desc = "Select call outer" },
                            ["ic"] = { query = "@call.inner", desc = "Select call inner" },
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                        },
                    },
                },
            }
        end
    },
    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        config = function()
            require("copilot").setup({
                filetypes = {
                    lua = true
                },
                suggestion = {
                    auto_trigger = true
                }
            })
        end
    },
    {
        "kevinhwang91/nvim-ufo",
        lazy = false,
        config = function()
            vim.o.foldcolumn = '0' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            require('ufo').setup()
        end,
        dependencies = {
            { 'kevinhwang91/promise-async' }
        }
    },
    {
        "yaocccc/nvim-foldsign",
        event = "CursorHold",
        config = function()
            require('nvim-foldsign').setup({
                offset = -2,
                foldsigns = {
                    open = '', -- mark the beginning of a fold
                    close = '', -- show a closed fold
                    seps = { '│' }, -- open fold middle marker
                }
            })
        end
    },
    {
        'cameron-wags/rainbow_csv.nvim',
        lazy = false,
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    }
}

return plugins
