--[ LSP: server configs, keymaps
--  See: `:h lsp-quickstart` and `:h lsp-defaults`

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    -- Quickstart configs for LSP
    'https://github.com/neovim/nvim-lspconfig',
    -- Useful status updates for LSP
    'https://github.com/j-hui/fidget.nvim',
}

vim.pack.add(source_list)

----[ Related autocommands

--  This function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
    callback = function(event)
        -- The following autocommand is used to highlight references of the word under your cursor.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method('textDocument/documentHighlight', event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            -- When you move your cursor, the highlights will be cleared.
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
                callback = function(ev)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'user-lsp-highlight', buffer = ev.buf }
                end,
            })
        end
    end,
})

----[ Configuration

-- Enable the following language servers
-- See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
    stylua = {}, -- Used to format Lua code

    -- Special Lua Config, as recommended by neovim help docs
    lua_ls = {
        on_init = function(client)
            -- Disable formatting (formatting is done by stylua)
            client.server_capabilities.documentFormattingProvider = false

            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if path ~= vim.fn.stdpath 'config'
                    and (vim.uv.fs_stat(path .. '/.luarc.json')
                    or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                    return
                end
            end

            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            -- See: https://github.com/neovim/nvim-lspconfig/issues/3189
            local runtime_files = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                '${3rd}/luv/library',
                '${3rd}/busted/library',
            })

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT',
                    path = { 'lua/?.lua', 'lua/?/init.lua' },
                },
                workspace = {
                    checkThirdParty = false,
                    -- See: <https://github.com/neovim/nvim-lspconfig/issues/3189#issuecomment-3021345989>
                    library = vim.tbl_filter(function(d)
                        return not d:match(vim.fn.stdpath('config') .. '/?a?f?t?e?r?')
                    end, runtime_files),
                },
            })
        end,
        ---@type lspconfig.settings.lua_ls
        settings = {
            Lua = {
                -- Disable formatting (formatting is done by stylua)
                format = { enable = false },
            },
        },
    },
    -- Golang LSP configuration
    gopls = {
        ---@type lspconfig.settings.gopls
        settings = {
            -- See: <https://github.com/golang/tools/blob/master/gopls/doc/settings.md>
            gopls = {
                usePlaceholders = true,
                -- See: <https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md>
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                staticcheck = true,
                buildFlags = { '-tags=integration,mock,e2e' },
                gofumpt = true,
                diagnosticsDelay = '250ms',
            },
        },
    },
    -- Helps with golangci-lint config files.
    ['golangci_lint_ls'] = {},
    clangd = {}, -- Use defaults from nvim-lspconfig
}

-- Apply config and enable language server
for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
end

----[ Setup
-- NOTE: nvim-lspconfig doesn't require calling `setup()`

require('fidget').setup({})
