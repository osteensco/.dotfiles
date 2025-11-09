-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    command = "wincmd L",
})

-- auto resize splits
vim.api.nvim_create_autocmd("VimResized", {
    command = "wincmd ="
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_comment", {}),
    callback = function()
        vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end
})

-- highligh references when stopping cursor
vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("RefHighligh", { clear = true }),
    desc = "Highlights references under cursor",
    callback = function()
        if vim.fn.mode() ~= "i" then
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            local supports_highlight = false
            for _, client in ipairs(clients) do
                if client.server_capabilities.documentHighlightProvider then
                    supports_highlight = true
                    break
                end
            end
            if supports_highlight then
                vim.lsp.buf.clear_references()
                vim.lsp.buf.document_highlight()
            end
        end
    end,
})
