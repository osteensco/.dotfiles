require("neo-tree").setup({

    default_component_configs = {
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󱧋",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon"
        }
    },

    filesystem = {
        filtered_items = {
            visible = true,
            hide_hidden = false
        },

        follow_current_file = {
            enabled = true
        },

        hijack_netrw_behavior = "open_default",

        window = {
            mappings = {
                [","] = "navigate_up",
                ["."] = "set_root",
                ["h"] = "toggle_hidden"
            }
        }

    },

})
