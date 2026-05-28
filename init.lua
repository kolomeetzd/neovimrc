-- =====================================================
-- SECTION 1: Core Neovim settings, leaders, options
-- =====================================================
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

    -- Netrw settigns
    -- Do not show netrw banner.
    vim.g.netrw_banner = 0
    -- Use tree style listing.
    vim.g.netrw_liststyle = 3
    -- Reduce initial size of a new windows.
    vim.g.netrw_winsize = 25

    -- Options
    --
    -- See `:h vim.o`
    -- NOTE: You can change these options as you wish!
    -- For more options, you can see `:h option-list`
    -- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
    -- (Note the single quotes)

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
    -- NOTE: Experimenting with `breakindent` option, so
    -- I'm keeping these `nowrap` settings commented out for now.
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

    -- Case-insensitive searching;
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

    -- NOTE: I want default behavior, so I'm keeping it commented out for now.
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

-- =========================
-- SECTION 2: Key mapping
-- =========================
do
    -- Keymaps
    --
    -- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

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

-- ============================
-- SECTION 3: Event handlers
-- ============================
do
    -- Autocommands
    --
    -- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

    -- Highlight when yanking (copying) text.
    -- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
    vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        callback = function()
            vim.hl.on_yank()
        end,
    })
end

-- ===========================
-- SECTION 4: User commands
-- ===========================
do
    -- Define custom commands
    --
    -- See `:h nvim_create_user_command()` and `:h user-commands`

    -- Create a command `:GitBlameLine` that print the git blame for the current line
    vim.api.nvim_create_user_command('GitBlameLine', function()
        local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
        local filename = vim.api.nvim_buf_get_name(0)
        print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
    end, { desc = 'Print the git blame for the current line' })
end

-- =====================
-- SECTION 5: Plugins
-- =====================
do
    -- Installing and configuring plugins
    --
    -- See `:h :packadd`, `:h vim.pack`

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
    })

    require('fzf-lua').setup { fzf_colors = true }
    require('mini.completion').setup {}
    require('quicker').setup {}
    require('gitsigns').setup {}
end
