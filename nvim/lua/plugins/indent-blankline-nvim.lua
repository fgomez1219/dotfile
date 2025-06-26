return {
  "lukas-reineke/indent-blankline.nvim",
  event = 'VeryLazy',
  main = "ibl",
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
      highlight = { "IblScopeHighlight" },
    },
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3c4452", bg = "NONE", nocombine = true })
    vim.api.nvim_set_hl(0, "IblScopeHighlight", { fg = "#ffb07b", bg = "NONE", nocombine = true })

    local ibl = require("ibl")
    ibl.setup(opts)
  end,
}
