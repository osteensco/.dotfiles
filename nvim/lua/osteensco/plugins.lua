return {

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
    },

    'tanvirtin/monokai.nvim',
    "cpea2506/one_monokai.nvim",

    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    -- mini plugins
    { 'echasnovski/mini.indentscope', version = '*' },
    { 'echasnovski/mini.pairs',       version = '*' },

    -- TODO
    --  - fork oil and add in neotree's file expansion and sidebar location.
    -- {
    --     'stevearc/oil.nvim',
    --     ---@module 'oil'
    --     ---@type oil.SetupOpts
    --     opts = {},
    --     -- Optional dependencies
    --     dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
    -- },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'L3MON4D3/LuaSnip',
        },

        version = '*',

        opts = {
            snippets = {
                expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
                active = function(filter)
                    if filter and filter.direction then
                        return require('luasnip').jumpable(filter.direction)
                    end
                    return require('luasnip').in_snippet()
                end,
                jump = function(direction) require('luasnip').jump(direction) end,
            },
            keymap = {
                preset = 'none',
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-h>'] = { 'hide', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },

                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },

                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'snippet_backward', 'fallback' },
                ['<C-n>'] = { 'snippet_forward', 'fallback' },

                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            signature = { enabled = true }
        },
    },

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },

    },

    -- 'folke/neodev.nvim',


    -- {
    --     'hrsh7th/nvim-cmp',
    --     dependencies = {
    --         'L3MON4D3/LuaSnip',
    --         'saadparwaiz1/cmp_luasnip',
    --         'rafamadriz/friendly-snippets',
    --
    --         'hrsh7th/cmp-nvim-lsp',
    --
    --     },
    -- },

    "terrortylor/nvim-comment",

    "sindrets/diffview.nvim",

    -- {
    --     "wookayin/semshi",
    --     build = ":UpdateRemotePlugins",
    --     version = "*",
    --     init = function()
    --         vim.g["semshi#error_sign"] = false
    --         vim.g["semshi#simplify_markup"] = false
    --         vim.g["semshi#mark_selected_nodes"] = false
    --         vim.g["semshi#update_delay_factor"] = 0.001
    --     end,
    --     -- config = function()
    --     --     any configuration post load
    --     -- end,
    -- },

    { 'VonHeikemen/lsp-zero.nvim', branch = 'v4.x' },

    "otavioschwanck/arrow.nvim",
    -- { dir = "/mnt/d/Programming Stuff/opensauce/arrow.nvim" },

    {
        'akinsho/toggleterm.nvim',
        version = '*',
    },

    {
        'osteensco/discordStatus.nvim',
        -- dir = "/mnt/d/Programming Stuff/opensauce/discordStatus.nvim",
        dependencies = { "osteensco/dotenv.nvim" },
    },

    {
        dir = "/mnt/c/Users/ostee/Desktop/Repos/opensauce/shadow-clone.nvim",
    },
    -- {
    --     "linux-cultist/venv-selector.nvim",
    --     dependencies = {
    --         "neovim/nvim-lspconfig",
    --         "mfussenegger/nvim-dap",
    --         "mfussenegger/nvim-dap-python", --optional
    --         {"nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    --     },
    --     lazy = false,
    --     branch = "regexp", -- This is the regexp branch, use this for the new version
    --     config = function()
    --         require("venv-selector").setup({
    --             settings = {
    --                 search = {
    --                     cwd = false,
    --                     my_venvs = {
    --                         command = "fdfind python$ ./venv"
    --                     }
    --                 },
    --                 options = {
    --                     enable_default_searches = false,
    --                     notify_user_on_venv_activation = true,
    --                     debug = true,
    --                     fd_binary_name = "fdfind"
    --                 }
    --             }
    --         })
    --     end,
    --     keys = {
    --         { "<leader>v", "<cmd>VenvSelect<cr>" },
    --     },
    -- },


}
