--[ Telescope: navigaion setup, keymaps, LSP picker mappings
--  See `:help telescope` and `:help telescope.setup()`

----[ Install plugin and dependencies

---@type (string|vim.pack.Spec)[]
local source_list = {
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    -- Fuzzy picker
    'https://github.com/ibhagwan/fzf-lua',
}

if vim.fn.executable 'make' == 1 then
    table.insert(source_list, 'https://github.com/nvim-telescope/telescope-fzf-native.nvim')
end

vim.pack.add(source_list)

local builtin = require('telescope.builtin')
local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')

local themes = require('telescope.themes')

----[ Configuration

-- Telescope default options
local telescope_opts = {
    defaults = {
        vimgrep_arguments = {
            'rg',
            '-L',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
        },
        file_ignore_patterns = { '^.git/', '^vendor/' },
        prompt_prefix = '   ',
        selection_caret = '  ',
        sorting_strategy = 'ascending',
        layout_strategy = 'horizontal',
        layout_config = {
            horizontal = {
                prompt_position = 'top',
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                prompt_position = 'top',
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        file_sorter = sorters.get_fuzzy_file,
        generic_sorter = sorters.get_generic_fuzzy_sorter,
        dynamic_preview_title = true,
        path_display = {
            -- see :h telescope.defaults.path_display
            -- shorten = { len = 1, exclude = { -1, -2 } },
            'truncate',
        },
        winblend = 0,
        borderchars = {
            '─',
            '│',
            '─',
            '│',
            '┌',
            '┐',
            '┘',
            '└',
        },
        color_devicons = true,
        set_env = {
            ['COLORTERM'] = 'truecolor',
        },
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        buffer_previewer_maker = previewers.buffer_previewer_maker,
        mappings = {
            n = { ['q'] = actions.close },
        },
    },
    extensions = {
        ['ui-select'] = { themes.get_dropdown({ previewer = false }) },
    },
}

----[ Related keymaps

-- Built-ins
-- See `:help telescope.builtin`
vim.keymap.set('n', '<Leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

vim.keymap.set('n', '<Leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<Leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<Leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })

-- File pickers
local file_picker_opts = {
    follow = true,
    hidden = true,
    no_ignore = true,
    resutls_title = false,
    previewer = false,
    layout_strategy = 'vertical',
    layout_config = {
        mirror = true,
        anchor = 'N',
        prompt_position = 'top',
        height = 0.50,
        width = 0.50,
    },
}

vim.keymap.set('n', '<Leader>pf', function()
    builtin.find_files(file_picker_opts)
end, { desc = 'Search files in the working directory' })

vim.keymap.set('n', '<Leader>pg', function ()
    builtin.git_files(file_picker_opts)
end, { desc = 'Search tracked git files only' })

vim.keymap.set('n', '<Leader>pb', function()
    builtin.buffers(file_picker_opts)
end, { desc = 'Search in open buffers' })

-- Git
-- List unstaged git files only
vim.keymap.set( 'n', '<Leader>gs', function()
    builtin.git_status()
end, { desc = ':Telescope git_status' })
-- List git commits with diff preview
vim.keymap.set( 'n', '<Leader>gc', function()
    builtin.git_commits()
end, { desc = ':Telescope git_commits' })

-- Search for an entry that matches patterns
local search_picker_opts = themes.get_dropdown({
    previewer = false,
})

-- A `word` consists of a sequence of letters, digits and underscores,
-- separated with white space.
vim.keymap.set({'n', 'v' }, '<Leader>ws', function()
    local args = { search = vim.fn.expand('<cword>') }
    builtin.grep_string(args)
end, { desc = 'Search a word under cursor' })
-- A `WORD` consists of a sequence of non-blank characters,
-- separated with white space.
vim.keymap.set({ 'n', 'v' }, '<Leader>Ws', function()
    local args = { search = vim.fn.expand('<cWORD>') }
    builtin.grep_string(args)
end, { desc = 'Search a WORD under cursor' })

-- See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set('n', '<Leader>lg', builtin.live_grep, { desc = 'Perform [L]ive [G]rep' })

vim.keymap.set( 'n', '<Leader>lG', function()
    local opts = {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
    builtin.live_grep(opts)
end, { desc = 'Search in Open Files' })

vim.keymap.set('n', '<Leader>/', function()
    builtin.current_buffer_fuzzy_find(search_picker_opts)
end, { desc = '[/] Fuzzily search in current buffer' })

-- Diagnostics
local bottom_pane_theme = themes.get_ivy({
    path_display = { 'tail' },
    layout_config = {
        height = 0.50,
    },
})

vim.keymap.set('n', '<Leader>sd', function()
    builtin.diagnostics(bottom_pane_theme)
end, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<Leader>sr', function()
    builtin.resume(bottom_pane_theme)
end, { desc = '[S]earch [R]esume' })

-- LSP
local cursor_theme = themes.get_cursor({
    path_display = { 'tail' },
    layout_config = {
        width = 0.70,
        height = 0.50,
    },
})

-- Add Telescope-based LSP pickers ONLY when an LSP attaches to a buffer.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
        local buf = event.buf

        -- Find references for the word under your cursor.
        vim.keymap.set('n', 'grr', function()
            builtin.lsp_references(cursor_theme)
        end, { buffer = buf, desc = '[G]oto [R]eferences' })

        -- Jump to the implementation of the word under your cursor.
        -- Useful when your language has ways of declaring types without an actual implementation.
        vim.keymap.set('n', 'gri', function()
            builtin.lsp_implementations(cursor_theme)
        end, { buffer = buf, desc = '[G]oto [I]mplementation' })

        -- Jump to the definition of the word under your cursor.
        -- This is where a variable was first declared, or where a function is defined, etc.
        -- To jump back, press <C-t>.
        vim.keymap.set('n', 'grd', function()
            builtin.lsp_definitions(cursor_theme)
        end, { buffer = buf, desc = '[G]oto [D]efinition' })

        -- Jump to the type of the word under your cursor.
        -- Useful when you're not sure what type a variable is and you want to see
        -- the definition of its *type*, not where it was *defined*.
        vim.keymap.set('n', 'grt', function()
            builtin.lsp_type_definitions(cursor_theme)
        end, { buffer = buf, desc = '[G]oto [T]ype Definition' })

        -- Fuzzy find all the symbols in your current document.
        -- Symbols are things like variables, functions, types, etc.
        vim.keymap.set('n', 'gO', function()
            builtin.lsp_document_symbols(cursor_theme)
        end, { buffer = buf, desc = 'Open Document Symbols' })

        -- Fuzzy find all the symbols in your current workspace.
        -- Similar to document symbols, except searches over your entire project.
        vim.keymap.set('n', 'gW', function()
            builtin.lsp_dynamic_workspace_symbols(cursor_theme)
        end, { buffer = buf, desc = 'Open Workspace Symbols' })

        -- Lists LSP incoming calls for word under the cursor.
        vim.keymap.set('n', '<Leader>inc', function()
            builtin.lsp_incoming_calls(cursor_theme)
        end, { desc = 'Open Incoming Calls' })

        -- Lists LSP outgoing calls for word under the cursor.
        vim.keymap.set('n', '<Leader>out', function()
            builtin.lsp_outgoing_calls(cursor_theme)
        end, { desc = 'Open Outgoing Calls' })
    end,
})

----[ Related autocommands

-- Reset colors
vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('telescope-border-colors', { clear = true }),
    desc = 'Reset colors for Telescope prompt, preview and results',
    once = true,
    callback = function()
        local hl_groups = {
            'TelescopePromptBorder',
            'TelescopePromptPrefix',
            'TelescopePreviewBorder',
            'TelescopeResultsBorder',
        }

        for _, hl in ipairs(hl_groups) do
            vim.api.nvim_set_hl(0, hl, { bg = 'none' })
        end
    end
})

----[ Setup

require('telescope').setup(telescope_opts)

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
