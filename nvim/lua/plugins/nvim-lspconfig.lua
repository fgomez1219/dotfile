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
      },
    })

    -- Instala herramientas si falta alguna
    vim.api.nvim_command('MasonToolsInstall')

    local lspconfig = require('lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local on_attach = function(client, bufnr)
      -- Tus keymaps aquí si querés
    end

    -- Lista de servidores para configurar
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
    }

    for _, server in ipairs(servers) do
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end

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

