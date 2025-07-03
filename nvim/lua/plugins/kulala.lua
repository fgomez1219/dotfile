return {
  "mistweaverco/kulala.nvim",
  -- Load the plugin only for http and rest filetypes
  ft = {"http", "rest"}, -- Or event = "VeryLazy", if you prefer to load it lazily
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  -- THIS IS THE CRUCIAL PART: Ensure your keymaps include the 'function()'
  keys = {
    -- Keymap for "Send request"
    { "<leader>Rs", desc = "Kulala: Send request", mode = {"n", "v"}, function() require("kulala").run() end },
    -- Keymap for "Send all requests"
    { "<leader>Ra", desc = "Kulala: Send all requests", mode = {"n", "v"}, function() require("kulala").run_all() end },
    -- Keymap for "Open scratchpad"
    { "<leader>Rb", desc = "Kulala: Open scratchpad", function() require("kulala").open_scratchpad() end },
    -- Keymap for "Open request history"
    { "<leader>Rh", desc = "Kulala: Open request history", function() require("kulala").history.open() end },
  },
  config = function()
    require("kulala").setup({
      -- cURL path
      curl_path = "curl",
      -- additional cURL options
      additional_curl_options = {},
      -- gRPCurl path
      grpcurl_path = "grpcurl",
      -- websocat path
      websocat_path = "websocat",
      -- openssl path
      openssl_path = "openssl",

      -- set scope for environment and request variables
      environment_scope = "b",
      default_env = "dev",
      vscode_rest_client_environmentvars = false,

      request_timeout = nil,
      halt_on_error = true,

      certificates = {},
      urlencode = "always",

      contenttypes = {
        ["application/json"] = {
          ft = "json",
          formatter = vim.fn.executable("jq") == 1 and { "jq", "." },
          pathresolver = function(...)
            return require("kulala.parser.jsonpath").parse(...)
          end,
        },
        ["application/xml"] = {
          ft = "xml",
          formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "-" },
          pathresolver = vim.fn.executable("xmllint") == 1 and { "xmllint", "--xpath", "{{path}}", "-" },
        },
        ["text/html"] = {
          ft = "html",
          formatter = vim.fn.executable("xmllint") == 1 and { "xmllint", "--format", "--html", "-" },
          pathresolver = nil,
        },
      },

      ui = {
        display_mode = "split",
        split_direction = "vertical",
        win_opts = {},
        default_view = "body",
        winbar = true,
        default_winbar_panes = { "body", "headers", "headers_body", "verbose", "script_output", "report", "help" },
        show_variable_info_text = false,
        show_icons = "on_request",
        icons = {
          inlay = {
            loading = "⏳",
            done = "✅",
            error = "❌",
          },
          lualine = "🐼",
          textHighlight = "WarningMsg",
        },

        show_request_summary = true,
        disable_script_print_output = false,

        report = {
          show_script_output = true,
          show_asserts_output = true,
          show_summary = true,

          headersHighlight = "Special",
          successHighlight = "String",
          errorHighlight = "Error",
        },

        scratchpad_default_contents = {
          "@MY_TOKEN_NAME=my_token_value",
          "",
          "POST https://httpbin.org/post HTTP/1.1",
          "accept: application/json",
          "content-type: application/json",
          "",
          "{",
          '  "foo": "bar"',
          "}",
        },

        disable_news_popup = false,
        autocomplete = true,
        lua_syntax_hl = true,
      },

      debug = 3,
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps = true,
    })

    -- This line was the cause of the previous error, so we keep it commented or removed.
    -- Kulala should automatically detect Telescope if it's installed as a dependency.
    -- require("kulala.config").setup_telescope()
  end,
}
