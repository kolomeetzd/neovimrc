--[ Basics: core settings, leaders, options
--  See `:h vim.o`, `:h vim.g`, and `:h option-list`

----[ Netrw settigns

-- Do not show netrw banner.
vim.g.netrw_banner = 0
-- Use tree style listing.
vim.g.netrw_liststyle = 0
-- Reduce initial size of a new windows.
vim.g.netrw_winsize = 25

----[ Options (buffer/window scoped)
--    To see documentation for an option, use `:h 'optionname'`, for example `:h 'number'`

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
vim.o.timeoutlen = 1000
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

-- Russian keymaps
vim.o.langmap='ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
