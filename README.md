# Dotfiles

Dotfiles gestionados con symlinks, un solo source of truth para configs de Neovim, tmux, terminales y más.

## Setup

```bash
git clone git@github.com:LubeckHuaman/exp-dotfiles.git ~/Concepts/exp-dotfiles
cd ~/Concepts/exp-dotfiles
bash setup.sh
```

El script crea todos los symlinks e instala plugins de tmux.

## Componentes

### Neovim

Basado en Kickstart.nvim. Plugins destacados:

- **Themery**: selector de temas con live preview (~40 temas, dark y light)
- **agentic.nvim** + **codecompanion.nvim**: asistentes AI vía OpenCode
- **blink.cmp**: autocompletado
- **nvim-dap**: debugging para Go, Java, C/C++
- **toggleterm.nvim**: terminal integrada

Lenguajes: Go, Java (Spring Boot + jdtls), C/C++, Python, TypeScript.

### Tmux

- Prefix: `C-a`
- Split vertical: `cmd+d` / `|`
- Split horizontal: `cmd+shift+d` / `"`
- Tema: tmux-gruvbox (dark256, sin emojis)
- TPM plugins: sensible, yank, resurrect, continuum, filter
- Navegación y splits con `M-h/j/k/l`

### Ghostty

- Opacidad: 0.96
- Fuente: JetBrainsMono Nerd Font 13
- Paleta custom (basada en Gruvbox), misma que Alacritty y Kitty
- `font-thicken = true`
- Shader: blackhole
- `cmd+d` / `cmd+shift+d` enviados a tmux para splits

### Kitty / Alacritty

- Misma paleta, opacidad (0.85) y fuente que Ghostty
- Configs symlinkeadas al repo

### Rectangle

- Config de ventanas exportada a `config.json`

## Theme Management

Usando `themery.nvim` en Neovim con `:Themery`. Todos los temas oscuros usan `transparent = true`, los claros `transparent = false`. Las terminales comparten la misma paleta de colores para consistencia.

## Keyboard Shortcuts (Neovim)

| Shortcut | Action |
|----------|--------|
| `<leader>r` | Run current file/project |
| `<leader>f` | Format buffer |
| `<leader>sf` | Find files |
| `<leader>sg` | Live grep |
| `<leader>aa` | Toggle Agentic chat |
| `<leader>ca` | Toggle CodeCompanion chat |
| `<leader>ci` | Inline assistant |
| `<C-\>` | Toggle terminal |
| `grd` | Go to definition |
| `grr` | Go to references |
| `<leader>db` | Toggle breakpoint |

## Recarga

| App | Comando |
|-----|---------|
| Ghostty | Cmd+Q (restart) |
| Tmux | `C-a r` |
| Neovim | `:Lazy sync` |
| Kitty | Restart |
| Alacritty | Restart |
