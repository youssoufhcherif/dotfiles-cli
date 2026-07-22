#!/usr/bin/env bash
# Bootstraps tmux/vim/nvim on a new machine from this repo.
# Safe to re-run: existing real files are backed up once, symlinks are left alone.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S 2>/dev/null || echo once)"

os() {
  case "$(uname -s)" in
    Darwin) echo "mac" ;;
    Linux) grep -qi microsoft /proc/version 2>/dev/null && echo "wsl" || echo "linux" ;;
    *) echo "unknown" ;;
  esac
}

OS="$(os)"
echo "==> Detected platform: $OS"

link() {
  local target="$1" link_path="$2"
  if [ -L "$link_path" ]; then
    if [ "$(readlink "$link_path")" = "$target" ]; then
      echo "==> $link_path already linked correctly, skipping"
      return
    fi
    echo "==> Replacing existing symlink at $link_path"
    rm "$link_path"
  elif [ -e "$link_path" ]; then
    mkdir -p "$BACKUP_DIR"
    echo "==> Backing up existing $link_path -> $BACKUP_DIR/"
    mv "$link_path" "$BACKUP_DIR/"
  fi
  mkdir -p "$(dirname "$link_path")"
  ln -s "$target" "$link_path"
  echo "==> Linked $link_path -> $target"
}

install_packages() {
  echo "==> Installing packages (tmux, vim, git, ripgrep, fd, biome)"
  case "$OS" in
    mac)
      command -v brew >/dev/null || { echo "Homebrew not found, install it first: https://brew.sh"; exit 1; }
      brew install tmux vim neovim git ripgrep fd biome
      ;;
    wsl|linux)
      sudo apt update
      sudo apt install -y tmux vim git ripgrep fd-find build-essential curl unzip
      command -v fd >/dev/null || { mkdir -p "$HOME/.local/bin"; ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"; }

      if ! command -v nvim >/dev/null || [ "$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1 | cut -d. -f2)" -lt 10 2>/dev/null ]; then
        echo "==> Installing current Neovim release to /opt/nvim (apt's version is usually too old)"
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        sudo mv /opt/nvim-linux-x86_64 /opt/nvim
        rm nvim-linux-x86_64.tar.gz
        for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
          [ -f "$rc" ] && ! grep -q "/opt/nvim/bin" "$rc" && echo 'export PATH="$PATH:/opt/nvim/bin"' >> "$rc"
        done
        export PATH="$PATH:/opt/nvim/bin"
      fi

      if ! command -v biome >/dev/null; then
        if command -v brew >/dev/null; then
          brew install biome
        elif command -v npm >/dev/null; then
          npm install -g @biomejs/biome
        else
          echo "==> Skipping biome install: no brew or npm found. Install manually: https://biomejs.dev/guides/getting-started/"
        fi
      fi

      if [ "$OS" = "wsl" ] && ! command -v win32yank.exe >/dev/null; then
        echo "==> Installing win32yank for WSL clipboard integration"
        curl -LO https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
        unzip -o win32yank-x64.zip
        chmod +x win32yank.exe
        sudo mv win32yank.exe /usr/local/bin/
        rm win32yank-x64.zip
      fi
      ;;
    *)
      echo "Unrecognized platform, install tmux/neovim/vim/ripgrep/fd/biome manually"
      ;;
  esac
}

link_configs() {
  echo "==> Linking config files"
  link "$REPO_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  link "$REPO_DIR/vim/vimrc" "$HOME/.vimrc"
  link "$REPO_DIR/nvim" "$HOME/.config/nvim"
}

install_plugin_managers() {
  echo "==> Installing TPM (tmux plugin manager)"
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
  "$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

  echo "==> Installing vim-plug (vim plugin manager)"
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim -es -u "$HOME/.vimrc" -c "PlugInstall --sync" -c "qa!" || true

  echo "==> Bootstrapping lazy.nvim and syncing nvim plugins (this can take a minute)"
  nvim --headless "+Lazy! sync" +qa || true
}

install_packages
link_configs
install_plugin_managers

echo
echo "==> Done. Open a new shell (for PATH changes), then:"
echo "    tmux              # prefix is Ctrl-Space"
echo "    vim / nvim        # leader is Space"
echo
echo "See README.md and HOWTO.md in this repo for keybindings and platform notes."
