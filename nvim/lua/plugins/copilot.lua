-- NOTE: Only enable either copilot-vim or codeium-vim at the same time
--return {
  -- Setup copilot.vim
  --{
    --"github/copilot.vim",
    --event = "VeryLazy",
    --config = function()
      -- For copilot.vim
      -- enable copilot for specific filetypes
      --vim.g.copilot_filetypes = {
        --["TelescopePrompt"] = false,
      --}

      -- Set to true to assume that copilot is already mapped
      --vim.g.copilot_assume_mapped = true
      -- Set workspace folders
      --vim.g.copilot_workspace_folders = "/home/eurekalabs/projects"

      -- Setup keymaps
      --local keymap = vim.keymap.set
      --local opts = { silent = true }

      -- Set <C-y> to accept copilot suggestion
      --vim.g.copilot_no_tab_map = true
      --keymap("i", "<C-t>", 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })

      -- Set <C-i> to accept line
      --keymap("i", "<C-i>", "<Plug>(copilot-accept-line)", opts)

      -- Set <C-j> to next suggestion, <C-k> to previous suggestion, <C-l> to suggest
      --keymap("i", "<C-j>", "<Plug>(copilot-next)", opts)
      --keymap("i", "<C-k>", "<Plug>(copilot-previous)", opts)
      --keymap("i", "<C-l>", "<Plug>(copilot-suggest)", opts)

      -- Set <C-d> to dismiss suggestion
      --keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", opts)
    --end,
  --},
--}
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_word = false,
          accept_line = "<C-i>",
          next = "<C-j>",
          prev = "<C-k>",
          dismiss = "<C-d>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = false,
        gitcommit = true,
        TelescopePrompt = false,
      },
    })
  end,
}
