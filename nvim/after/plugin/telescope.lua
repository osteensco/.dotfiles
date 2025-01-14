local builtin = require('telescope.builtin')


local function get_telescope_pickers_with_theme(default_theme)
    local pickers = {}

    for picker_name, _ in pairs(builtin) do
        pickers[picker_name] = {
            theme = default_theme or "ivy",
        }
    end

    return pickers
end

local pickers = get_telescope_pickers_with_theme()

require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ["<Tab>"] = "move_selection_next",
                ["<S-Tab>"] = "move_selection_previous",
                ["<C-a>"] = "add_selection",
                ["<C-r>"] = "remove_selection",
            },
        }
    },
    pickers = pickers,
    extensions = { fzf = {} }
})

require('telescope').load_extension('fzf')

vim.keymap.set('n', '<leader>tt', builtin.find_files, { desc = '[t]elescope [f]ind [f]iles, looks at all files' })
vim.keymap.set('n', '<leader>tf', builtin.git_files,
    { desc = '[t]elescope project [f]iles, looks at files within git repo' })
vim.keymap.set('n', '<leader>ts', function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end,
    { desc = '[t]elescopt project [s]earch, takes a string a searches for it in files within git repo' })
vim.keymap.set('n', '<leader>td', builtin.diagnostics, { desc = '[t]elescope [d]iagnostics' })
