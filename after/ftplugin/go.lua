local go_opts = {
    expandtab = false,
    tabstop = 4,
    shiftwidth = 4,

    formatoptions = 'rocjq',
}

for name, val in pairs(go_opts) do
    vim.api.nvim_set_option_value(name, val, { scope = 'local' })
end
