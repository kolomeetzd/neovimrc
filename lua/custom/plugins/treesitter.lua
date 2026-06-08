--[ Tree-sitter

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
}

vim.pack.add(source_list)

----[ Configuration
local parsers = {
    'bash',
    'c',
    'diff',
    'dockerfile',
    'gitcommit',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'html',
    'json',
    'lua',
    'luadoc',
    'make',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'yaml',
}

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    local local_win = { scope = 'local', win = vim.fn.bufwinid(buf) }
    vim.api.nvim_set_option_value('foldexpr', 'v:lua.vim.treesitter.foldexpr()', local_win)
    vim.api.nvim_set_option_value('foldmethod', 'expr', local_win)
    vim.api.nvim_set_option_value('foldlevel', 99, local_win) -- Keep folds expanded by default

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then
        local local_buf = { scope = 'local', buf = buf }
        vim.api.nvim_set_option_value('indentexpr', [[v:lua.require'nvim-treesitter'.indentexpr()]], local_buf)
    end
end

local available_parsers = require('nvim-treesitter').get_available()
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

        if vim.tbl_contains(installed_parsers, language) then
            -- Enable the parser if it is already installed
            treesitter_try_attach(buf, language)
        elseif vim.tbl_contains(available_parsers, language) then
            -- If a parser is available in `nvim-treesitter`, auto-install it
            -- and enable it after the installation is done
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
        else
            -- Try to enable treesitter features in case
            -- the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
        end
    end,
})

----[ Setup

-- Ensure parsers are installed
require('nvim-treesitter').install(parsers)
