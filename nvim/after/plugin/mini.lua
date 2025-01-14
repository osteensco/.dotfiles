-- mini's plugin setup functions

-- Auto complete for brackets, quotations, etc
require('mini.pairs').setup()

-- Show indentation more clearly
require('mini.indentscope').setup({
    draw = {
        delay = 10,
        animation = require('mini.indentscope').gen_animation.none()
    },
    options = {
        indent_at_cursor = false,
        try_as_border = true,
    },
    -- other symbols: '│', '⋮', '┆'
    symbol = '│',
})
