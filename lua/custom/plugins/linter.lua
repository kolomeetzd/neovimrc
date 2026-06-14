--[ Linters

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    'https://github.com/mfussenegger/nvim-lint',
}

vim.pack.add(source_list)
local nvim_lint = require('lint')

----[ Related autocommands

-- autocmd to trigger linting
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function()
        -- try_lint without arguments runs the linters defined in `linters_by_ft`
        -- for the current filetype
        nvim_lint.try_lint()
    end,
})

----[ Configuration

-- Configure the linters you want to run per file type.
nvim_lint.linters_by_ft = {
    go = { 'golangcilint' },
    lua = { 'luacheck' },
    -- json = { 'jsonlint' },
    -- sh = { 'shellcheck' },
    -- yaml = { 'yamllint' },
}

-- Allow multiple parallel golangci-lint instances running,
-- with $(nproc) number of CPUs.
local go_lint = require('lint').linters.golangcilint
go_lint.args = {
    'run',
    '--allow-parallel-runners',
    '--output.json.path=stdout',
    '--show-stats=false',
    '--output.text.print-issued-lines=false',
    '--fix',
}

----[ Setup
-- NOTE: nvim-lint doesn't require setup call
