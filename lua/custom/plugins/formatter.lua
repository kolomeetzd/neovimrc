--[ Formatting

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    'https://github.com/stevearc/conform.nvim',
}

vim.pack.add(source_list)

----[ Configuration

local conform_opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
        -- You can specify filetypes to autoformat on save here:
        local enabled_filetypes = {
            -- lua = true,
            go = true,
        }
        if (vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat)
            or not enabled_filetypes[vim.bo[bufnr].filetype] then
            return nil
        else
            return { lsp_format = 'fallback', timeout_ms = 500 }
        end
    end,
    default_format_opts = {
        -- Use external formatters if configured below, otherwise
        -- use LSP formatting. Set to `false` to disable LSP formatting entirely.
        lsp_format = 'fallback',
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially.
        -- You can use 'stop_after_first' to run the first available formatter from the list.
        go = { 'gci', 'golines', 'gofumpt', stop_after_first = false },
        c = { 'clang-format' },
        -- json = { 'fixjson' },
        -- yaml = { 'prettier' },
        -- markdown = { 'prettier' },
        -- ['*'] = { 'codespell' },
    },
    formatters = {
        gci = {
            inherit = false,
            command = 'gci',
            stdin = false,
            args = {
                'write',
                '--skip-generated',
                '--skip-vendor',
                '--custom-order',
                '-s',
                'standard',
                '-s',
                'default',
                -- '-s',
                -- 'blank',
                -- '-s',
                -- 'dot',
                -- '-s',
                -- 'alias',
                '-s',
                'localmodule',
                '$FILENAME',
            },
        },
        golines = {
            prepend_args = { '-m', '140' },
        },
        ['clang-format'] = {
            prepend_args = { '--fallback-style=LLVM' },
        },
    },
}

vim.keymap.set({ 'n', 'v' }, '<Leader>fm', function()
    require('conform').format({ async = true })
end, { desc = 'Format file or range via conform.nvim' })

----[ Setup

require('conform').setup(conform_opts)
