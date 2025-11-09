local lspconfig = vim.lsp.config

local mason_lspconfig = require("mason-lspconfig")

-- diagnostics
local diagnostic_view_group = vim.api.nvim_create_augroup("diagnosticView", { clear = true })
local toggle_diagnostics = function()
    local group_len = vim.api.nvim_get_autocmds({ group = "diagnosticView" })
    if #group_len == 0 then
        vim.api.nvim_create_autocmd('CursorMoved', {
            callback = function()
                local win = vim.api.nvim_get_current_win()
                local width = vim.api.nvim_win_get_width(win)
                local col = width
                local _, float = vim.diagnostic.open_float(
                    nil,
                    { scope = "line", border = "rounded" }
                )
                if not float then
                    return
                end
                vim.api.nvim_win_set_config(float,
                    {
                        win = win,
                        relative = "win",
                        anchor = "NE",
                        row = 0,
                        col = col,
                    })
            end
        })
    else
        vim.api.nvim_clear_autocmds({ group = "diagnosticView" })
    end
    vim.api.nvim_exec_autocmds('CursorMoved', { group = "diagnosticView" })
end

vim.keymap.set({ 'n', 'v' }, '<leader>dt', toggle_diagnostics, { desc = "[d]iagnostic [t]oggle floating window" })




local on_attach = function(client, bufnr)
    local bufmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    bufmap('<leader>r', vim.lsp.buf.rename, 'lsp action - buf.rename')
    bufmap('<leader>a', vim.lsp.buf.code_action, 'lsp action - buf.code_action')

    bufmap('gd', vim.lsp.buf.definition, 'lsp action - [g]o to [d]efinition')
    bufmap('gD', vim.lsp.buf.declaration, 'lsp action - [g]o to [D]eclaration')
    bufmap('gI', vim.lsp.buf.implementation, 'lsp action - [g]o to [I]mplementation')
    bufmap('<leader>D', vim.lsp.buf.type_definition, 'lsp action - type_definition')

    bufmap('gr', require('telescope.builtin').lsp_references, 'lsp action - [g]o to Telescope [r]eferences')
    bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols,
        'lsp action - Telescope lsp_document_symbols. similar to github file contents view.')
    bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols,
        'lsp action - Telescope lsp_dynamic_workspace_symbols. looks everywhere.')

    bufmap('K',
        function(opts)
            opts = opts or {}
            opts.border = "rounded"
            vim.lsp.buf.hover(opts)
        end,
        'lsp action - hover docs'
    )

    -- jdtls is buggy with the auto formatter so we just skip that
    print(client.name)
    if client.name == "jdtls" then
        return
    end

    -- autoformater
    local auto_format_group = vim.api.nvim_create_augroup("autoformater", { clear = true })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = auto_format_group,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end
    })
end

local capabilities = require("blink.cmp").get_lsp_capabilities()

require('mason').setup({
    PATH = "/usr/local/go/bin:" .. vim.fn.getenv("PATH")
})
mason_lspconfig.setup({
    -- mason-lspconfig throws a warning about jdtls, so it's excluded in ensure_installed
    ensure_installed = {
        "sqlls",
        "gopls",
        "lua_ls",
        "basedpyright",
        "ts_ls",
        "bashls",
        "cssls",
        "html",
        "jsonls",
        -- "jdtls"
    },
    -- mason_lspconfig by default auto enables lsp servers listed under ensure_installed
})

-- base config
vim.lsp.config('*', {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['*'] = {
            ["ui.semanticTokens"] = true
        }
    }
})


-- language specific setups
lspconfig("lua_ls", {
    on_attach = on_attach,
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                -- library = {
                --     vim.env.VIMRUNTIME
                --     -- Depending on the usage, you might want to add additional paths here.
                --     -- "${3rd}/luv/library"
                --     -- "${3rd}/busted/library",
                -- }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
                library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    }
})


lspconfig("gopls", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        gopls = {
            ["ui.semanticTokens"] = true,
            directoryFilters = { "-**/node_modules" }
        }
    }
})

lspconfig("basedpyright", {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        python = {
            venvPath = vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV or vim.env.PYENV_ROOT,
        },
        basedpyright = {
            typeCheckingMode = "standard",
            ["ui.semanticTokens"] = true
        }
    }
})

lspconfig("jdtls", {
    settings = {
        java = {
            format = {
                enabled = false,
            },
        },
    },
})
-- mason-lspconfig throws a warning about jdtls, so it's excluded in ensure_installed
-- this means we have to manually enable it here
vim.lsp.enable("jdtls")
