require('toggleterm').setup({
    autochdir = true,
    open_mapping = [[<c-\>]],
    shade_terminals = false,
    hide_numbers = true,
    start_in_insert = true,
    direction = 'float',
    persist_size = true,
    persist_mode = true,
    close_on_exit = false,
    float_opts = {
        border = 'double',
        width = math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 15))),
        height = math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 5))),
        winblend = 0,
        title_pos = 'center',
    },
    highlights = {
        FloatBorder = {
            guifg = '#FF8200',
        },
        -- Normal = {
        --     guibg = '#ffffff',
        -- },
        NormalFloat = {
            link = 'Normal',
        },
    },
})
