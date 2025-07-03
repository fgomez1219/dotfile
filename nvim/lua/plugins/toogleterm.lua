return {
  "akinsho/toggleterm.nvim",
  enable = false, -- Enable this plugin
  version = "*", -- use the latest release
  config = function()
    require("toggleterm").setup({
      -- Your toggleterm options here
      -- For example, mapping to toggle the terminal
      open_mapping = [[<c-\>]],
      -- The direction of the terminal (e.g., "float", "horizontal", "vertical")
      direction = "float",
      -- Options for floating terminal
      float_opts = {
          border = "curved", -- or "single", "double", "rounded"
          winblend = 0,      -- transparency
      },
      -- Other options you might like:
      -- size = 20, -- For horizontal/vertical terminals
      -- hide_numbers = true, -- Hide line numbers
      -- shell = vim.o.shell, -- Use your default shell
    })
  end,
}
