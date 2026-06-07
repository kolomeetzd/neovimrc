--[ Multi-file configuration
do
    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    -- Set <space> as the Leader key
    -- See `:h mapleader`
    -- NOTE: Must happen before plugins are loaded (otherwise wrong Leader will be used)
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- I use the "FiraCode Nerd Font" in the terminal.
    vim.g.have_nerd_font = true

    -- Core settings and basic options
    require('custom.options')
    -- Key mappings
    require('custom.keymaps')
    -- Diagnostic config
    require('custom.diagnostic')
    -- Event handlers
    require('custom.autocmd')
    -- User commands
    require('custom.usercmd')
    -- Plugins
    require('custom.plugins')
end

--[ Plugins: installing and configuration
--  See `:h :packadd`, `:h vim.pack`
do
    -- Add the "nohlsearch" package to automatically disable search highlighting after
    -- 'updatetime' and when going to insert mode.
    vim.cmd('packadd! nohlsearch')

    -- Install third-party plugins via "vim.pack.add()".
    vim.pack.add({
        -- Enhanced quickfix/loclist
        'https://github.com/stevearc/quicker.nvim',
    })

    require('quicker').setup {}
end
