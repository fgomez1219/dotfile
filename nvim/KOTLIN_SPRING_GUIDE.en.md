# Kotlin + Spring Boot in Neovim — Usage Guide

Practical guide to get the most out of this config when working on Kotlin/Spring
(core-monolith, payments-service). The **leader** key is `<Space>`.

> Tip: this config has **which-key**. Press `<Space>` and wait — it shows all the
> available keymap groups. If you forget something, look there first.

---

## 1. Architecture (what runs and why)

When you open a `.kt` file in a Gradle project, **two** language servers start,
each with its own role:

| Server | Role | Starts when |
|--------|------|-------------|
| **kotlin-lsp** (JetBrains) | Editing: completion, navigation, diagnostics, rename | you open a `.kt` |
| **jdtls** (Eclipse JDT) | Debug (java-debug adapter) + project info for Spring | you open a `.kt`/`.java` in a project with `gradlew` |
| **spring-boot** (VMware) | Completion/validation/hover in `application*.properties` and `@`-annotations | you open `.kt`/`application*.properties` with jdtls already up |

**Important about timing:** jdtls takes a few seconds to index the project the
first time (you'll see "Starting Java Language Server… ServiceReady"). Spring
completion in `application.properties` shows up **after** jdtls finishes
indexing. Be patient on the first file.

Project root: it anchors at the dir containing `settings.gradle(.kts)`/`build.gradle`
(in these repos, the `code/` folder), not at the repo root.

---

## 2. Code navigation (LSP)

All with the `<leader>g` ("go") prefix:

| Keymap | Action |
|--------|--------|
| `<leader>gg` | Hover (doc/type under the cursor) |
| `<leader>gd` | Go to definition |
| `<leader>gD` | Go to declaration |
| `<leader>gi` | Go to implementation |
| `<leader>gt` | Go to type definition |
| `<leader>gr` | References |
| `<leader>gs` | Signature help (method signature) |
| `<leader>ga` | **Code actions** (quick fixes, imports, etc.) |
| `<leader>rr` | Rename (symbol across the whole project) |
| `<leader>tr` | Document symbols (outline) |

Diagnostics (errors/warnings):

| Keymap | Action |
|--------|--------|
| `<leader>gl` | Show diagnostic under the cursor (float) |
| `<leader>gn` / `<leader>gp` | Next / previous diagnostic |
| `<leader>de` | Project diagnostics list (Telescope, Errors filter) |

---

## 3. Formatting (Spotless / ktfmt)

**`<leader>F`** — formats the current file with the **repo's own Spotless**
(`./gradlew spotlessApply` on that file).

Why this and not a generic formatter: core-monolith uses Spotless + ktfmt with
`maxWidth 140`, configured via Gradle. The ktfmt CLI can't replicate that width
(it's hardcoded to 100), so an external formatter would produce diffs that fight
`spotlessCheck` in CI. `<leader>F` uses the repo's Gradle → the result is
identical to what CI expects.

Notes:
- Saves the file, runs `spotlessApply` scoped to that file, and reloads it.
- **Only works in repos with Spotless** (core-monolith yes; payments-service has
  no Spotless configured → it tells you "no spotlessApply task").
- The first run starts a Gradle daemon (a few seconds); subsequent runs are fast.
- `<leader>gf` is the LSP's native format — for Kotlin prefer `<leader>F`
  (respects the repo's style).

---

## 4. Debugging (DAP)

The main flow in Spring Boot is **attach to the running app** (not launch from
nvim). The attach config is already set up: `127.0.0.1:5005`.

### Step by step: debugging a Spring Boot app

1. **Start the app with debug open** in a terminal (outside nvim):
   ```
   cd core-monolith/code
   ./gradlew bootRun --debug-jvm
   ```
   That opens debug port **5005** and the app waits until you connect.

2. **In nvim**, open a `.kt` from the project (so jdtls attaches) and set
   breakpoints wherever you want: `<leader>bb`.

3. **Connect:** `<leader>ds` → pick **"Attach to Kotlin (Spring Boot)"**.
   (or `<leader>dc` to continue/start the last session).

4. When the code hits a breakpoint, the **DAP UI** opens
   (scopes/stacks/watches on the left, repl/console at the bottom).

### Breakpoints

| Keymap | Action |
|--------|--------|
| `<leader>bb` | Toggle breakpoint |
| `<leader>bc` | Conditional breakpoint (prompts for the condition) |
| `<leader>bl` | Logpoint (logs a message instead of stopping) |
| `<leader>br` | Clear all breakpoints |
| `<leader>ba` | List breakpoints (Telescope) |

### Execution control

| Keymap | Action |
|--------|--------|
| `<leader>dc` | Continue (or start session) |
| `<leader>dj` | Step over |
| `<leader>dk` | Step into |
| `<leader>do` | Step out |
| `<leader>dl` | Re-run last config |
| `<leader>dt` | Terminate session + close UI |
| `<leader>dd` | Disconnect + close UI |

### Inspection while debugging

| Keymap | Action |
|--------|--------|
| `<leader>di` | Hover the value under the cursor |
| `<leader>d?` | Float with the scopes (local variables) |
| `<leader>dr` | Toggle REPL (evaluate expressions) |
| `<leader>df` | View stack frames (Telescope) |

### F keys (alternative to the `<leader>d*` maps)

`<F10>` step over · `<F11>` step into · `<F12>` step out · `<leader>p` continue

> `<leader>dy` (`JdtUpdateDebugConfig`) refreshes the debug configs (main classes,
> Spring Boot) if jdtls didn't detect them — useful after big changes.

---

## 5. Autocompletion (nvim-cmp)

While typing:

| Keymap | Action |
|--------|--------|
| `<C-Space>` | Force suggestions |
| `<C-j>` / `<C-k>` | Next / previous suggestion |
| `<CR>` (Enter) | Confirm |
| `<C-b>` / `<C-f>` | Scroll the popup's docs |

Sources: LSP, snippets (LuaSnip), buffer, paths. In `application.properties` the
Spring property completion is provided by the spring-boot LS.

---

## 6. Search and files (fzf-lua)

| Keymap | Action |
|--------|--------|
| `<C-p>` | Find files |
| `<C-y>` | Fuzzy grep (ripgrep, includes hidden/no-ignore) |
| `<C-b>` | Open buffers |
| `<C-g>` | Git-modified files |
| `<C-k>` | Search through keymaps (great for discovering shortcuts!) |
| `<C-h>` | Search the help |

File explorer (nvim-tree): `<leader>ee` toggle · `<leader>ef` reveal the current
file.

Harpoon (bookmark frequent files): `<leader>ha` add · `<leader>hh` menu ·
`<leader>h1`…`h9` jump to file N.

---

## 7. Typical workflow

**Edit + navigate:**
`<C-p>` open a file → `<leader>gd` jump to definitions → `<leader>gr` check usages
→ `<leader>ga` apply quick fixes → `<leader>F` format before committing.

**Debug an endpoint:**
`./gradlew bootRun --debug-jvm` in a terminal → in nvim `<leader>bb` on the handler
→ `<leader>ds` → "Attach to Kotlin (Spring Boot)" → hit the endpoint → inspect with
`<leader>d?` and step with `<leader>dj`/`dk`.

**Edit Spring config:**
open `application.properties` (with jdtls already indexed) → `<C-Space>` to see
available properties → hover `<leader>gg` for each one's docs.

---

## 8. Git & Diffview

### Diffview — reviewing diffs and resolving conflicts

Diffview opens a side-by-side view with a file panel. It's opened by command
(no dedicated `<leader>` keymap):

| Command | What for |
|---------|----------|
| `:DiffviewOpen` | Diff of the working tree vs HEAD (uncommitted changes) |
| `:DiffviewOpen main` | Diff of your branch vs `main` (everything you changed in the feature) |
| `:DiffviewOpen HEAD~3` | Diff vs 3 commits back |
| `:DiffviewOpen <a>..<b>` | Diff between two refs/commits |
| `:DiffviewClose` | Close the view |
| `:DiffviewFileHistory` | Commit history of the **repo** |
| `:DiffviewFileHistory %` | History of the **current file** (change by change) |

**Inside the view** (diffview's default keymaps):

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous file in the diff |
| `<CR>` or `o` | Open the selected file in the panel |
| `-` | Stage / unstage the file (toggle) |
| `S` / `U` | Stage all / unstage all |
| `X` | Discard the file's changes (restore) |
| `g?` | **Help** — lists ALL of diffview's keymaps |
| `<leader>e` / `<leader>b` | Focus / toggle the file panel |

> Folds come expanded (foldlevel 99) via config, so you see the full diff without
> having to open folds by hand.

**Resolving merge conflicts:** `:DiffviewOpen` during a conflicting merge shows
the conflicted files. Combine them with the standard diff keymaps (section below):
`<leader>cj` takes the local version, `<leader>ck` the remote one.

### Gitsigns — inline changes (hunks)

Shows in the left column which lines changed. Keymaps (buffer-local):

| Keymap | Action |
|--------|--------|
| `]c` / `[c` | Next / previous hunk |
| `<leader>hp` | Preview the hunk (what changed) |
| `<leader>hs` | Stage the hunk |
| `<leader>hu` | Reset the hunk (discard) |

### Git blame & browse

| Keymap | Action |
|--------|--------|
| `<leader>gb` | Toggle inline git blame (author/commit per line) |
| `<leader>gbo` | Open the line/file on GitHub (`:GBrowse`, via rhubarb) |

### Fugitive (`:Git` command)

Full git interface. Examples: `:Git status`, `:Git blame`, `:Git log`,
`:Git commit`. Loads lazily on the first `:Git`.

### Diff/merge keymaps (when in a `:diffsplit` or 3-way merge)

| Keymap | Action |
|--------|--------|
| `<leader>cc` | `:diffput` — send the current hunk to the other side |
| `<leader>cj` | `:diffget` from the **local** side (left) |
| `<leader>ck` | `:diffget` from the **remote** side (right) |
| `<leader>cn` / `<leader>cp` | Next / previous change (`]c` / `[c`) |

### Typical pre-PR review flow

`:DiffviewOpen main` → walk the files with `<Tab>` → review each diff →
`<leader>F` if something needs formatting → `:DiffviewClose` → commit with `:Git commit`.

---

## 9. Troubleshooting

**"Kotlin completion/navigation suddenly stopped working"**
JetBrains' `kotlin-lsp` is a preview build **with an expiry date**, so this will
happen again every so often. Fix:
```
brew upgrade jetbrains/utils/kotlin-lsp
```
Reopen nvim afterward.

**"No completion in application.properties"**
The spring-boot LS needs jdtls to have indexed first. Open a `.kt` from the
project, wait for "ServiceReady", and only then the `.properties`. Check the
attached clients with `:lua =vim.lsp.get_clients()` (you should see `jdtls` and
`spring-boot`).

**"Debug won't connect / doesn't stop at breakpoints"**
- Did you start the app with `--debug-jvm`? Is port 5005 free?
- Did you open a `.kt` from the project so jdtls is attached? The debug adapter
  lives inside jdtls — no jdtls, no debug.
- Try `<leader>dy` to refresh the debug configs.

**"I want to see what an LSP is doing / check errors"**
Log: `~/.local/state/nvim/lsp.log`. Plugin status: `:Lazy`. Tool status: `:Mason`.

**See all keymaps**: `<C-k>` (fzf keymaps) or `<Space>` + wait (which-key).
