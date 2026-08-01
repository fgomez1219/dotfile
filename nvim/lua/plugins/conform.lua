return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    -- No Kotlin formatter here on purpose: core-monolith uses Spotless + ktfmt with
    -- maxWidth 140 (set via the Gradle/Spotless API, which the ktfmt CLI cannot replicate --
    -- its --kotlinlang-style is hardcoded to width 100), and payments-service enforces none.
    -- A CLI formatter would fight `spotlessCheck` in CI. Kotlin is formatted via the repo's
    -- own Gradle (`spotlessApply`) -- see the <leader>F keymap in ftplugin/kotlin.lua.
    require("conform").setup({
      formatters_by_ft = {},
    })
  end,
}
