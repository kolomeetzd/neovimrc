--[ Statusline

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    -- Nerd Font icons (glyphs) for use by neovim plugins
    'https://github.com/nvim-tree/nvim-web-devicons',
    -- Easy configurable statusline
    'https://github.com/nvim-lualine/lualine.nvim',
}

vim.pack.add(source_list)

----[ Configuration

local statusline_opts = {
    options = {
        theme = 'onedark',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
    },
    sections = {
        lualine_c = {
            {
                'filename',
                -- Display new file status (new file means no write after created)
                -- default: false
                newfile_status = true,
                -- Show relative path
                -- default: 0 - just a filename
                path = 1,
            },
        },
        lualine_x = {
            function()
                return 'indent: ' .. vim.api.nvim_get_option_value('shiftwidth', {})
            end,
            'encoding',
            {
                'filetype',
                icons_enabled = false,
                icon = nil,
            },
        },
    },
}

----[ Setup

require('lualine').setup(statusline_opts)
