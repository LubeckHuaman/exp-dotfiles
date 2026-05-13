# Mi Configuración de Neovim

## Resumen
Configuración personalizada de Neovim basada en **Kickstart.nvim**, optimizada para desarrollo en **Go, Java (Spring Boot), C++ y Python**.

---

## Características Principales

### 1. Indentación por Lenguaje
| Lenguaje | Estilo | Detalle |
|----------|--------|---------|
| **Default** | 4 spaces | Para configs, scripts, etc. |
| **Java** | 2 spaces | Sigue Google Java Style Guide |
| **C/C++** | 2 spaces | Sigue Clang/LLVM style |
| **Go** | Tabs reales | Estándar oficial de `gofmt` |

### 2. Auto-Formateo al Guardar (`:w`)
| Lenguaje | Formatter |
|----------|-----------|
| **Lua** | `stylua` |
| **C/C++** | `clang-format` |
| **Go** | `gofumpt` |
| **Java** | `google-java-format` |

### 3. LSP (Autocompletado, Ir a Definición, Diagnósticos)
| Lenguaje | Servidor |
|----------|----------|
| **Go** | `gopls` |
| **Java** | `jdtls` (Eclipse JDT) |
| **C/C++** | `clangd` |
| **Python** | `pyright` |
| **TypeScript** | `ts_ls` |
| **Lua** | `lua_ls` |

### 4. Ejecutar Código (`<leader>r`)
Detecta automáticamente el tipo de proyecto y ejecuta:
- **Java**: `mvn spring-boot:run` (si detecta Spring Boot), `mvn compile && mvn exec:java`, o `javac/java`
- **Go**: `go run .` (desde la raíz del proyecto con `go.mod`)
- **C/C++**: `g++ -std=c++17` y ejecuta el binario
- **Python**: `python3`
- **Lua**: `lua`

### 5. Debugging (`nvim-dap`)
| Lenguaje | Debugger |
|----------|----------|
| **Go** | `delve` (dlv) |
| **C/C++** | `codelldb` |
| **Java** | `jdtls` (integrado) |

---

## Atajos de Teclado

### Generales
| Atajo | Acción |
|-------|--------|
| `<leader>sh` | Buscar en ayuda |
| `<leader>sf` | Buscar archivos |
| `<leader>sg` | Buscar texto (grep) |
| `<leader>/` | Buscar en buffer actual |
| `<leader>f` | Formatear buffer manualmente |
| `<C-\>` | Abrir/cerrar terminal |
| `\` | Toggle Neo-tree (explorador de archivos) |

### Neo-tree (Explorador de Archivos)
| Atajo | Acción |
|-------|--------|
| `\` | Abrir/cerrar sidebar |
| `h` | Colapsar directorio |
| `l` | Expandir directorio / Abrir archivo |
| `a` | Crear archivo/directorio |
| `d` | Eliminar archivo/directorio |
| `r` | Renombrar archivo/directorio |
| `y` | Copiar ruta al clipboard |
| `c` | Copiar archivo/directorio |
| `x` | Cortar archivo/directorio |
| `p` | Pegar (copiar/mover) |
| `.` | Mostrar/ocultar archivos ocultos |
| `H` | Mostrar/ocultar archivos ignorados (.gitignore) |
| `s` | Abrir con el sistema |
| `o` | Abrir con la app del sistema |
| `i` | Toggle git status |
| `g` | Toggle git ignore |
| `f` | Filtrar archivos |
| `m` | Toggle buffer source |
| `[` / `]` | Navegar al archivo anterior/siguiente |
| `<CR>` | Abrir archivo |
| `<C-v>` | Abrir en split vertical |
| `<C-x>` | Abrir en split horizontal |
| `<C-t>` | Abrir en nueva tab |

### Ejecutar Código
| Atajo | Acción |
|-------|--------|
| `<leader>r` | Ejecutar archivo/proyecto actual |

### Debugging
| Atajo | Acción |
|-------|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue (reanudar) |
| `<leader>dn` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dt` | Toggle UI de debugging |

### Navegación LSP
| Atajo | Acción |
|-------|--------|
| `grd` | Ir a definición |
| `grr` | Ir a referencias |
| `gri` | Ir a implementación |
| `grn` | Renombrar símbolo |
| `gra` | Código acción (quick fix) |
| `<leader>th` | Toggle inlay hints |

### Agentic.nvim (AI Chat con OpenCode)
| Atajo | Acción |
|-------|--------|
| `<leader>aa` | Toggle Chat sidebar |
| `<leader>ac` | Agregar archivo/selección al contexto |
| `<leader>an` | Nueva sesión |
| `<leader>ar` | Restaurar sesión anterior |

**Dentro del Chat:**
| Tecla | Acción |
|-------|--------|
| `<CR>` / `<C-s>` | Enviar mensaje |
| `q` | Cerrar chat |
| `<S-Tab>` | Cambiar modo de agente (si el proveedor lo soporta) |
| `<localLeader>s` | Cambiar proveedor ACP |
| `<localLeader>m` | Cambiar modelo |
| `]c` / `[c` | Navegar hunks en diff preview |
| `d` | Eliminar archivo/selección del contexto |

**Flujo de uso:**
1. Abrí el chat con `<leader>aa`
2. Escribí tu instrucción y enviá con `<CR>`
3. Si el agente hace cambios, revisá el diff y aceptá/rechazá con las teclas numéricas (1, 2, 3...)
4. Agregá contexto con `<leader>ac` (archivo actual o selección visual)
5. Usá `@` en el prompt para buscar archivos del proyecto

