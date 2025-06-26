-- File Explorer / Tree
return {
  -- https://github.com/nvim-tree/nvim-tree.lua
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    -- https://github.com/nvim-tree/nvim-web-devicons
    'nvim-tree/nvim-web-devicons', -- Fancy icon support
  },
  opts = {
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
