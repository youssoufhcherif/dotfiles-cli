# Brewfile — everything a fresh Mac needs for this setup.
#   brew bundle --file ~/dotfiles-cli/Brewfile       # install / update all
#   brew bundle cleanup --file ~/dotfiles-cli/Brewfile  # list what's installed but not listed here
# setup.sh runs the first command on macOS. Linux uses the apt + brew lists in setup.sh instead.

# --- shell & prompt --------------------------------------------------------
brew "starship"                 # prompt (starship/starship.toml)
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "mise"                     # node / pnpm / python / … version manager (replaces nvm)

# --- editors & terminal multiplexer ---------------------------------------
brew "neovim"
brew "vim"
brew "tmux"
brew "tree-sitter-cli"          # nvim treesitter grammars

# --- modern CLI basics -----------------------------------------------------
brew "bat"                      # cat with syntax highlighting (Catppuccin theme in bat/)
brew "eza"                      # ls replacement (le / lt aliases)
brew "fd"                       # find replacement
brew "fzf"                      # fuzzy finder (Ctrl-R / Ctrl-T)
brew "ripgrep"                  # grep replacement, used by telescope
brew "zoxide"                   # smarter cd (z)
brew "tree"
brew "wget"
brew "httpie"
brew "jq"
brew "poppler"                  # pdftotext & co

# --- git -------------------------------------------------------------------
brew "git"
brew "git-delta"                # diffs (git/config)
brew "git-lfs"                  # large files (muyassar datasets live in Forgejo LFS)
brew "git-filter-repo"
brew "gh"                       # GitHub CLI, also the credential helper
brew "lazygit"

# --- JS/TS toolchain -------------------------------------------------------
brew "biome"                    # formatter/linter used by vim (ALE) and nvim

# --- kubernetes & infra ----------------------------------------------------
brew "kubernetes-cli"
brew "helm"
brew "k9s"
# flux CLI lives in a third-party tap that newer Homebrew refuses to load from
# a Brewfile; install it by hand once:  brew tap fluxcd/tap && brew install fluxcd/tap/flux
brew "opentofu"
brew "awscli"
brew "sops"                     # needed to edit secrets.yaml in cluster-workloads (homelab GitOps)
brew "age"                      # key format used by sops + decrypts the homelab key escrow on the Pi

# --- apps (casks) ----------------------------------------------------------
cask "ghostty"
cask "font-jetbrains-mono-nerd-font"
cask "docker-desktop"
