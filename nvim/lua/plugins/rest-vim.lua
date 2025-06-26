return {
  {
    "rest-nvim/rest.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      ensure_installed = { "http" },
    },
    config = function()
      -- Ensure vim.g.rest_nvim_env is a table before using it.
      vim.g.rest_nvim_env = vim.g.rest_nvim_env or {}

      require("rest-nvim").setup({
        custom_dynamic_variables = {},
        request = {
          skip_ssl_verification = false,
          hooks = {
            encode_url = true,
            user_agent = "rest.nvim v" .. require("rest-nvim.api").VERSION,
            set_content_type = true,
          },
        },
        response = {
          hooks = {
            decode_url = true,
            format = true,
            post_process = function(body, context)
              print("--- POST PROCESS HOOK INICIADO ---")
              print("Tipo de body recibido (parseado):", type(body))
              -- Prints the body in a readable format
              if type(body) == "table" then
                print("Contenido de body (parseado):", vim.inspect(body))
              else
                print("Body (sin parsear como tabla):", tostring(body))
              end

              if context and context.response and context.response.body then
                print("--- RAW RESPONSE BODY ---")
                print(context.response.body) -- To print the raw response body
                print("--- FIN RAW RESPONSE BODY ---")
              end

              -- Logic to save tokens
              if type(body) == "table" and body.jwtToken then
                vim.g.rest_nvim_env.REST_JWT_TOKEN = body.jwtToken
                print("JWT Token guardado en REST_JWT_TOKEN!")
              end

              if type(body) == "table" and body.token then
                vim.g.rest_nvim_env.REST_INTERNAL_TOKEN = body.token
                print("Internal Token guardado en REST_INTERNAL_TOKEN!")
              end
              print("--- POST PROCESS HOOK FINALIZADO ---")
            end,
          },
        },
        clients = {
          curl = {
            statistics = {
              { id = "time_total", winbar = "take", title = "Time taken" },
              { id = "size_download", winbar = "size", title = "Download size" },
            },
            opts = {
              set_compressed = false,
              certificates = {},
            },
          },
        },
        cookies = {
          enable = true,
          path = vim.fs.joinpath(vim.fn.stdpath("data"), "rest-nvim.cookies"),
        },
        env = {
          enable = true,
          pattern = ".*%.env.*",
          find = function()
            local config = require("rest-nvim.config")
            return vim.fs.find(function(name, _)
              return name:match(config.env.pattern)
            end, {
              path = vim.fn.getcwd(),
              type = "file",
              limit = math.huge,
            })
          end,
        },
        ui = {
          winbar = true,
          keybinds = {
            prev = "H",
            next = "L",
          },
        },
        highlight = {
          enable = true,
          timeout = 750,
        },
        _log_level = vim.log.levels.WARN,
      })
    end,
  },
  -- Ensure nvim-treesitter is set up correctly to support the 'http' parser.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "vim", "vimdoc", "http" },
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
