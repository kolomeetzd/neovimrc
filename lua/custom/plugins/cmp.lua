--[ Autocompletion engine

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    {
        src = 'https://github.com/Saghen/blink.cmp',
        version = vim.version.range '1.*'
    },
}

vim.pack.add(source_list)

----[ Configuration

local cmp_opts = {
    -- See `:help blink-cmp-config-keymap` for defining your own keymap
    keymap = {
        -- For an understanding of why the 'default' preset is recommended,
        -- read `:help ins-completion`.
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        -- <c-y> to accept ([y]es) the completion
        preset = 'default',
    },
    appearance = {
        nerd_font_variant = 'mono',
    },
    completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },
    sources = {
        default = { 'lsp', 'path', 'snippets' },
    },
    snippets = { preset = 'luasnip' },
    -- By default, it uses the Lua implementation, but user may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information.
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
}

----[ Setup

require('blink.cmp').setup(cmp_opts)
