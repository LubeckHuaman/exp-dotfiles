#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Symlinks ==="

link_config() {
    local src="$REPO_DIR/.config/$1"
    local dest="$HOME/.config/$1"
    if [ -L "$dest" ]; then
        echo "  ✅ $dest (already linked)"
    elif [ -e "$dest" ]; then
        mv "$dest" "$dest.bak"
        echo "  📦 $dest → $dest.bak"
        ln -s "$src" "$dest"
        echo "  🔗 $dest → $src"
    else
        mkdir -p "$(dirname "$dest")"
        ln -s "$src" "$dest"
        echo "  🔗 $dest → $src"
    fi
}

link_config "nvim"
link_config "ghostty/config"
link_config "tmux/tmux.conf"
link_config "kitty/kitty.conf"
link_config "alacritty/alacritty.toml"
link_config "rectangle/config.json"

echo ""
echo "=== Tmux plugins ==="
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "  📦 Clonando TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
tmux start-server
tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.config/tmux/plugins/"
bash "$TPM_DIR/bin/install_plugins"

echo ""
echo "=== Done ==="
echo ""
echo "Recargá configs:"
echo "  Ghostty:   ctrl+shift+,"
echo "  Tmux:      prefix + r  (Ctrl+A, r)"
echo "  Kitty:     reiniciar"
echo "  Alacritty: reiniciar"
echo "  Neovim:    :Lazy sync"
