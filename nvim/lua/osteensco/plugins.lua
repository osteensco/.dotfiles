return {

    {
        'nvim-telescope/telescope.nvim',
        branch = 'master',
        dependencies = { 'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
    },

    "cpea2506/one_monokai.nvim",
    "folke/tokyonight.nvim",

    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },

    -- mini plugins
    { 'echasnovski/mini.indentscope', version = '*' },
    { 'echasnovski/mini.pairs',       version = '*' },


    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/nvim-treesitter-textObjects",
    },


    -- completions
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

            signature = {
                window = { border = "rounded" },
                enabled = true
            },

            completion = {
                menu = { border = "rounded" }
            },
        },
    },

    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
        "neovim/nvim-lspconfig",
        -- opts = {
        --     automatic_enable = {
        --         exclude = {
        --             -- exclude this since it is configured via nvim-jdtls
        --             'jdtls'
        --         }
        --     }
        -- },
        dependencies = { 'saghen/blink.cmp' },

    },

    "terrortylor/nvim-comment",

    "sindrets/diffview.nvim",



    "otavioschwanck/arrow.nvim",

    {
        "sphamba/smear-cursor.nvim",
        opts = {},
    },

    {
        'osteensco/discordStatus.nvim',
        -- dir = "path/to/plugin/repo",
        dependencies = { "osteensco/dotenv.nvim" },
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
    },

    -- Java stuff
    -- "mfussenegger/nvim-jdtls",


}
