local telescope = require('telescope')
local builtin = require('telescope.builtin')

telescope.setup({
    defaults = {
        layout_strategy = "bottom_pane",
        layout_config = {
            height = 0.9,
            prompt_position = "bottom",
        },
        border = true,
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
                ["<Tab>"] = "move_selection_next",
                ["<S-Tab>"] = "move_selection_previous",
                ["<C-a>"] = "add_selection",
                ["<C-r>"] = "remove_selection",
                ["<S-Right>"] = "results_scrolling_right",
                ["<S-Left>"] = "results_scrolling_left",
            },

        }
    },
    extensions = { fzf = {} }
})

telescope.load_extension('fzf')

-- telescope mappings
vim.keymap.set('n', '<leader>tt', builtin.find_files, { desc = '[t]elescope [f]ind [f]iles, looks at all files' })
vim.keymap.set('n', '<leader>tf', builtin.git_files,
    { desc = '[t]elescope project [f]iles, looks at files within git repo' })
vim.keymap.set('n', '<leader>ts', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end,
    { desc = '[t]elescopt project [s]earch, takes a string a searches for it in files within git repo' })
vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = '[t]elescope [d]iagnostics' })
vim.keymap.set('n', '<leader>tr', builtin.resume, { desc = '[t]elescope [r]esume, opens last accessed telescope picker' })
