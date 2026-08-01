return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  opts = {
    hooks = {
      diff_buf_read = function()
        vim.opt_local.foldlevel = 99
      end,
      diff_buf_win_enter = function()
        vim.opt_local.foldlevel = 99
      end,
    },
  },
}
