--[ Diagnostic: config and keymaps
--  See `:help vim.diagnostic.Opts`

vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    virtual_text = true,
    virtual_lines = false,

    jump = {
        on_jump = function (_, bufnr)
            vim.diagnostic.open_float({
                bufnr = bufnr,
                scope = 'cursor',
                focus = false,
            })
        end,
    },
})

vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]ickfix list' })
