--[ Basics: core settings, leaders, options
--  See `:h vim.o`, `:h vim.g`, and `:h option-list`
do
    -- Enable faster startup by caching compiled Lua modules
    vim.loader.enable()

    --[ Globals

    -- Set <space> as the Leader key
    -- See `:h mapleader`
    -- NOTE: Must happen before plugins are loaded (otherwise wrong Leader will be used)
    vim.g.mapleader = ' '
    vim.g.maplocalleader = ' '

    -- I use the "FiraCode Nerd Font" in the terminal.
    vim.g.have_nerd_font = true

    -- Netrw settigns
    -- Do not show netrw banner.
    vim.g.netrw_banner = 0
    -- Use tree style listing.
    vim.g.netrw_liststyle = 3
    -- Reduce initial size of a new windows.
    vim.g.netrw_winsize = 25

    --[ Options (buffer/window scoped)
    -- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`

    -- Show line numbers in a column.
    vim.o.number = true
    -- Show line numbers relative to where the cursor is.
    -- Affects the 'number' option above, see `:h number_relativenumber`.
    vim.o.relativenumber = true
    -- Always show the sign column, otherwise it would shift the text each time.
    vim.o.signcolumn = 'yes'
    -- Highlight the line where the cursor is on.
    vim.o.cursorline = true
    -- Keep this many screen lines above/below the cursor.
    vim.o.scrolloff = 10

    -- Every wrapped line will continue visually indented.
    vim.o.breakindent = true
    --[[
    -- NOTE: I'm experimenting with `breakindent` option, so
    -- keeping these `nowrap` settings commented out for now.
    --
    -- When off lines will not wrap and only part of long lines will be displayed.
    vim.o.wrap = false
    -- The minimum number of characters to keep to the left/right if `nowrap` is set.
    vim.o.sidescrolloff = 8
    -- Characters to show in the first/last visible column, when `wrap` is off.
    vim.o.listchars = 'extends:>,precedes:<'
    --]]

    -- For more info, see the "Tabs and spaces" section — `:h 30.5`.
    -- Indent a new line by 4 spaces istead of `tabstop` value.
    vim.o.shiftwidth = 4
    -- Maintain global coherence with `shiftwidth` option.
    vim.o.softtabstop = -1
    -- Replace any inserted horizontal tab character with an equivalent number of spaces.
    -- Use the `:retab` command to purge a file from all its horizontal tab characters.
    vim.o.expandtab = true
    -- Copy the indent level of the previos line.
    vim.o.autoindent = true
    -- Show <tab> and trailing spaces.
    vim.o.list = true
    -- Sets how Neovim will display certain whitespace characters in the editor.
    vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

    -- Case-insensitive searching.
    vim.o.ignorecase = true
    -- UNLESS \C or one or more capital letters in the search term.
    vim.o.smartcase = true
    -- Do not highlight matches on a previos search pattern.
    vim.o.hlsearch = false
    -- Preview substitutions live (in the bottom split window), as you type.
    vim.o.inccommand = 'split'

    -- Show this many items in the popup menu.
    vim.o.pumheight = 5

    -- Hide the name of the current mode at the cmdline.
    vim.o.showmode = false

    -- NOTE: I want default behavior, so keeping it commented out for now.
    --
    -- Do not show the line with tab page labels.
    -- vim.o.showtabline = 0

    -- Enable spell checker and specify to check for this languages.
    -- NOTE: `spelllang` is set using `vim.opt`, which is similar to `vim.o` but
    -- allows interacting with Lua tables.
    vim.o.spell = true
    vim.opt.spelllang = { 'en', 'ru' }

    -- Force all horizontal splits to open below the current window.
    vim.o.splitbelow = true
    -- Force all vertical splits to open to the right of the current window.
    vim.o.splitright = true

    -- Enable 24-bit RGB color in the host terminal.
    vim.o.termguicolors = true

    -- Decrease update time (mostly for the autocommand events).
    vim.o.updatetime = 250
    -- Decrease mapped sequence wait time.
    vim.o.timeoutlen = 300
    -- Time in milliseconds to wait for a key code sequence to complete.
    vim.o.ttimeoutlen = 100

    -- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
    -- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
    vim.o.confirm = true
    -- Save undo history when writing a buffer to a file.
    -- Enables undo/redo changes even after closing and reopening a file. Enables undo/redo changes even after closing and reopening a file.
    vim.o.undofile = true
    -- Do not use a swapfile fot the buffer.
    vim.o.swapfile = false
    -- Enable project-local configuration.
    -- Nvim will execute any .nvimrc or .exrc file found in the cwd, if the file in the trust list.
    -- For more info, see `:h trust`.
    vim.o.exrc = true
end

--[ Key mappings
--  See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`
do
    -- Open Netrw (defaults to: re-using the same window).
    vim.keymap.set('n', '<Leader>pv', vim.cmd.Ex)

    -- Align the cursor line to the middle of the window
    -- while scrolling using Ctlr-d/Ctlr-u.
    vim.keymap.set('n', '<C-d>', '<C-d>zz')
    vim.keymap.set('n', '<C-u>', '<C-u>zz')
    -- Center the cursor line and open just enough folds
    -- while repeating the latest search ("/" or "?").
    vim.keymap.set('n', 'n', 'nzzzv')
    vim.keymap.set('n', 'N', 'Nzzzv')

    -- Center the line and leave the cursor in the same column
    -- while jumping between errors in the quickfix list (global to the entire session).
    vim.keymap.set('n', ']q', ':cnext<CR>zz')
    vim.keymap.set('n', '[q', ':cprev<CR>zz')
    -- Same as above, but for the location list (better for window-specific tasks).
    vim.keymap.set('n', ']l', ':lnext<CR>zz')
    vim.keymap.set('n', '[l', ':lprev<CR>zz')

    -- Prepare a search-and-replace for the `word` under the cursor.
    --
    -- Uses registers (CTRL-R) to insert the object (CTRL-W) under the cursor,
    -- sets the range to the whole file (:%s/), and adds the flags `gI` (global in line, ignore-case),
    -- sends three <Left> keystrokes to place the command-line cursor inside the replacement field so
    -- the user can type the new text before confirming.
    vim.keymap.set( 'n', '<Leader>s',
        [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
    )

    -- Open a new tab page with the content of the current file.
    vim.keymap.set('n', '<Leader>tn', ':tabnew %<CR>')
    -- Close the current tab page.
    vim.keymap.set('n', '<Leader>tc', ':tabclose<CR>')

    -- Yank text into the system clipboard (register +).
    --
    -- Usage: press <Leader>y then a motion (normal mode) or select text (visual mode).
    --  - <Leader>yiw           - yank a word under the cursor.
    --  - v{motion}<Leader>y    - yank selection in visual mode.
    vim.keymap.set({ 'n', 'v' }, '<Leader>y', [["+y]])

    -- Change current window height/width with arrows.
    vim.keymap.set('n', '<C-Up>', ':resize +2<CR>')
    vim.keymap.set('n', '<C-Down>', ':resize -2<CR>')
    vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>')
    vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>')

    -- Keep visual selection after indenting so you can
    -- apply the same indent/unindent operation multiple times.
    vim.keymap.set('v', '<', '<gv')
    vim.keymap.set('v', '>', '>gv')

    -- Move the current line up/down and fix the indentation.
    vim.keymap.set('n', '<A-j>', [[:move .+1<CR>==]])
    vim.keymap.set('n', '<A-k>', [[:move .-2<CR>==]])

    -- Move selected line (or block of text) up/down, fix the indentation, and
    -- keep visual selection.
    vim.keymap.set({'v', 'x'}, '<A-j>', [[:move '>+1<CR>gv=gv]])
    vim.keymap.set({'v', 'x'}, '<A-k>', [[:move '<-2<CR>gv=gv]])

    -- Use <Esc> to exit terminal mode
    vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
end

--[ Event handler
--  See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`
do
    local restore_cursor = vim.api.nvim_create_augroup('user-restore-cursor', { clear = true })

    -- Restore the cursor position when last exiting the current buffer.
    -- For the Vimscript-style autocmd, see `:help last-position-jump`.
    vim.api.nvim_create_autocmd('BufReadPre', {
        group = restore_cursor,
        pattern = '*',
        desc = 'Restore cursor last position',
        callback = function(args)
            local bufnr = args.buf

            vim.api.nvim_create_autocmd('FileType', {
                buf = bufnr,
                group = restore_cursor,
                once = true,
                callback = function()
                    -- Get saved mark for the cursor position `{row,col}`.
                    local pos = vim.api.nvim_buf_get_mark(bufnr, '"')

                    -- Validate row.
                    local row = pos[1]
                    if type(row) ~= 'number' or row < 1
                        or row > vim.api.nvim_buf_line_count(bufnr) then
                        return
                    end

                    local opts = {}

                    -- Check local 'filetype' value.
                    local ft = vim.api.nvim_get_option_value('filetype', opts)
                    local not_allowed = { gitcommit = true, gitrebase = true, xxd = true }
                    if not_allowed[ft] then
                        return
                    end

                    -- Ensure that current window is not in the diff-mode.
                    if vim.api.nvim_get_option_value('diff', opts) then
                        return
                    end

                    -- Set the cursor to the last saved position.
                    vim.api.nvim_win_set_cursor(vim.fn.bufwinid(bufnr), pos)
                end,
            })
        end,
    })

    -- Highlight when yanking (copying) text.
    -- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        callback = function()
            vim.hl.on_yank()
        end,
    })
end

--[ User commands
--  See `:h nvim_create_user_command()` and `:h user-commands`
do
    -- Create a command `:GitBlameLine` that print the git blame for the current line
    vim.api.nvim_create_user_command('GitBlameLine', function()
        local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
        local filename = vim.api.nvim_buf_get_name(0)
        print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
    end, { desc = 'Print the git blame for the current line' })
end

--[ Navigation: Telescope setup, keymaps, LSP picker mappings
--  See `:help telescope` and `:help telescope.setup()`
do
    ---@type (string|vim.pack.Spec)[]
    local telescope_plugins = {
        'https://github.com/nvim-lua/plenary.nvim',
        'https://github.com/nvim-telescope/telescope.nvim',
        'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    }

    if vim.fn.executable 'make' == 1 then
        table.insert(telescope_plugins, 'https://github.com/nvim-telescope/telescope-fzf-native.nvim')
    end

    vim.pack.add(telescope_plugins)

    local builtin = require('telescope.builtin')
    local themes = require('telescope.themes')

    require('telescope').setup({
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
            entry_prefix = '  ',
            initial_mode = 'insert',
            selection_strategy = 'reset',
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
            file_sorter = require('telescope.sorters').get_fuzzy_file,
            generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
            dynamic_preview_title = true,
            path_display = {
                -- see :h telescope.defaults.path_display
                -- shorten = { len = 1, exclude = { -1, -2 } },
                'truncate',
            },
            winblend = 0,
            border = {},
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
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
            buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
            mappings = {
                n = { ['q'] = require('telescope.actions').close },
            },
        },
        extensions = {
            ['ui-select'] = { themes.get_dropdown({ previewer = false }) },
        },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    ----[ Built-ins (including Telescope)

    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<Leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })

    vim.keymap.set('n', '<Leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<Leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<Leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })

    ----[ File pickers

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

    -- NOTE: Currently unused, but kept commented for future reference
    --
    -- List unstaged git files only
    -- vim.keymap.set( 'n', '<Leader>gs', builtin.git_status, { desc = ':Telescope git_status' })
    -- List git commits with diff preview
    -- vim.keymap.set( 'n', '<Leader>gc', builtin.git_commits, { desc = ':Telescope git_commits' })

    ----[ Search for an entry that matches patterns

    local search_picker_opts = themes.get_dropdown({
        previewer = false,
    })

    -- A `word` consists of a sequence of letters, digits and underscores,
    -- separated with white space.
    vim.keymap.set({'n', 'v' }, '<Leader>ws', function()
        local opts = { search = vim.fn.expand('<cword>') }
        builtin.grep_string(opts)
    end, { desc = 'Search a word under cursor' })
    -- A `WORD` consists of a sequence of non-blank characters,
    -- separated with white space.
    vim.keymap.set({ 'n', 'v' }, '<Leader>Ws', function()
        local opts = { search = vim.fn.expand('<cWORD>') }
        builtin.grep_string(opts)
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

    ----[ Diagnostic

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

    ----[ LSP related settings

    local cursor_theme = themes.get_cursor({
        path_display = 'tail',
        layout_config = {
            width = 0.70,
            height = 0.50,
        },
    })

    -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
    -- If you later switch picker plugins, this is where to update these mappings.
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


end

--[ Diagnostic: config and keymaps
--  See `:help vim.diagnostic.Opts`
do
    vim.diagnostic.config({
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = { min = vim.diagnostic.severity.WARN } },

        virtual_text = true,
        virtual_lines = false,

        jump = {
            on_jump = function (_, bufnr)
                vim.diagnostic.open_float({
                    bufnr = bufnr,
                    scope = 'cursor',
                    focus = false,
                })
            end,
        },
    })

    vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]ickfix list' })
end

--[ LSP: server configs, keymaps
--  See: `:h lsp-quickstart` and `:h lsp-defaults`
do
    --  This function gets run when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(event)
            -- The following autocommand is used to highlight references of the word under your cursor.
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method('textDocument/documentHighlight', event.buf) then
                local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
                vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.document_highlight,
                })

                -- When you move your cursor, the highlights will be cleared.
                vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    buffer = event.buf,
                    group = highlight_augroup,
                    callback = vim.lsp.buf.clear_references,
                })

                vim.api.nvim_create_autocmd('LspDetach', {
                    group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
                    callback = function(ev)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds { group = 'user-lsp-highlight', buffer = ev.buf }
                    end,
                })
            end
        end,
    })

    -- Enable the following language servers
    -- See `:help lsp-config` for information about keys and how to configure
    ---@type table<string, vim.lsp.Config>
    local servers = {
        -- clangd = {},
        -- gopls = {},

        stylua = {}, -- Used to format Lua code

        -- Special Lua Config, as recommended by neovim help docs
        lua_ls = {
            on_init = function(client)
                -- Disable formatting (formatting is done by stylua)
                client.server_capabilities.documentFormattingProvider = false

                if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if path ~= vim.fn.stdpath 'config'
                        and (vim.uv.fs_stat(path .. '/.luarc.json')
                        or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                        return
                    end
                end

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                    runtime = {
                        version = 'LuaJIT',
                        path = { 'lua/?.lua', 'lua/?/init.lua' },
                    },
                    workspace = {
                        checkThirdParty = false,
                        -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
                        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                        library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
                            '${3rd}/luv/library',
                            '${3rd}/busted/library',
                        }),
                    },
                })
            end,
            ---@type lspconfig.settings.lua_ls
            settings = {
                Lua = {
                    -- Disable formatting (formatting is done by stylua)
                    format = { enable = false },
                },
            },
        },
    }

    for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
    end
end

--[ Plugins: installing and configuration
--  See `:h :packadd`, `:h vim.pack`
do
    -- Add the "nohlsearch" package to automatically disable search highlighting after
    -- 'updatetime' and when going to insert mode.
    vim.cmd('packadd! nohlsearch')

    -- Install third-party plugins via "vim.pack.add()".
    vim.pack.add({
        -- Quickstart configs for LSP
        'https://github.com/neovim/nvim-lspconfig',
        -- Fuzzy picker
        'https://github.com/ibhagwan/fzf-lua',
        -- Autocompletion
        'https://github.com/nvim-mini/mini.completion',
        -- Enhanced quickfix/loclist
        'https://github.com/stevearc/quicker.nvim',
        -- Git integration
        'https://github.com/lewis6991/gitsigns.nvim',
        -- Colorscheme based on Atom's One Dark
        'https://github.com/navarasu/onedark.nvim',
        -- Easy configurable statusline
        'https://github.com/nvim-tree/nvim-web-devicons',
        'https://github.com/nvim-lualine/lualine.nvim',
    })

    require('fzf-lua').setup { fzf_colors = true }
    require('mini.completion').setup {}
    require('quicker').setup {}
    require('gitsigns').setup {}

    require('onedark').setup {
        style = 'warm',
        toggle_style_key = '<Leader>ts',
        transparent = true,
    }
    require('onedark').load()

    require('lualine').setup {
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
end
