# My Neovim Configuration

## Summary
Custom Neovim configuration based on **Kickstart.nvim**, optimized for development in **Go, Java (Spring Boot), C++ and Python**.

---

## Main Features

### 1. Language-Specific Indentation
| Language | Style | Detail |
|----------|-------|--------|
| **Default** | 4 spaces | For configs, scripts, etc. |
| **Java** | 2 spaces | Follows Google Java Style Guide |
| **C/C++** | 2 spaces | Follows Clang/LLVM style |
| **Go** | Real tabs | Official `gofmt` standard |

### 2. Auto-Format on Save (`:w`)
| Language | Formatter |
|----------|-----------|
| **Lua** | `stylua` |
| **C/C++** | `clang-format` |
| **Go** | `gofumpt` |
| **Java** | `google-java-format` |

### 3. LSP (Autocompletion, Go to Definition, Diagnostics)
| Language | Server |
|----------|--------|
| **Go** | `gopls` |
| **Java** | `jdtls` (Eclipse JDT) |
| **C/C++** | `clangd` |
| **Python** | `pyright` |
| **TypeScript** | `ts_ls` |
| **Lua** | `lua_ls` |

### 4. Run Code (`<leader>r`)
Automatically detects project type and runs:
- **Java**: `mvn spring-boot:run` (if Spring Boot detected), `mvn compile && mvn exec:java`, or `javac/java`
- **Go**: `go run .` (from project root with `go.mod`)
- **C/C++**: `g++ -std=c++17` and runs the binary
- **Python**: `python3`
- **Lua**: `lua`

### 5. Debugging (`nvim-dap`)
| Language | Debugger |
|----------|----------|
| **Go** | `delve` (dlv) |
| **C/C++** | `codelldb` |
| **Java** | `jdtls` (built-in) |

---

## Keyboard Shortcuts

### General
| Shortcut | Action |
|----------|--------|
| `<leader>sh` | Search help |
| `<leader>sf` | Find files |
| `<leader>sg` | Search text (grep) |
| `<leader>/` | Search in current buffer |
| `<leader>f` | Format buffer manually |
| `<C-\>` | Open/close terminal |
| `\` | Toggle Neo-tree (file explorer) |

### Neo-tree (File Explorer)
| Shortcut | Action |
|----------|--------|
| `\` | Open/close sidebar |
| `h` | Collapse directory |
| `l` | Expand directory / Open file |
| `a` | Create file/directory |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `y` | Copy path to clipboard |
| `c` | Copy file/directory |
| `x` | Cut file/directory |
| `p` | Paste (copy/move) |
| `.` | Show/hide hidden files |
| `H` | Show/hide ignored files (.gitignore) |
| `s` | Open with system |
| `o` | Open with system app |
| `i` | Toggle git status |
| `g` | Toggle git ignore |
| `f` | Filter files |
| `m` | Toggle buffer source |
| `[` / `]` | Navigate to previous/next file |
| `<CR>` | Open file |
| `<C-v>` | Open in vertical split |
| `<C-x>` | Open in horizontal split |
| `<C-t>` | Open in new tab |

### Run Code
| Shortcut | Action |
|----------|--------|
| `<leader>r` | Run current file/project |

### Debugging
| Shortcut | Action |
|----------|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>dn` | Step over |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dt` | Toggle debugging UI |

### LSP Navigation
| Shortcut | Action |
|----------|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<C-k>` | Signature help |
| `<leader>ca` | Code action (quick fix) |
| `<leader>rn` | Rename symbol |
| `<leader>th` | Toggle inlay hints |

### Agentic.nvim (AI Chat with OpenCode)
| Shortcut | Action |
|----------|--------|
| `<leader>aa` | Toggle Chat sidebar |
| `<leader>ac` | Add file/selection to context |
| `<leader>an` | New session |
| `<leader>ar` | Restore previous session |

**Inside the Chat:**
| Key | Action |
|-----|--------|
| `<CR>` / `<C-s>` | Send message |
| `q` | Close chat |
| `<S-Tab>` | Switch agent mode (if provider supports it) |
| `<localLeader>s` | Switch ACP provider |
| `<localLeader>m` | Switch model |
| `]c` / `[c` | Navigate hunks in diff preview |
| `d` | Remove file/selection from context |

**Usage flow:**
1. Open chat with `<leader>aa`
2. Type your instruction and send with `<CR>`
3. If the agent makes changes, review the diff and accept/reject with numeric keys (1, 2, 3...)
4. Add context with `<leader>ac` (current file or visual selection)
5. Use `@` in the prompt to search project files

**Select code and ask the LLM:**
1. Open chat with `<leader>aa`
2. Switch back to the file with `<C-w>h` (or your window switch shortcut)
3. Select code with `V` (visual line) or `v` (visual character)
4. Press `<leader>ac` — the selected code is added to the chat context
5. Switch back to chat (`<C-w>l`) and type your instruction (e.g. "refactor this", "add error handling")
6. Send with `<CR>` — the agent will work on the code you selected

