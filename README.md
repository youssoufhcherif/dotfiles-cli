# dotfiles-cli

My terminal setup: tmux, vim, and Neovim, kept in sync across every laptop I use.
Catppuccin (Mocha) everywhere, `Ctrl-Space` as the tmux prefix, `Space` as the
vim/nvim leader, and Biome wired up to format JS/TS/JSON on save.

## What's in here

```
dotfiles-cli/
├── setup.sh        # installs packages, plugin managers, and symlinks everything
├── tmux/
│   └── tmux.conf    # tmux config (Catppuccin status bar, TPM plugins)
├── vim/
│   └── vimrc        # plain vim/MacVim config (CtrlP, NERDTree, ALE+Biome)
└── nvim/
    ├── init.lua      # Neovim config (Telescope, nvim-tree, LSP, Biome)
    └── lua/
```

`vim` and `nvim` are two independent configs — same keybinding philosophy
(leader = Space, same theme), different plugins under the hood. See
[HOWTO.md](HOWTO.md) for which keys do what in each.

## Install on a new machine

```bash
git clone git@github.com:youssoufhcherif/dotfiles-cli.git ~/dotfiles-cli
cd ~/dotfiles-cli
./setup.sh
```

The script installs the required packages (tmux, vim, a current Neovim,
ripgrep, fd, biome), installs the plugin managers (TPM, vim-plug, lazy.nvim),
and symlinks `~/.tmux.conf`, `~/.vimrc`, and `~/.config/nvim` into this repo.
It's safe to re-run — anything that isn't already a symlink into this repo
gets backed up once to `~/.dotfiles-backup-<timestamp>/` before being
replaced.

Works on macOS (Homebrew) and Ubuntu/WSL (apt). See
[HOWTO.md](HOWTO.md) for platform-specific gotchas (fonts, clipboard, etc).

## Keeping it in sync

Because the live config files are symlinks into this repo, editing
`~/.vimrc` or anything under `~/.config/nvim` edits the file *in this repo* —
`cd ~/dotfiles-cli && git status` will show it. Commit and push from there,
then `git pull` on your other machines to pick up the change.

## Keybinding cheat sheet

| Action | tmux | vim | nvim |
|---|---|---|---|
| Prefix / leader | `Ctrl-Space` | `Space` | `Space` |
| Fuzzy find files | — | `Ctrl-P` | `<leader>ff` |
| Recent files | — | `<leader>fr` | `<leader>fr` |
| Buffer/tab switcher | — | `<leader>b` | `<leader>b` |
| Toggle file tree | — | `<leader>1` | `<leader>1` |
| Reveal file in tree | — | `<leader>2` | `<leader>2` |
| Format on save (Biome) | — | automatic (ALE) | automatic (conform.nvim) |
| Split panes | `prefix + \|` / `prefix + -` | `<leader>v` / `<leader>h` | `:vsplit` / `:split` |

Full details, plugin lists, and per-platform install notes are in
[HOWTO.md](HOWTO.md).

## License

MIT — take whatever's useful.
