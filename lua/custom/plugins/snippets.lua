--[ Snippet engine

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    {
        src = 'https://github.com/L3MON4D3/LuaSnip',
        version = vim.version.range '2.*'
    },
    -- `friendly-snippets` contains a variety of premade snippets
    -- 'https://github.com/rafamadriz/friendly-snippets',
}

vim.pack.add(source_list)

----[ Configuration

local luasnip_opts = {
    update_events = { 'TextChanged', 'TextChangedI' }
}

----[ Setup

require('luasnip').setup(luasnip_opts)
