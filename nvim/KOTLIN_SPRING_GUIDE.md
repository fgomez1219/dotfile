# Kotlin + Spring Boot en Neovim — Guía de uso

Guía práctica para sacarle provecho a esta config trabajando en Kotlin/Spring
(core-monolith, payments-service). El **leader** es `<Espacio>`.

> Tip: esta config tiene **which-key**. Apretá `<Espacio>` y esperá — te muestra
> todos los grupos de atajos disponibles. Si te olvidás algo, mirá ahí primero.

---

## 1. Arquitectura (qué corre y para qué)

Al abrir un `.kt` en un proyecto Gradle, arrancan **dos** language servers, cada
uno con su rol:

| Server | Rol | Arranca cuando |
|--------|-----|----------------|
| **kotlin-lsp** (JetBrains) | Edición: completado, navegación, diagnostics, rename | abrís un `.kt` |
| **jdtls** (Eclipse JDT) | Debug (adapter java-debug) + info de proyecto para Spring | abrís un `.kt`/`.java` en proyecto con `gradlew` |
| **spring-boot** (VMware) | Completado/validación/hover en `application*.properties` y `@`-anotaciones | abrís `.kt`/`application*.properties` con jdtls ya arriba |

**Importante sobre timing:** jdtls tarda unos segundos en indexar el proyecto la
primera vez (vas a ver "Starting Java Language Server… ServiceReady"). El
completado de Spring en `application.properties` aparece **después** de que jdtls
termina de indexar. Paciencia en el primer archivo.

Root del proyecto: se ancla en el dir con `settings.gradle(.kts)`/`build.gradle`
(en estos repos, la carpeta `code/`), no en la raíz del repo.

---

## 2. Navegación de código (LSP)

Todos con prefijo `<leader>g` ("go"):

| Atajo | Acción |
|-------|--------|
| `<leader>gg` | Hover (doc/tipo bajo el cursor) |
| `<leader>gd` | Ir a definición |
| `<leader>gD` | Ir a declaración |
| `<leader>gi` | Ir a implementación |
| `<leader>gt` | Ir a definición de tipo |
| `<leader>gr` | Referencias |
| `<leader>gs` | Signature help (firma del método) |
| `<leader>ga` | **Code actions** (quick fixes, imports, etc.) |
| `<leader>rr` | Rename (símbolo en todo el proyecto) |
| `<leader>tr` | Símbolos del documento (outline) |

Diagnostics (errores/warnings):

| Atajo | Acción |
|-------|--------|
| `<leader>gl` | Mostrar diagnostic bajo el cursor (float) |
| `<leader>gn` / `<leader>gp` | Siguiente / anterior diagnostic |
| `<leader>de` | Lista de diagnostics del proyecto (Telescope, filtro Errores) |

---

## 3. Formato (Spotless / ktfmt)

**`<leader>F`** — formatea el archivo actual con el **Spotless del propio repo**
(`./gradlew spotlessApply` sobre ese archivo).

Por qué así y no un formatter genérico: core-monolith usa Spotless + ktfmt con
`maxWidth 140`, configurado vía Gradle. El CLI de ktfmt no puede replicar ese
ancho (queda fijo en 100), así que un formatter externo generaría diffs que
pelean con `spotlessCheck` en CI. `<leader>F` usa el Gradle del repo → el
resultado es idéntico a lo que espera CI.

Notas:
- Guarda el archivo, corre `spotlessApply` scopeado a ese archivo, y lo recarga.
- **Solo funciona en repos con Spotless** (core-monolith sí; payments-service
  no tiene Spotless configurado → te avisa "no spotlessApply task").
- La primera corrida arranca un Gradle daemon (unos segundos); las siguientes
  son rápidas.
- `<leader>gf` es el format nativo del LSP — para Kotlin preferí `<leader>F`
  (respeta el estilo del repo).

---

## 4. Debugging (DAP)

El flujo principal en Spring Boot es **attach a la app corriendo** (no launch
desde nvim). La config de attach ya está lista: `127.0.0.1:5005`.

### Paso a paso: debuggear una app Spring Boot

1. **Arrancá la app con debug abierto** en una terminal (fuera de nvim):
   ```
   cd core-monolith/code
   ./gradlew bootRun --debug-jvm
   ```
   Eso abre el puerto de debug **5005** y la app espera hasta que te conectes.

2. **En nvim**, abrí un `.kt` del proyecto (para que jdtls attache) y poné
   breakpoints donde quieras: `<leader>bb`.

