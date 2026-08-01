-- ~/.config/nvim/lua/plugins/code-companion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",
  },
  keys = {
    { "<leader>Cc", "<cmd>CodeCompanionChat<CR>", desc = "CodeCompanion Chat" },
    { "<leader>Cg", "<cmd>CodeCompanionGenerate<CR>", desc = "CodeCompanion Generate" },
    { "<leader>Cr", "<cmd>CodeCompanionRefactor<CR>", desc = "CodeCompanion Refactor" },
    { "<leader>Ce", "<cmd>CodeCompanionExplain<CR>", desc = "CodeCompanion Explain" },
    { "<leader>Cq", "<cmd>CodeCompanionQuestion<CR>", desc = "CodeCompanion Question" },
    { "<leader>Ca", "<cmd>CodeCompanion<CR>", desc = "CodeCompanion Actions" },
  },
  opts = {
    providers = {
      my_company_llm = {
        adapter = "openai_compatible",
        opts = {
          endpoint = os.getenv("NVIM_LLM_ENDPOINT") or "http://localhost:8080/openai/v1",
          api_key = os.getenv("NVIM_LLM_API_KEY") or "",
          model = "openai/google/gemini-2.5-pro",
          timeout = 60,
        },
      },
      strategies = {
        chat = { provider = "my_company_llm" },
        inline = { provider = "my_company_llm" },
      },
      -- You can add other providers here if you use them, e.g.:
      -- openai = {
      --     adapter = "openai",
      --     opts = {
      --         api_key = os.getenv("OPENAI_API_KEY"),
      --         model = "gpt-4o",
      --     }
      -- },
    },
    chat = {
      default_provider = "my_company_llm",
      width = 0.4,
      position = "right",
    },
    actions = {
      default_provider = "my_company_llm",
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
}
