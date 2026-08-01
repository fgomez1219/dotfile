-- Kotlin editing (diagnostics/navigation/completion) is provided by the JetBrains
-- kotlin-lsp, configured in plugins/nvim-lspconfig.lua.
--
-- We ALSO start jdtls here, purely for debugging: the java-debug adapter runs inside
-- jdtls, so DAP (attach to a running Spring Boot app on :5005, or launch) only works
-- when jdtls is attached to the project. jdtls does not provide Kotlin language
-- features -- kotlin-lsp handles those; jdtls is here only to expose the debug adapter.
local config = require("jdtls_config").build_config()
if config then
  require("jdtls").start_or_attach(config)
end

-- <leader>F: format the current file with the project's own Spotless (ktfmt), so the
-- result matches CI exactly (e.g. core-monolith's maxWidth 140). We shell out to the
-- repo's Gradle wrapper rather than a CLI formatter because only the Gradle/Spotless
-- config knows the project's real style. Projects without Spotless (e.g. payments-service)
-- simply report that no task exists instead of erroring.
vim.keymap.set("n", "<leader>F", function()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file to format", vim.log.levels.WARN)
    return
  end

  -- Find the Gradle root (the dir containing gradlew), which lives in code/ in these repos.
  local gradle_root = vim.fs.root(0, { "gradlew" })
  if not gradle_root then
    vim.notify("No gradlew found -- cannot run Spotless", vim.log.levels.WARN)
    return
  end

  -- Spotless applies per-fileset; scope to just this file so we don't reformat the repo.
  vim.cmd("write")
  vim.notify("Running spotlessApply on " .. vim.fn.fnamemodify(file, ":t") .. "...", vim.log.levels.INFO)
  local out = vim.fn.system({
    gradle_root .. "/gradlew",
    "-p", gradle_root,
    "spotlessApply",
    "-PspotlessIdeHook=" .. file,
    "--quiet",
  })
  if vim.v.shell_error ~= 0 then
    if out:match("[Tt]ask 'spotlessApply' not found") then
      vim.notify("This project has no spotlessApply task (no Spotless configured)", vim.log.levels.WARN)
    else
      vim.notify("spotlessApply failed:\n" .. out, vim.log.levels.ERROR)
    end
    return
  end
  -- Reload the buffer to pick up Spotless's on-disk changes.
  vim.cmd("checktime")
  vim.notify("spotlessApply done", vim.log.levels.INFO)
end, { buffer = true, desc = "Format file with project Spotless (ktfmt)" })
