-- This script configures the nvim-aider plugin and its dependencies for Neovim.
-- It's designed to be used with a plugin manager like Lazy.nvim.

return {
  "GeorgesAlkhouri/nvim-aider",
  cmd = "Aider",
  -- Key mappings for common Aider actions
  keys = {
    { "<leader>a/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
    { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
    { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
    { "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
    { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
    { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
    { "<leader>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
    -- nvim-tree.lua integration (if nvim-tree is installed and active)
    { "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
    { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
  },
  dependencies = {
    "folke/snacks.nvim",
    -- Optional dependencies:
    "catppuccin/nvim",
    "nvim-tree/nvim-tree.lua",
    -- Neo-tree integration
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = function(_, opts)
        require("nvim_aider.neo_tree").setup(opts)
      end,
    },
  },
  -- Custom configuration function for nvim-aider
  config = function()
    require("nvim_aider").setup({
      -- Command that executes Aider
      aider_cmd = "aider",
      -- Command line arguments passed to aider
      args = {
        "--no-auto-commits",
        "--pretty",
        "--stream",
      },
      -- Automatically reload buffers changed by Aider (requires vim.o.autoread = true)
      auto_reload = false,
      -- Theme colors (automatically uses Catppuccin flavor if available)
      theme = {
        user_input_color = "#a6da95",
        tool_output_color = "#8aadf4",
        tool_error_color = "#ed8796",
        tool_warning_color = "#eed49f",
        assistant_output_color = "#c6a0f6",
        completion_menu_color = "#cad3f5",
        completion_menu_bg_color = "#24273a",
        completion_menu_current_color = "#181926",
        completion_menu_current_bg_color = "#f4dbd6",
      },
      -- snacks.picker.layout.Config configuration
      picker_cfg = {
        preset = "vscode",
      },
      -- Other snacks.terminal.Opts options
      config = {
        os = { editPreset = "nvim-remote" },
        gui = { nerdFontsVersion = "3" },
      },
      win = {
        wo = { winbar = "Aider" },
        style = "nvim_aider",
        position = "right",
      },
    })
  end,
}
