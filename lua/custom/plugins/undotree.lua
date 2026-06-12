--[ Undo-tree
--  The undo history visualizer.

----[ Install plugin and dependencies
local source_list = {
    'https://github.com/mbbill/undotree',
}

vim.pack.add(source_list)

----[ Configuration

-- For more options, see:
-- <https://github.com/mbbill/undotree/blob/master/plugin/undotree.vim#L27>

-- Change default window layout.
vim.api.nvim_set_var('undotree_WindowLayout', 2)

vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)

----[ Setup
-- NOTE: undo-tree plugin doesn't require setup call.
