-- Shared config for nvim-jdtls (Java and Kotlin in Gradle/Maven projects).
-- Used by ftplugin/java.lua and ftplugin/kotlin.lua.
-- Requires: JDK 21 (for JDT LS), jdtls (e.g. Mason), java-debug (see README).

local M = {}

-- Root directory: project root for Gradle/Maven (so jdtls only starts in such projects).
local function root_dir()
  return vim.fs.root(0, { "gradlew", "mvnw", ".git", "build.gradle", "build.gradle.kts", "pom.xml", "settings.gradle" })
end

-- Path to jdtls executable. Prefer Mason install if available.
local function jdtls_cmd()
  local ok, settings = pcall(require, "mason.settings")
  if ok and settings and settings.current and settings.current.install_root_dir then
    local path = settings.current.install_root_dir .. "/packages/jdtls/bin/jdtls"
    if vim.fn.executable(path) == 1 then
      return { path }
    end
  end
  if vim.fn.executable("jdtls") == 1 then
    return { "jdtls" }
  end
  return { "jdtls" }
end

-- Java-debug bundle path. Install java-debug to e.g. ~/.local/share/nvim/java-debug (see README).
local function java_debug_bundles()
  local data = vim.fn.stdpath("data")
  -- Open VSX layout: .../java-debug/.../extension/server/*.jar
  local glob = vim.fn.glob(data .. "/java-debug/**/com.microsoft.java.debug.plugin-*.jar", true)
  if glob and glob ~= "" then
    return vim.split(glob, "\n")
  end
  -- Source build layout: .../java-debug/com.microsoft.java.debug.plugin/target/*.jar
  glob = vim.fn.glob(data .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", true)
  if glob and glob ~= "" then
    return vim.split(glob, "\n")
  end
  return {}
end

--- Return paths to java-debug plugin jars, or {} if not installed.
--- Use from Neovim: :lua print(vim.inspect(require('jdtls_config').java_debug_bundles()))
M.java_debug_bundles = java_debug_bundles

-- Spring Boot LS jdtls extension bundles must be loaded INSIDE jdtls so it registers the
-- `sts.*` commands the Spring Boot LS consumes. We delegate to spring-boot.nvim's
-- java_extensions(), which resolves them from the Mason install and returns only the valid
-- OSGi bundles (jdtls rejects the whole list if a non-bundle jar is included, which would
-- also drop the java-debug bundle and break debugging). Returns {} if the plugin or the
-- package isn't present, so plain (non-Spring) projects are unaffected.
local function spring_bundles()
  local ok, spring_boot = pcall(require, "spring_boot")
  if not ok then
    return {}
  end
  return spring_boot.java_extensions() or {}
end

--- Return Spring Boot LS jdtls bundle jars, or {} if not installed.
M.spring_bundles = spring_bundles

function M.build_config()
  local root = root_dir()
  if not root then
    return nil
  end

  -- Bundles loaded into jdtls: java-debug (for DAP) + Spring Boot LS extension (for
  -- Spring project indexing). Both are optional; missing ones just contribute nothing.
  local bundles = java_debug_bundles()
  vim.list_extend(bundles, spring_bundles())
  local cmd = jdtls_cmd()

  -- Workspace dir for JDT LS data (avoids reindex on reboot if not in /tmp).
  local project_name = vim.fn.fnamemodify(root, ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

  local config = {
    name = "jdtls",
    cmd = cmd,
    root_dir = root,
    -- Data directory so index survives reboot.
    init_options = {
      bundles = bundles,
    },
    settings = {
      java = {
        configuration = {
          runtimes = {},
        },
      },
    },
    -- Register the java DAP adapter after jdtls attaches.
    on_attach = function()
      require("jdtls").setup_dap({ hotcodereplace = "auto" })
    end,
  }

  -- Pass -data to jdtls so index survives reboot (not in /tmp).
  if #cmd >= 1 and type(cmd[1]) == "string" then
    config.cmd = { cmd[1], "-data", workspace_dir }
  end

  return config
end

return M
