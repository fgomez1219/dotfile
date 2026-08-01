-- ~/.config/nvim/lua/plugins/avante.lua
-- AI-powered code assistance using Claude via AWS Bedrock + avante.nvim
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = { insert_mode = true },
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = { file_types = { "markdown", "Avante" } },
      ft = { "markdown", "Avante" },
    },
  },
  opts = {
    -- Use AWS Bedrock as the provider (authenticates via AWS profile)
    provider = "bedrock",
    providers = {
      bedrock = {
        aws_profile = os.getenv("NVIM_AWS_PROFILE") or "default",
        aws_region = "us-east-1",
        model = "us.anthropic.claude-sonnet-4-20250514-v1:0",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.7,
          max_tokens = 16384,
        },
      },
    },
    -- Keybindings (all prefixed with <leader>a)
    mappings = {
      ask = "<leader>aa",
      edit = "<leader>ae",
      refresh = "<leader>ar",
      toggle = {
        default = "<leader>at",
        debug = "<leader>ad",
        hint = "<leader>ah",
        suggestion = "<leader>as",
      },
    },
  },
}
