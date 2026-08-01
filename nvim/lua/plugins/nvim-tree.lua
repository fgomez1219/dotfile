-- File Explorer / Tree
return {
  -- https://github.com/nvim-tree/nvim-tree.lua
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    'nvim-tree/nvim-web-devicons', -- Fancy icon support
  },
  opts = {
    -- Java/Kotlin repos have deep package paths (com/kitetech/.../bounded_contexts/...)
    -- and long file names. Two tweaks keep names readable:
    --   1) group_empty collapses single-child folder chains onto one line, so a whole
    --      package (com/kitetech/core_monolith) shows as one entry instead of 5 indents.
    --   2) adaptive width lets the panel grow to fit the longest visible name (up to 60),
    --      instead of the fixed 30 that truncated long file names.
    renderer = {
      group_empty = true,
      indent_markers = { enable = true },
    },
    view = {
      width = {
        min = 30,
        max = 60,
      },
    },
    actions = {
      open_file = {
        window_picker = {
          enable = false
        },
      }
    },
  },
  config = function (_, opts)
  -- Recommended settings to disable default netrw file explorer
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup(opts)

    -- Open automatically nvim-tree if no file is passed when starting Neovim
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local args = vim.fn.argv()
        if #args == 0 then
          require("nvim-tree.api").tree.open()
        end
      end
    })
end
}
