local lspconfig = vim.lsp.config

local mason_lspconfig = require("mason-lspconfig")

local lsp_zero = require("lsp-zero")

vim.diagnostic.config({
    float = {
        border = 'rounded',
    },
})
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
)

local on_attach = function(_, bufnr)
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

    bufmap('K', vim.lsp.buf.hover, 'lsp action - hover docs')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, {})
end

local capabilities = require("blink.cmp").get_lsp_capabilities()

--autoformater
lsp_zero.extend_lspconfig({
    sign_text = true,
    lsp_attach = function(client, bufnr)
        lsp_zero.buffer_autoformat()
    end
})

require('mason').setup({
    PATH = "/usr/local/go/bin:" .. vim.fn.getenv("PATH")
})
mason_lspconfig.setup({
    ensure_installed = {
        -- "sqlls",
        "gopls",
        "lua_ls",
        "basedpyright",
        "ts_ls",
        "bashls",
        "cssls",
        "html",
        "jsonls",
        "jdtls"
    },
    -- generic fallback setup
    handlers = {
        function(server_name)
            lspconfig(server_name, setup {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    [server_name] = {
                        ["ui.semanticTokens"] = true
                    }
                }
            })
        end,
        jdtls = function()
            -- empty function so that mason-lspconfig ignores jdtls.
            -- this is necessary so that we can effectively use nvim-jdtls
        end
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
    capabilities = capabilities,
    on_attach = on_attach
})
vim.lsp.enable("jdtls")
-- Java
-- vim.api.nvim_create_autocmd('FileType', {pattern = 'java', callback = function (args)
--     require("jdtls.jdtls_setup").setup()
-- end})
