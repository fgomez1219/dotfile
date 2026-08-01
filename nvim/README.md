## Avante.nvim + Claude via AWS Bedrock

AI-powered code assistance inside Neovim using [avante.nvim](https://github.com/yetone/avante.nvim) with Claude on AWS Bedrock. Uses the same AWS profile (`OrganizationEngRole`) as Claude Code.

### Prerequisites

- **curl >= 8.10.0** (required for AWS SigV4 signing). Check with `curl --version`.
- **AWS credentials** configured via `saml2aws` for the `OrganizationEngRole` profile.

### Setup

1. **Authenticate with AWS** (same flow as Claude Code):

   ```bash
   saml2aws --region=us-east-1 login --skip-prompt --profile default --session-duration=43200
   ```

2. **Open Neovim** -- Lazy will auto-install avante.nvim and its dependencies on first launch. The native module is compiled via `make` during install.

3. **Verify installation** -- run `:Lazy` and confirm `avante.nvim` shows as installed without errors.

### Keybindings

Avante (Claude) uses `<leader>a`, CopilotChat uses `<leader>A`:

**Avante (Claude via Bedrock) -- `<leader>a`:**

| Keybinding     | Mode     | Action                                      |
|----------------|----------|---------------------------------------------|
| `<leader>aa`   | n, v     | **Ask** -- open the AI chat sidebar          |
| `<leader>ae`   | v        | **Edit** -- edit selected code with AI       |
| `<leader>ar`   | n        | **Refresh** -- refresh the AI response       |
| `<leader>at`   | n        | **Toggle** -- toggle the avante sidebar      |
| `<leader>ad`   | n        | Toggle debug mode                            |
| `<leader>ah`   | n        | Toggle inline hints                          |
| `<leader>as`   | n        | Toggle suggestions                           |

**CopilotChat -- `<leader>A`:**

| Keybinding     | Mode     | Action                                      |
|----------------|----------|---------------------------------------------|
| `<leader>Ai`   | n        | Ask Copilot (input)                          |
| `<leader>Ae`   | n        | Explain code                                 |
| `<leader>At`   | n        | Generate tests                               |
| `<leader>Ar`   | n        | Review code                                  |
| `<leader>AR`   | n        | Refactor code                                |
| `<leader>Af`   | n        | Fix diagnostic                               |
| `<leader>Av`   | n        | Toggle chat vsplit                           |
| `<leader>Am`   | n        | Generate commit message                      |

### Basic usage

1. **Ask a question about your code**: press `<leader>aa`, type your question in the sidebar, and press `<CR>` to send.

2. **Edit code with AI**: select code in visual mode, press `<leader>ae`, describe the change you want, and avante will generate a diff you can accept or reject.

3. **Inline suggestions**: with suggestions enabled (`<leader>as`), Claude will suggest completions as you type.

### Configuration

The plugin config lives in `~/.config/nvim/lua/plugins/avante.lua`.

**Change model**: edit the `model` field in `providers.bedrock`:

```lua
providers = {
  bedrock = {
    aws_profile = "OrganizationEngRole",
    aws_region = "us-east-1",
    model = "us.anthropic.claude-sonnet-4-20250514-v1:0",
    -- Other available models:
    -- "us.anthropic.claude-opus-4-20250514-v1:0"
    -- "us.anthropic.claude-haiku-4-5-20251001-v1:0"
    -- Or use an inference profile ARN:
    -- "arn:aws:bedrock:us-east-1:<account_id>:inference-profile/us.anthropic.claude-opus-4-6-v1"
  },
},
```

**Adjust temperature/max tokens**:

```lua
extra_request_body = {
  temperature = 0.7,    -- 0.0 = deterministic, 1.0 = creative
  max_tokens = 16384,
},
```

### Troubleshooting

- **Build fails**: ensure you have `make`, `gcc`/`clang`, and `curl >= 8.10.0` installed.
- **Auth errors**: re-authenticate with `saml2aws --region=us-east-1 login --skip-prompt --profile default --session-duration=43200`
- **"curl does not support AWS SigV4"**: upgrade curl to >= 8.10.0 (`brew install curl`).
- **Plugin not loading**: run `:Lazy sync` to force reinstall, then restart nvim.
- **Restore backup**: if something breaks, your pre-avante config is saved at `~/.config/nvim.backup.20260406_200522/`

---

## Rollback (restore config from backup)

Backups are stored under `~/.config/nvim-backups/` with names like `nvim-YYYY-MM-DD-HHMMSS`. To restore:

```bash
# Replace <backup-dir> with the folder name, e.g. nvim-2026-03-16-211217
rm -rf ~/.config/nvim
cp -R ~/.config/nvim-backups/<backup-dir> ~/.config/nvim
```

To create a new backup before making changes:

```bash
mkdir -p ~/.config/nvim-backups
cp -R ~/.config/nvim ~/.config/nvim-backups/nvim-$(date +%Y-%m-%d-%H%M%S)
```

## Prerequisites ##
- [True Color Terminal](https://gist.github.com/kurahaupo/6ce0eaefe5e730841f03cb82b061daa2#now-supporting-true-color) - Make Neovim look pretty
- [Neovim](https://neovim.io/) - Version 0.9.1 or later
- [Nerd Font](https://www.nerdfonts.com/) - Needed to see nice icons in Neovim
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Needed for Telescope Fuzzy Finder
- [xclip](https://linuxconfig.org/how-to-use-xclip-on-linux) - Needed for system clipboard support
- [npm/node](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [Python](https://www.python.org/) - Version 3.8 or later

## Java / Kotlin (Spring Boot) debugging

**Requirements:** JDK 21 (for Eclipse JDT LS), **jdtls** (install via `:MasonInstall jdtls`), and **java-debug**.

**Check if java-debug is installed:** The config looks for `com.microsoft.java.debug.plugin-*.jar` under `~/.local/share/nvim/java-debug`. From a terminal:

```bash
find ~/.local/share/nvim/java-debug -name "com.microsoft.java.debug.plugin-*.jar" 2>/dev/null
```

If that prints a path, it's installed. From Neovim: `:lua print(vim.inspect(require('jdtls_config').java_debug_bundles()))` — if you see a table with jar paths, java-debug is installed.

**Install java-debug** into `~/.local/share/nvim/java-debug` using one of:

1. **Open VSX (quick):**
   - Download [Debugger for Java](https://open-vsx.org/extension/vscjava/vscode-java-debug) (`.vsix`), then:
   ```bash
   mkdir -p ~/.local/share/nvim/java-debug
   unzip -d ~/.local/share/nvim/java-debug /path/to/vscjava.vscode-java-debug-*.vsix
   ```
   The jar will be at `~/.local/share/nvim/java-debug/extension/server/com.microsoft.java.debug.plugin-*.jar`.

2. **From source:**
   ```bash
   git clone https://github.com/microsoft/java-debug.git ~/.local/share/nvim/java-debug
   cd ~/.local/share/nvim/java-debug && ./mvnw clean install
   ```
   The jar is at `~/.local/share/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar`.

**Testing the setup:**

1. **Verify jdtls starts:** Open a Java or Kotlin file (`.java` or `.kt`) in a Gradle/Maven project (one with `build.gradle`, `pom.xml`, etc.). Check that LSP is running:
   - `:LspInfo` should show `jdtls` as active
   - You should see LSP features working (hover, go-to-definition, etc.)

2. **Verify java-debug bundles:** In Neovim, run:
   ```vim
   :lua print(vim.inspect(require('jdtls_config').java_debug_bundles()))
   ```
   Should print a table with jar path(s), not `{}`.

3. **Check debug configs are available:** In a Java/Kotlin file, press `<leader>ds` (Telescope dap configurations). You should see at least "Attach to Kotlin (Spring Boot)" (or similar). If you don't see launch configs yet, run `<leader>dy` (`:JdtUpdateDebugConfig`) to refresh.

4. **Quick test with a simple main class:**
   - Create a simple Java/Kotlin file with a `main` method in your project
   - Put a breakpoint on a line (`<leader>bb`)
   - Press `<leader>dy` to refresh configs
   - Press `<leader>ds` and select "Launch …" (should auto-detect your main class)
   - Press `<leader>dc` to continue — the debugger should start and hit your breakpoint

**Launch (run from Neovim):** Open a Java or Kotlin file in a Gradle/Maven project. Put breakpoints (`<leader>bb`). Run `<leader>dy` to refresh debug configs, then `<leader>ds` to pick a configuration (e.g. "Launch …" for your main or Spring Boot). Continue with `<leader>dc`.

**Attach (app already running with debug):** Start the app with the JDWP agent, then attach from Neovim.

- **Gradle:** `./gradlew bootRun --debug-jvm` (default port 5005), or in `build.gradle`: `bootRun { jvmArgs = ["-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"] }`.
- **Maven:** `mvn spring-boot:run -Dspring-boot.run.jvmArguments="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5005"`.

Then in Neovim: `<leader>ds` and choose "Attach to Kotlin (Spring Boot)" (or the Java attach config).

**Keymaps:** `<leader>ds` = pick debug configuration; `<leader>dy` = refresh Java/Kotlin configs (jdtls); `<leader>bb` = breakpoint; `<leader>dc` = continue; `<leader>dj`/`dk`/`do` = step over/into/out.

# Nerd Font installation
- Download 
- Extract.
- Put the extracted folder into /usr/.local/share/fonts if you want them to be installed only to your user, or /usr/share/fonts if you want them installed globally.
- Rebuild font cache by running `fc-cache -f -v`

Then to add the font to alacritty:

For yaml configuration:
```
font:
  size: <repace_with_your_size>
  normal:
    family: <name_of_the_font>
```

For toml configuration:
```
[font]
size = <repace_with_your_size>
normal = { family = "<name_of_the_font>", style = "Regular" }
```
