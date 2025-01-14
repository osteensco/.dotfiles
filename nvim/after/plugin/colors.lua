vim.cmd.colorscheme(color)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "black" })
vim.cmd.highlight('DiagnosticError guifg=Red')
vim.cmd.highlight('DiagnosticUnderlineError guifg=Red')

-- this should work but doesn't?
-- vim.api.nvim_win_set_config(0,{border="solid"})
