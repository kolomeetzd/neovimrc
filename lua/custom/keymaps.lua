--[ Key mappings
--  See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

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
vim.keymap.set( 'n', '<Leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

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

-- Press jk fast to exit insert mode
vim.keymap.set("i", "jk", "<ESC>")
