--[ Autocommands
--  See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Helps create custom autocommand groups.
local augroup = function(name)
    return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- Restore the cursor position when last exiting the current buffer.
-- For the Vimscript-style autocmd, see `:help last-position-jump`.
local restore_cursor = augroup('restore-cursor')
vim.api.nvim_create_autocmd('BufReadPre', {
    group = restore_cursor,
    pattern = '*',
    desc = 'Restore cursor last position',
    callback = function(args)
        local bufnr = args.buf

        vim.api.nvim_create_autocmd('FileType', {
            buf = bufnr,
            group = restore_cursor,
            once = true,
            callback = function()
                -- Same mark for the cursor position `{row,col}`.
                local pos = vim.api.nvim_buf_get_mark(bufnr, '"')

                -- Validate row.
                local row = pos[1]
                if type(row) ~= 'number' or row < 1
                    or row > vim.api.nvim_buf_line_count(bufnr) then
                    return
                end

                local opts = {}

                -- Check local 'filetype' value.
                local ft = vim.api.nvim_get_option_value('filetype', opts)
                local not_allowed = { gitcommit = true, gitrebase = true, xxd = true }
                if not_allowed[ft] then
                    return
                end

                -- Ensure that current window is not in the diff-mode.
                if vim.api.nvim_get_option_value('diff', opts) then
                    return
                end

                -- Set the cursor to the last saved position.
                vim.api.nvim_win_set_cursor(vim.fn.bufwinid(bufnr), pos)
            end,
        })
    end,
})

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    group = augroup('highlight-yank'),
    desc = 'Highlight when yanking (copying) text',
    callback = function()
        vim.hl.on_yank()
    end,
})

-- This autocommand runs after a plugin is installed or updated.
--
-- See `:help vim.pack-events`
vim.api.nvim_create_autocmd('PackChanged', {
    group = augroup('run-build'),
    desc = 'Run the appropriate build command for a plugin',
    callback = function(ev)
        local utils = require('custom.utils')

        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= 'install' and kind ~= 'update' then return end

        -- See: <https://github.com/nvim-telescope/telescope-fzf-native.nvim#installation>
        if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
            utils.run_build(name, { 'make' }, ev.data.path)
            return
        end

        if name == 'LuaSnip' then
            if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
                utils.run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
            end
            return
        end

        if name == 'nvim-treesitter' then
            if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
            vim.cmd 'TSUpdate'
            return
        end
    end,
})
