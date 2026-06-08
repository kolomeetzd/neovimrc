--[ User commands
--  See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
    local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
    local filename = vim.api.nvim_buf_get_name(0)
    print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- See: <https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save>
vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = 'Disable autoformat-on-save', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })
