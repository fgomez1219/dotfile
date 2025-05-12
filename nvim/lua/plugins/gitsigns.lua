return {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- Navigate hunks
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr })

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr })

        -- Show diff of hunk
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr })

        -- Stage/Reset hunk
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr })
        vim.keymap.set('n', '<leader>hu', gs.reset_hunk, { buffer = bufnr })
      end
    }
  end
}
