--[ Tree-sitter

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    -- Show code context
    'https://github.com/nvim-treesitter/nvim-treesitter-context',
    {
        -- Syntax aware text-objects, select, move, swap, and peek support
        src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
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

local excluded_parsers = { go = true }

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

    -- Do not enable treesitter-based indentation for specified parsers
    if excluded_parsers[language] then return end

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

-- See `:help nvim-treesitter-context-config` for more options.
local ctx_opts = {
    enable = true, -- Enabled by default; can be disable later.
    mode = 'topline' -- Choices: 'cursor', 'topline'
}

-- Disable entire built-in ftplugin mappings to avoid conflicts with
-- with `nvim-treesitter-textobjects`.
-- See <https://github.com/neovim/neovim/tree/master/runtime/ftplugin> for built-in ftplugins.
--
-- Or, disable per filetype (add as you like):
-- vim.g.no_python_maps = true
-- vim.g.no_go_maps = true
vim.api.nvim_set_var('no_plugin_maps', true)

-- For more info on nvim-treesitter modules, see `:help nvim-treesitter-textobjects`.
local tsobj_opts = {
    select = {
        lookahead = true, -- Automatically jump forward to text object
        selection_modes = { -- Choose the select mode (default is charwise 'v')
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
            -- ['@class.outer'] = '<c-v>', -- blockwise
        },
    },
    move = {
        set_jumps = true, -- whether to set jumps in the jumplist
    },
}

-- Repeatable movements like `;` and `,`.
local tsobj_repmove = require('nvim-treesitter-textobjects.repeatable_move')

-- Repeat movement with `;` and `,`.
-- ensure `;` goes forward and `,` goes backward regardless of the last direction.
vim.keymap.set({ 'n', 'x', 'o' }, ';', tsobj_repmove.repeat_last_move_next)
vim.keymap.set({ 'n', 'x', 'o' }, ',', tsobj_repmove.repeat_last_move_previous)

-- Make builtin `f`, `F`, `t`, `T` also repeatable with `;` and `,`.
vim.keymap.set({ 'n', 'x', 'o' }, 'f', tsobj_repmove.builtin_f_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'F', tsobj_repmove.builtin_F_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 't', tsobj_repmove.builtin_t_expr, { expr = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'T', tsobj_repmove.builtin_T_expr, { expr = true })

-- You can use the capture groups defined in `textobjects.scm`.
-- You can also use captures from other query groups like `locals.scm` or `folds.scm`.
-- looks like this: `submod_textobject('@local.scope', 'locals')`.
-- For the list of built-in textobjects and supported languages,
-- see: <https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/main/BUILTIN_TEXTOBJECTS.md>.

-- 'select' module keymaps
-- For built-in text-objects selection, see: `:help object-select`.
-- For incremental selection, see: `:help treesitter-defaults`.
local tsobj_select = require('nvim-treesitter-textobjects.select')

vim.keymap.set({ 'x', 'o' }, 'im', function()
    tsobj_select.select_textobject('@function.inner', 'textobjects')
end, { desc = 'Select inner part of a function definition' })
vim.keymap.set({ 'x', 'o' }, 'am', function()
    tsobj_select.select_textobject('@function.outer', 'textobjects')
end, { desc = 'Select outer part of a function definition' })

-- Targets the syntactic 'block' — the AST node representing a code block or similar construct
-- (e.g., a function body, loop body, conditional branch, or other — language-specific block node).
-- Replaces built-in `v_ib` and `v_ab` that targeted round brackets/parentheses.
vim.keymap.set({ 'x', 'o' }, 'ib', function()
    tsobj_select.select_textobject('@block.inner', 'textobjects')
end, { desc = 'Select inner part of a block' })
vim.keymap.set({ 'x', 'o' }, 'ab', function()
    tsobj_select.select_textobject('@block.outer', 'textobjects')
end, { desc = 'Select outer part of a block' })

-- 'move' module keymaps
-- Go to next/previous text-object.
-- You can also pass a list to group multiple queries: `{'@loop.inner', '@loop.outer'}`
local tsobj_move = require('nvim-treesitter-textobjects.move')

vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
    tsobj_move.goto_next_start('@fold', 'folds')
end, { desc = 'Move cursor to the start of the next fold' })

-- I don't use `]f` and `[f` here, because of built-in default keymaps (same as `gf`).
vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
    tsobj_move.goto_next_start('@function.outer', 'textobjects')
end, { desc = 'Move cursor to the start of the next function' })
vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
    tsobj_move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = 'Move cursor to the start of the previous function' })
vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
    tsobj_move.goto_next_end('@function.outer', 'textobjects')
end, { desc = 'Move cursor to the end of the next function' })
vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
    tsobj_move.goto_previous_end('@function.outer', 'textobjects')
end, { desc = 'Move cursor to the end of the previous function' })

-- Replaces built-in section movements.
vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
    tsobj_move.goto_next_start('@block.outer', 'textobjects')
end, { desc = 'Move cursor to the start of the next block' })
vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
    tsobj_move.goto_previous_start('@block.outer', 'textobjects')
end, { desc = 'Move cursor to the start of the previous block' })
vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
    tsobj_move.goto_next_end('@block.outer', 'textobjects')
end, { desc = 'Move cursor to the end of the next block' })
vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
    tsobj_move.goto_previous_end('@block.outer', 'textobjects')
end, { desc = 'Move cursor to the end of the previous block' })

----[ Setup

-- Ensure parsers are installed
require('nvim-treesitter').install(parsers)
require('treesitter-context').setup(ctx_opts)
require('nvim-treesitter-textobjects').setup(tsobj_opts)