3. **Conectate:** `<leader>ds` → elegí **"Attach to Kotlin (Spring Boot)"**.
   (o `<leader>dc` para continuar/empezar la última sesión).

4. Cuando el código pase por un breakpoint, se abre la **DAP UI**
   (scopes/stacks/watches a la izquierda, repl/console abajo).

### Breakpoints

| Atajo | Acción |
|-------|--------|
| `<leader>bb` | Toggle breakpoint |
| `<leader>bc` | Breakpoint condicional (te pide la condición) |
| `<leader>bl` | Logpoint (loguea un mensaje en vez de parar) |
| `<leader>br` | Limpiar todos los breakpoints |
| `<leader>ba` | Listar breakpoints (Telescope) |

### Control de ejecución

| Atajo | Acción |
|-------|--------|
| `<leader>dc` | Continue (o iniciar sesión) |
| `<leader>dj` | Step over |
| `<leader>dk` | Step into |
| `<leader>do` | Step out |
| `<leader>dl` | Re-run última config |
| `<leader>dt` | Terminar sesión + cerrar UI |
| `<leader>dd` | Disconnect + cerrar UI |

### Inspección durante el debug

| Atajo | Acción |
|-------|--------|
| `<leader>di` | Hover del valor bajo el cursor |
| `<leader>d?` | Float con los scopes (variables locales) |
| `<leader>dr` | Toggle REPL (evaluar expresiones) |
| `<leader>df` | Ver frames del stack (Telescope) |

### Teclas F (alternativa a los `<leader>d*`)

`<F10>` step over · `<F11>` step into · `<F12>` step out · `<leader>p` continue

> `<leader>dy` (`JdtUpdateDebugConfig`) refresca las configs de debug (main
> classes, Spring Boot) si jdtls no las detectó — útil tras cambios grandes.

---

## 5. Autocompletado (nvim-cmp)

Mientras escribís:

| Atajo | Acción |
|-------|--------|
| `<C-Space>` | Forzar sugerencias |
| `<C-j>` / `<C-k>` | Siguiente / anterior sugerencia |
| `<CR>` (Enter) | Confirmar |
| `<C-b>` / `<C-f>` | Scroll de la doc del popup |

Fuentes: LSP, snippets (LuaSnip), buffer, paths. En `application.properties` el
completado de propiedades Spring lo provee el spring-boot LS.

---

## 6. Búsqueda y archivos (fzf-lua)

| Atajo | Acción |
|-------|--------|
| `<C-p>` | Buscar archivos |
| `<C-y>` | Grep fuzzy (ripgrep, incluye hidden/no-ignore) |
| `<C-b>` | Buffers abiertos |
| `<C-g>` | Archivos modificados en git |
| `<C-k>` | Buscar entre keymaps (¡útil para descubrir atajos!) |
| `<C-h>` | Buscar en la ayuda |

Explorador de archivos (nvim-tree): `<leader>ee` toggle · `<leader>ef` revelar
el archivo actual.

Harpoon (marcar archivos frecuentes): `<leader>ha` agregar · `<leader>hh` menú ·
`<leader>h1`…`h9` saltar al archivo N.

---

## 7. Flujo típico de trabajo

**Editar + navegar:**
`<C-p>` abrí un archivo → `<leader>gd` saltá a definiciones → `<leader>gr` mirá
usos → `<leader>ga` aplicá quick fixes → `<leader>F` formateá antes de commitear.

**Debuggear un endpoint:**
`./gradlew bootRun --debug-jvm` en terminal → en nvim `<leader>bb` en el handler
→ `<leader>ds` → "Attach to Kotlin (Spring Boot)" → pegale al endpoint → inspeccioná
con `<leader>d?` y steppeá con `<leader>dj`/`dk`.

**Tocar config de Spring:**
abrí `application.properties` (con jdtls ya indexado) → `<C-Space>` para ver
propiedades disponibles → hover `<leader>gg` para la doc de cada una.

---

## 8. Git & Diffview

### Diffview — revisar diffs y resolver conflictos

Diffview abre una vista lado-a-lado con panel de archivos. Se abre por comando
(no tiene atajo `<leader>` propio):

