-- LSP Support
return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'j-hui/fidget.nvim', opts = {} },
    { 'folke/neodev.nvim' },
  },
  config = function ()
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = {
        'bashls',
        'cssls',
        'html',
        'lua_ls',
        'jsonls',
        'lemminx',
        'marksman',
        'quick_lint_js',
        'yamlls',
        'pyright',
        'ts_ls', -- JS/TS: go-to-definition, hover, completion (quick_lint_js is lint-only)
        'jdtls', -- Java in Gradle/Maven (used by ftplugin/java.lua)
      }
    })

    require('mason-tool-installer').setup({
      ensure_installed = {
        'black',
        'debugpy',
        'flake8',
        'isort',
        'mypy',
        'pylint',
        'ktlint',
      },
    })

    -- Instala herramientas si falta alguna
    vim.api.nvim_command('MasonToolsInstall')

    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, bufnr)
      -- Tus keymaps aquí si querés
    end

    -- Lista de servidores para configurar (kotlin y lua tienen config explícita más abajo)
    local servers = {
      'bashls',
      'cssls',
      'html',
      'jsonls',
      'lemminx',
      'marksman',
      'quick_lint_js',
      'yamlls',
      'pyright',
      'ts_ls',
    }

    for _, server in ipairs(servers) do
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end

    -- Kotlin: Official JetBrains kotlin-lsp (replaces deprecated fwcd/kotlin-language-server).
    -- Uses the native nvim 0.11 vim.lsp.config/vim.lsp.enable API (not the lspconfig
    -- framework), since kotlin-lsp is not in the lspconfig registry.
    --
    -- root_markers uses nested lists to express priority (nvim 0.11): the first group is
    -- tried first, and .git is only a last resort. This matters because in these repos
    -- (core-monolith, payments-service) the Gradle project lives in a `code/` subdir while
    -- .git sits one level up at the repo root -- we want the LSP anchored at the Gradle
    -- root (so it resolves dependencies/symbols), not at the repo root. Within the first
    -- group, the closest ancestor containing any marker wins.
    vim.lsp.config("kotlin_lsp", {
      cmd = { "kotlin-lsp", "--stdio" },
      filetypes = { "kotlin" },
      root_markers = {
        {
          "settings.gradle.kts",
          "settings.gradle",
          "pom.xml",
          "build.gradle.kts",
          "build.gradle",
        },
        ".git",
      },
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.enable("kotlin_lsp")

    -- Spring Boot Language Server is wired via the JavaHello/spring-boot.nvim plugin
    -- (lua/plugins/spring-boot-nvim.lua), which implements the jdtls classpath-listener
    -- handshake the server needs. Its jdtls extension bundles are added in jdtls_config.lua.

    -- Config especial para Lua
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
        },
      },
    })

    -- Ventanas flotantes con borde redondeado
    local orig_util = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      return orig_util(contents, syntax, opts, ...)
    end
  end
}

