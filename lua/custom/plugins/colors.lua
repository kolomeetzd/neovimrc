--[ Colorscheme

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    -- Based on Atom's One Dark theme
    'https://github.com/navarasu/onedark.nvim',
}

vim.pack.add(source_list)

----[ Configuration

local colors_opts = {
    style = 'warm',
    toggle_style_key = '<Leader>ts',
    transparent = true,
}

----[ Setup

require('onedark').setup(colors_opts)
require('onedark').load()
