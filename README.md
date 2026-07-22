# dotfiles-cli

My terminal setup: tmux, vim, Neovim, shell aliases, and a git/Kubernetes
toolchain, kept in sync across every laptop I use. Catppuccin (Mocha)
everywhere, `Ctrl-Space` as the tmux prefix, `Space` as the vim/nvim leader,
and Biome wired up to format JS/TS/JSON on save.

## What's in here

```
dotfiles-cli/
├── setup.sh        # installs packages, plugin managers, and symlinks everything
├── tmux/
│   └── tmux.conf    # tmux config (Catppuccin status bar, TPM plugins)
├── vim/
│   └── vimrc        # plain vim/MacVim config (CtrlP, NERDTree, ALE+Biome)
├── nvim/
│   ├── init.lua      # Neovim config (Telescope, nvim-tree, LSP, Biome)
│   └── lua/
├── shell/
│   └── aliases       # shared zsh/bash aliases and functions
├── git/
│   └── config        # delta (diffs) + merge/diff settings, included from ~/.gitconfig
├── lazygit/
│   └── config.yml     # Catppuccin theme + delta pager
├── bat/
│   ├── config          # Catppuccin syntax theme
│   └── themes/
└── k9s/
    ├── config.yaml      # Catppuccin skin
    └── skins/
```

`vim` and `nvim` are two independent configs — same keybinding philosophy
(leader = Space, same theme), different plugins under the hood. See
[CHEATSHEET.md](CHEATSHEET.md) for which keys do what in each, and
[GIT.md](GIT.md) for the full git/lazygit workflow.

## Install on a new machine

```bash
git clone git@github.com:youssoufhcherif/dotfiles-cli.git ~/dotfiles-cli
cd ~/dotfiles-cli
./setup.sh
```

The script installs the required packages (tmux, vim, a current Neovim,
ripgrep, fd, biome, lazygit, delta, fzf, zoxide, eza, bat, k9s — via
Homebrew on both macOS and Linux/WSL, installing Homebrew itself on Linux
if it's missing), installs the plugin managers (TPM, vim-plug, lazy.nvim),
and symlinks `~/.tmux.conf`, `~/.vimrc`, `~/.config/nvim`, `~/.aliases`,
`~/.config/lazygit`, `~/.config/bat`, and `~/.config/k9s` into this repo
(adding a `source ~/.aliases` line to `~/.zshrc`/`~/.bashrc`, and a
`[include]` pointing at `git/config` in `~/.gitconfig`, if not already
there). It's safe to re-run — anything that isn't already a symlink into
this repo gets backed up once to `~/.dotfiles-backup-<timestamp>/` before
being replaced.

Works on macOS (Homebrew) and Ubuntu/WSL (apt). See
[HOWTO.md](HOWTO.md) for platform-specific gotchas (fonts, clipboard, etc).

## Keeping it in sync

Because the live config files are symlinks into this repo, editing
`~/.vimrc`, anything under `~/.config/nvim`, or `~/.aliases` edits the file
*in this repo* — `cd ~/dotfiles-cli && git status` will show it. Commit and
push from there, then `git pull` on your other machines to pick up the
change.

## Cheatsheet

Every keybinding and shell alias, per tool, lives in
[CHEATSHEET.md](CHEATSHEET.md). Install steps and plugin lists are in
[HOWTO.md](HOWTO.md).

## License

MIT — take whatever's useful.
