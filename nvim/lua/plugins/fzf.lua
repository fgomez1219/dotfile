return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      "default",
      winopts = {
        height = 0.85,
        width = 0.80,
        row = 0.35,
        col = 0.50,
        border = "rounded",
        preview = {
          default = "bat",
          layout = "horizontal",
          vertical = "down:70%",
        },
      },
      files = {
        prompt = "Files❯ ",
        git_icons = true,
        file_icons = true,
        color_icons = true,
      },
      grep = {
        prompt = "Rg❯ ",
        input_prompt = "Grep for > ",
        rg_opts = "--column --line-number --no-heading --color=always --smart-case -g '!node_modules/*' ",
      },
    })

    -- key map
    -- vim.keymap.set("n", "<leader>kq", "<cmd>lua require('fzf-lua').files()<CR>", { desc = "Search files" })
    -- vim.keymap.set("n", "<leader>kg", "<cmd>lua require('fzf-lua').live_grep()<CR>", { desc = "Search text (ripgrep)" })
    -- vim.keymap.set("n", "<leader>kb", "<cmd>lua require('fzf-lua').buffers()<CR>", { desc = "Search buffers" })
    -- vim.keymap.set("n", "<leader>kh", "<cmd>lua require('fzf-lua').help_tags()<CR>", { desc = "Search ayuda" })

    -- vim.keymap.set("n", "<leader>fm", function()
    --   require("fzf-lua").keymaps()
    -- end, { desc = "Search keymaps " })
  end,
}
