--[ Load plugins from `lua/custom/plugins` directory

local lvl = vim.log.levels.ERROR

local plugins_list = {
    'custom.plugins.colors',
    'custom.plugins.statusline',
    'custom.plugins.lsp',
    'custom.plugins.snippets',
    'custom.plugins.cmp',
    'custom.plugins.formatter',
    'custom.plugins.linter',
    'custom.plugins.treesitter',
    'custom.plugins.telescope',
    'custom.plugins.gitsigns',
    'custom.plugins.mini-surround',
    'custom.plugins.undotree',
    'custom.plugins.todos',
}

for _, name in ipairs(plugins_list) do
    local ok, err = pcall(require, name)
    if not ok then
        vim.notify(('Failed to load %s: %s'):format(name, err), lvl)
    end
end
