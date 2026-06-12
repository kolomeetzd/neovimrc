--[ TODO-Comments
--  Highlight, list and search todo comments in your projects

----[ Install plugin and dependencies
local source_list = {
    'https://github.com/nvim-lua/plenary.nvim', -- required via todo-comments
    'https://github.com/folke/todo-comments.nvim',
}

vim.pack.add(source_list)

----[ Configuration

-- For more options, see `:help todo-comments.nvim-todo-comments-configuration`.

-- Search through all project todos with Telescope.
-- You can use comma separated list of keywords to filter results by.
-- Keywords are case-sensitive.
vim.keymap.set('n', '<Leader>td', ':TodoTelescope keywords=TODO,FIX<CR>')

----[ Setup
require('todo-comments').setup()
