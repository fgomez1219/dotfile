-- Java/Kotlin LSP (Eclipse JDT LS) + DAP (java-debug) for launch and attach.
-- Start is done from ftplugin/java.lua and ftplugin/kotlin.lua so jdtls runs only in Gradle/Maven roots.
-- Requires: JDK 21, jdtls (Mason or PATH), java-debug (see README).
return {
  "mfussenegger/nvim-jdtls",
  event = "VeryLazy",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap = require("dap")

    -- Attach config for remote debug (e.g. Spring Boot with --debug-jvm on port 5005).
    -- nvim-jdtls registers the java adapter when you open a Java/Kotlin file in a project.
    local attach_config = {
      type = "java",
      request = "attach",
      name = "Attach to Kotlin (Spring Boot)",
      hostName = "127.0.0.1",
      port = 5005,
    }

    if not dap.configurations.java then
      dap.configurations.java = {}
    end
    -- Avoid duplicating if already present (e.g. from .vscode/launch.json).
    local has_attach = false
    for _, c in ipairs(dap.configurations.java) do
      if c.name == attach_config.name and c.request == "attach" then
        has_attach = true
        break
      end
    end
    if not has_attach then
      table.insert(dap.configurations.java, attach_config)
    end

    -- Kotlin uses the same adapter and configs.
    dap.configurations.kotlin = dap.configurations.java
  end,
}