**Seleccionar código y pedirle algo al LLM:**
1. Abrí el chat con `<leader>aa`
2. Volvé al archivo con `<C-w>h` (o el atajo que uses para cambiar de ventana)
3. Seleccioná el código con `V` (visual line) o `v` (visual character)
4. Presioná `<leader>ac` — el código seleccionado se agrega al contexto del chat
5. Volvé al chat (`<C-w>l`) y escribí tu instrucción (ej: "refactor this", "add error handling")
6. Enviá con `<CR>` — el agente trabajará sobre el código que seleccionaste

### CodeCompanion.nvim (AI Assistant Inline + Chat)
| Atajo | Acción |
|-------|--------|
| `<leader>ca` | Toggle Chat |
| `<leader>ci` | Inline Assistant (seleccioná código primero) |
| `<leader>cp` | Action Palette |

**Dentro del Chat:**
| Tecla | Acción |
|-------|--------|
| `<CR>` / `<C-s>` | Enviar mensaje |
| `q` | Cerrar chat |
| `ga` | Cambiar adapter/modelo |
| `gx` | Limpiar chat |
| `gm` | Enviar mensaje mientras el LLM está trabajando |
| `gd` | Debug window (ver mensajes/envío al LLM) |
| `gc` | Insertar bloque de código |
| `gr` | Regenerar última respuesta |
| `gy` | Copiar último bloque de código |
| `gba` | Sync buffer completo cada turno |
| `gbd` | Sync solo diff del buffer cada turno |

**Inline Assistant (estilo Cursor):**
1. Seleccioná código con `V` (visual line)
2. Presioná `<leader>ci`
3. Escribí tu instrucción (ej: "add error handling")
4. Aparece el diff → `gda` para aceptar, `gdr` para rechazar

**Action Palette (`<leader>cp`):**
- `/explain` - Explicar código seleccionado
- `/fix` - Corregir errores
- `/tests` - Generar tests
- `/refactor` - Refactorizar
- `/lsp` - Resolver errores del LSP

---

## Requisitos

### Java
- **Requiere Java 21+** para ejecutar `jdtls` (el servidor LSP de Java)
- Usa SDKMAN: `sdk install java 21.0.1-tem && sdk default java 21.0.1-tem`
- Tu proyecto puede compilar con Java 17, pero el servidor necesita 21+

### Herramientas Instaladas vía Mason
Al abrir Neovim por primera vez, Mason instalará automáticamente:
- `stylua`
- `clang-format`
- `codelldb`
- `gofumpt`
- `delve`
- `google-java-format`
- `jdtls`
- `java-debug-adapter`
- `java-test`

Si falta algo, ejecuta `:MasonInstall <nombre>` o abre `:Mason` y presiona `i` sobre el paquete.

---

## Estructura de Archivos
```
~/.config/nvim/
├── init.lua                          # Minimal - solo carga todo
├── lua/
│   ├── custom/
│   │   ├── options.lua               # Opciones de Vim (indent, clipboard, etc.)
│   │   ├── keymaps.lua               # Atajos generales
│   │   ├── lsp.lua                   # LSP servers, Mason, formatters
│   │   ├── dap.lua                   # Debugging (Go, C++, Java)
│   │   └── plugins/
│   │       ├── init.lua              # Todos los plugins y su config
│   │       └── leetcode.lua          # Plugin existente
│   └── kickstart/plugins/            # Plugins de Kickstart
└── README_ES.md                      # Este archivo
```

---

## Solución de Problemas

### Java no autocompleta
1. Verifica que tengas Java 21+ activo: `java -version`
2. Asegúrate de estar en un proyecto válido (con `pom.xml` o `build.gradle`)
3. Ejecuta `:LspInfo` y verifica que `jdtls` esté "running"
4. Si falla, ejecuta `:LspRestart`

### C++ no formatea al guardar
- Verifica que `clang-format` esté instalado: `:Mason`
- Si tienes un `.clang-format` en el proyecto, este tendrá prioridad sobre la config por defecto

### Go no debuggea
- Instala `delve` manualmente si Mason falla: `go install github.com/go-delve/delve/cmd/dlv@latest`
- Verifica que `dlv` esté en tu PATH: `which dlv`

### Error "formatter not available"
- Ejecuta `:ConformInfo` para ver el estado de los formatters
- Instala el que falte con `:MasonInstall <nombre>`

### Debugging Java "discovering main classes took too long"
- Compilá el proyecto primero: `mvn compile`
- Asegurate de que `java-debug-adapter` y `java-test` estén instalados vía `:Mason`

---

## Plugins Principales
- `lazy.nvim` - Gestor de plugins
- `nvim-lspconfig` - Configuración de LSP
- `blink.cmp` - Autocompletado
- `conform.nvim` - Formateo de código
- `toggleterm.nvim` - Terminal integrada
- `nvim-dap` + `nvim-dap-ui` - Debugging
- `telescope.nvim` - Búsqueda fuzzy
- `nvim-treesitter` - Syntax highlighting
- `gitsigns.nvim` - Integración con Git
- `which-key.nvim` - Ayuda de atajos
- `neo-tree.nvim` - Explorador de archivos
- `gruvbox.nvim` - Tema de colores (amigable para los ojos)
- `agentic.nvim` - Chat AI (ACP)
- `codecompanion.nvim` - Asistente de código AI
- `opencode.nvim` - Integración con OpenCode
