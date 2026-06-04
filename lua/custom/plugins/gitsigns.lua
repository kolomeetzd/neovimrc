--[ Git integration

----[ Install plugin and dependencies

local source_list = {
    'https://github.com/lewis6991/gitsigns.nvim',
}

vim.pack.add(source_list)

----[ Configuration

local gitsigns_opts = {
    on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<Leader>hs', gitsigns.stage_hunk)
    map('n', '<Leader>hr', gitsigns.reset_hunk)

    map('v', '<Leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<Leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<Leader>hS', gitsigns.stage_buffer)
    map('n', '<Leader>hR', gitsigns.reset_buffer)
    map('n', '<Leader>hp', gitsigns.preview_hunk)
    map('n', '<Leader>hi', gitsigns.preview_hunk_inline)

    map('n', '<Leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)

    map('n', '<Leader>hd', gitsigns.diffthis)

    map('n', '<Leader>hD', function()
      gitsigns.diffthis('~')
    end)

    map('n', '<Leader>hQ', function() gitsigns.setqflist('all') end)
    map('n', '<Leader>hq', gitsigns.setqflist)

    -- Toggles
    map('n', '<Leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<Leader>tw', gitsigns.toggle_word_diff)

    -- Text object
    map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  end
}

----[ Setup

require('gitsigns').setup(gitsigns_opts)