| Comando | Para qué |
|---------|----------|
| `:DiffviewOpen` | Diff del working tree vs HEAD (cambios sin commitear) |
| `:DiffviewOpen main` | Diff de tu rama vs `main` (todo lo que cambiaste en la feature) |
| `:DiffviewOpen HEAD~3` | Diff vs 3 commits atrás |
| `:DiffviewOpen <a>..<b>` | Diff entre dos refs/commits |
| `:DiffviewClose` | Cerrar la vista |
| `:DiffviewFileHistory` | Historial de commits del **repo** |
| `:DiffviewFileHistory %` | Historial del **archivo actual** (línea por línea de cambios) |

**Dentro de la vista** (keymaps por defecto de diffview):

| Tecla | Acción |
|-------|--------|
| `<Tab>` / `<S-Tab>` | Siguiente / anterior archivo del diff |
| `<CR>` o `o` | Abrir el archivo seleccionado en el panel |
| `-` | Stage / unstage el archivo (toggle) |
| `S` / `U` | Stage all / unstage all |
| `X` | Descartar cambios del archivo (restore) |
| `g?` | **Ayuda** — lista TODOS los atajos de diffview |
| `<leader>e` / `<leader>b` | Focus / toggle del panel de archivos |

> Los folds vienen expandidos (foldlevel 99) por config, así ves el diff completo
> sin tener que abrir folds a mano.

**Resolver conflictos de merge:** `:DiffviewOpen` durante un merge conflictivo
muestra los archivos en conflicto. Se combinan con los atajos de diff estándar
(sección abajo): `<leader>cj` toma la versión local, `<leader>ck` la remota.

### Gitsigns — cambios inline (hunks)

Muestra en la columna izquierda qué líneas cambiaron. Atajos (buffer-local):

| Atajo | Acción |
|-------|--------|
| `]c` / `[c` | Siguiente / anterior hunk |
| `<leader>hp` | Preview del hunk (qué cambió) |
| `<leader>hs` | Stage del hunk |
| `<leader>hu` | Reset del hunk (descartar) |

### Git blame & browse

| Atajo | Acción |
|-------|--------|
| `<leader>gb` | Toggle git blame inline (autor/commit de cada línea) |
| `<leader>gbo` | Abrir la línea/archivo en GitHub (`:GBrowse`, vía rhubarb) |

### Fugitive (comando `:Git`)

Interfaz completa de git. Ejemplos: `:Git status`, `:Git blame`, `:Git log`,
`:Git commit`. Se carga lazy al primer `:Git`.

### Diff/merge keymaps (cuando estás en un `:diffsplit` o merge de 3 vías)

| Atajo | Acción |
|-------|--------|
| `<leader>cc` | `:diffput` — mandar el hunk actual al otro lado |
| `<leader>cj` | `:diffget` del lado **local** (izquierda) |
| `<leader>ck` | `:diffget` del lado **remoto** (derecha) |
| `<leader>cn` / `<leader>cp` | Siguiente / anterior cambio (`]c` / `[c`) |

### Flujo típico de review antes de un PR

`:DiffviewOpen main` → recorré los archivos con `<Tab>` → revisá cada diff →
`<leader>F` si algo necesita formato → `:DiffviewClose` → commit con `:Git commit`.

---

## 9. Troubleshooting

**"El completado/navegación de Kotlin dejó de andar de golpe"**
El `kotlin-lsp` de JetBrains es un build preview **con fecha de caducidad**, así
que esto va a volver a pasar cada tanto. Fix:
```
brew upgrade jetbrains/utils/kotlin-lsp
```
Reabrí nvim después.

**"No hay completado en application.properties"**
El spring-boot LS necesita que jdtls haya indexado primero. Abrí un `.kt` del
proyecto, esperá a "ServiceReady", y recién ahí el `.properties`. Verificá los
clientes attachados con `:lua =vim.lsp.get_clients()` (deberías ver
`jdtls` y `spring-boot`).

**"El debug no conecta / no para en breakpoints"**
- ¿Arrancaste la app con `--debug-jvm`? ¿Puerto 5005 libre?
- ¿Abriste un `.kt` del proyecto para que jdtls esté attachado? El adapter de
  debug vive dentro de jdtls — sin jdtls no hay debug.
- Probá `<leader>dy` para refrescar las configs de debug.

**"Quiero ver qué hace un LSP / revisar errores"**
Log: `~/.local/state/nvim/lsp.log`. Estado de plugins: `:Lazy`. Estado de
herramientas: `:Mason`.

**Ver todos los atajos**: `<C-k>` (fzf keymaps) o `<Espacio>` + esperar (which-key).
