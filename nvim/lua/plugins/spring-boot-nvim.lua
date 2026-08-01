-- Spring Boot Language Server integration (JavaHello/spring-boot.nvim).
--
-- Why a plugin instead of hand-wiring vim.lsp.config: the Spring Boot LS (VMware
-- spring-tools, installed via Mason as vscode-spring-boot-tools) is not a standalone
-- server -- it talks to jdtls over a "classpath listener" protocol (sts/addClasspathListener
-- -> sts.java.addClasspathListener) and needs the workspace/executeClientCommand handler
-- plus a startup handshake. Doing that by hand caused an init-order NPE
-- (getExecuteCommandProvider() is null); this plugin implements the whole protocol.
--
-- It reads the LS jar and jdtls extension bundles from the Mason install automatically
-- ($MASON/share/vscode-spring-boot-tools/{language-server.jar,jdtls/*.jar}). The bundles
-- are handed to jdtls via require("spring_boot").java_extensions() in jdtls_config.lua.
return {
  "JavaHello/spring-boot.nvim",
  ft = { "java", "kotlin", "yaml", "jproperties", "properties" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-jdtls",
  },
  config = function()
    require("spring_boot").setup({
      -- jdtls client is named "jdtls" in jdtls_config.lua (matches the default).
      jdtls_name = "jdtls",
      -- Use the same JDK 21 jdtls/kotlin use; JAVA_HOME is honored by the plugin.
    })
  end,
}
