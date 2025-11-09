vim.g.mapleader = " "

--show keymap help in telescope
vim.keymap.set('n', '<leader>tk', '<Cmd>Telescope keymaps<CR>', { desc = "[T]elescope kemaps" })

-- show neovim help docs in telescope
vim.keymap.set('n', '<leader>th', '<Cmd>Telescope help_tags<CR>', { desc = "[T]elescope help docs" })

vim.keymap.set('n', '<leader>tp', '<Cmd>Telescope builtin<CR>', { desc = "[T]elescope pickers" })

--window manipulation
vim.keymap.set('n', '<leader>w', '<C-w>', { desc = "window manipulation" })

--Neotree toggle
vim.keymap.set('n', '<leader>nh', '<Cmd>Neotree toggle<CR><C-w>p', { desc = 'Hide Neotree side bar' })
vim.keymap.set('n', '<leader>nn', '<Cmd>Neotree toggle<CR><Cmd>Neotree toggle<CR><C-w>p',
    { desc = 'Refreshes Neotree side bar' })
vim.keymap.set('n', '<leader>nb', '<Cmd>Neotree buffers float<CR>', { desc = 'Opens Neotree buffers in floating window' })

--quit current window
vim.keymap.set('n', '<leader>q', '<Cmd>q<CR>', { desc = "Quit current window." })

--ctrl+s for saving
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc>:w<Enter>', { desc = "write current file" })

--source current buffer
vim.keymap.set('n', '<leader><leader>s', function()
        vim.cmd('source %')
        vim.cmd.echo("'file sourced!'")
    end,
    { desc = "source current file" })

--ctrl+/ for commenting out lines
--single line
vim.keymap.set('n', '<C-_>', '<Cmd>set operatorfunc=CommentOperator<CR>g@l', { desc = "comment/uncomment current line" })
--macos/iterm2
vim.keymap.set('n', '<C-/>', '<Cmd>set operatorfunc=CommentOperator<CR>g@l', { desc = "comment/uncomment current line" })

--multi line
vim.keymap.set('v', '<C-_>', '<Cmd>set operatorfunc=CommentOperator<CR>g@',
    { desc = "comment/uncomment current line or selection" })
--macos/iterm2
vim.keymap.set('v', '<C-/>', '<Cmd>set operatorfunc=CommentOperator<CR>g@',
    { desc = "comment/uncomment current line or selection" })

--git diff open/close
vim.keymap.set('n', '<leader>gdo', '<Cmd>DiffviewOpen<CR>', { desc = "[g]it [d]iff [o]pen" })
vim.keymap.set('n', '<leader>gdc', '<Cmd>DiffviewClose<CR>', { desc = "[g]it [d]iff [c]lose" })

--cd command
vim.keymap.set('n', '<leader>cd', ':cd ', { desc = "populate 'cd' in command mode" })

--paste, text overwritten sent to void buffer
vim.keymap.set('x', '<leader>p', '\"_dP',
    { desc = "paste, anything overwritten sent to void buffer. useful for overwritting multiple times." })

--copy to system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', '\"+y', { desc = "copy to system clipboard" })
-- vim.keymap.set({ 'n', 'v' }, '<leader>Y', '\"+Y', { desc = "copy to system clipboard" })

--delete to void buffer
vim.keymap.set({ 'n', 'v' }, '<leader>d', '\"_d', { desc = "deletes, contents sent to void buffer" })

--find and replace all
vim.keymap.set({ 'n', 'v' }, '<C-L>', ':%s/<C-r><C-w>//g<left><left>', { desc = "find and replace all" })

-- jump to last char in current line
vim.keymap.set({ 'n', 'v' }, '=', '$', { noremap = true, silent = true })
-- jump to first char in current line
vim.keymap.set({ 'n', 'v' }, '-', '0', { noremap = true, silent = true })
-- fix indentation
vim.keymap.set({ 'n', 'v' }, '$', '=', { noremap = true, silent = true })


--