### CodeCompanion.nvim (AI Assistant Inline + Chat)
| Shortcut | Action |
|----------|--------|
| `<leader>ca` | Toggle Chat |
| `<leader>ci` | Inline Assistant (select code first) |
| `<leader>cp` | Action Palette |

**Inside the Chat:**
| Key | Action |
|-----|--------|
| `<CR>` / `<C-s>` | Send message |
| `q` | Close chat |
| `ga` | Change adapter/model |
| `gx` | Clear chat |
| `gm` | Send message while LLM is working |
| `gd` | Debug window (view messages/sent to LLM) |
| `gc` | Insert code block |
| `gr` | Regenerate last response |
| `gy` | Yank last code block |
| `gba` | Sync full buffer every turn |
| `gbd` | Sync only buffer diff every turn |

**Inline Assistant (Cursor-style):**
1. Select code with `V` (visual line)
2. Press `<leader>ci`
3. Type your instruction (e.g. "add error handling")
4. Diff appears → `gda` to accept, `gdr` to reject

**Action Palette (`<leader>cp`):**
- `/explain` - Explain selected code
- `/fix` - Fix errors
- `/tests` - Generate tests
- `/refactor` - Refactor
- `/lsp` - Resolve LSP errors

---

## Requirements

### Java
- **Requires Java 21+** to run `jdtls` (the Java LSP server)
- Use SDKMAN: `sdk install java 21.0.1-tem && sdk default java 21.0.1-tem`
- Your project can compile with Java 17, but the server needs 21+

### Go
- **Requires Go 1.23+** for Delve debugger compatibility
- Install via Homebrew: `brew install go`
- **gopls**: installed automatically by Mason (Go LSP server)
- **gofumpt**: installed automatically by Mason (formatter)
- **delve**: installed automatically by Mason (debugger), or manually: `go install github.com/go-delve/delve/cmd/dlv@latest`
- Make sure `~/go/bin` is in your `PATH` for manually installed tools

### Tools Installed via Mason
When opening Neovim for the first time, Mason will automatically install:
- `stylua`
- `clang-format`
- `codelldb`
- `gofumpt`
- `delve`
- `google-java-format`
- `jdtls`
- `java-debug-adapter`
- `java-test`

If something is missing, run `:MasonInstall <name>` or open `:Mason` and press `i` on the package.

---

## File Structure
```
~/.config/nvim/
├── init.lua                          # Minimal - loads everything
├── lua/
│   ├── custom/
│   │   ├── options.lua               # Vim options (indent, clipboard, etc.)
│   │   ├── keymaps.lua               # General keymaps
│   │   ├── lsp.lua                   # LSP servers, Mason, formatters
│   │   ├── dap.lua                   # Debugging (Go, C++, Java)
│   │   └── plugins/
│   │       ├── init.lua              # All plugins and their config
│   │       └── leetcode.lua          # Existing plugin
│   └── kickstart/plugins/            # Kickstart plugins
└── README.md                         # This file
```

---

## Troubleshooting

### Java autocompletion not working
1. Verify you have Java 21+ active: `java -version`
2. Make sure you're in a valid project (with `pom.xml` or `build.gradle`)
3. Run `:LspInfo` and verify `jdtls` is "running"
4. If it fails, run `:LspRestart`

### C++ not formatting on save
- Verify `clang-format` is installed: `:Mason`
- If you have a `.clang-format` in the project, it will take priority over the default config

### Go debugging not working
- Install `delve` manually if Mason fails: `go install github.com/go-delve/delve/cmd/dlv@latest`
- Verify `dlv` is in your PATH: `which dlv`

### Error "formatter not available"
- Run `:ConformInfo` to check formatter status
- Install missing ones with `:MasonInstall <name>`

### Java debugging "discovering main classes took too long"
- Compile the project first: `mvn compile`
- Make sure `java-debug-adapter` and `java-test` are installed via `:Mason`

---

## Main Plugins
- `lazy.nvim` - Plugin manager
- `nvim-lspconfig` - LSP configuration
- `blink.cmp` - Autocompletion
- `conform.nvim` - Code formatting
- `toggleterm.nvim` - Integrated terminal
- `nvim-dap` + `nvim-dap-ui` - Debugging
- `telescope.nvim` - Fuzzy finder
- `nvim-treesitter` - Syntax highlighting
- `gitsigns.nvim` - Git integration
- `which-key.nvim` - Keymap help
- `neo-tree.nvim` - File explorer
- `gruvbox.nvim` - Color scheme (eye-friendly)
- `agentic.nvim` - AI chat interface (ACP)
- `codecompanion.nvim` - AI coding assistant
- `opencode.nvim` - OpenCode integration
