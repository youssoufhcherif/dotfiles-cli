# HOWTO

Detailed install steps, full keybinding reference, and platform gotchas.
For the quick version, see [README.md](README.md).

## Install

```bash
git clone git@github.com:youssoufhcherif/dotfiles-cli.git ~/dotfiles-cli
cd ~/dotfiles-cli
./setup.sh
```

`setup.sh` is idempotent — re-run it any time after pulling changes to pick
up newly required packages. It:

1. Installs tmux, vim, a current Neovim (0.10+), ripgrep, fd, and biome for
   your platform (Homebrew on macOS, apt + a manual Neovim release on
   Ubuntu/WSL).
2. Symlinks `~/.tmux.conf`, `~/.vimrc`, and `~/.config/nvim` to the files in
   this repo. Anything already at those paths that *isn't* one of these
   symlinks gets moved to `~/.dotfiles-backup-<timestamp>/` first — nothing
   is silently overwritten.
3. Installs TPM (tmux), vim-plug (vim), and syncs lazy.nvim (nvim) plugins.

### Platform notes

**macOS**: needs [Homebrew](https://brew.sh) installed first. You'll also
want a Nerd Font for the icons in nvim-tree/lualine/telescope/airline:

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

Point your terminal (Ghostty, iTerm, Terminal.app, whatever) at that font.

**Ubuntu/WSL**: apt's `neovim` package is usually too old (often <0.10),
so `setup.sh` downloads a current release straight from GitHub into
`/opt/nvim` and adds it to `PATH` in `~/.zshrc`/`~/.bashrc`. `fd` is
packaged as `fdfind` on Debian/Ubuntu — the script symlinks it to `fd` in
`~/.local/bin`.

On WSL specifically:
- **Clipboard**: `setup.sh` installs `win32yank` so `"+y`/`"+p` in nvim (and
  tmux-yank) bridge to the Windows clipboard. Neovim auto-detects it, no
  extra config needed.
- **Fonts**: installed on the *Windows* side, not inside Ubuntu — download
  a Nerd Font from [nerdfonts.com](https://www.nerdfonts.com/font-downloads),
  install it in Windows, then point Windows Terminal's Ubuntu profile at it
  (Settings → Appearance → Font face).
- **Filesystem**: keep project checkouts inside the Linux filesystem
  (`~/dev/...`), not under `/mnt/c/...` — WSL2's cross-filesystem access is
  slow enough to notice in nvim, git, and any JS package manager.
- `git config --global core.autocrlf input` — the Windows-oriented
  `autocrlf=true` default corrupts shebang lines (`bash\r`) in anything
  cloned from git on Linux, which breaks plugin scripts silently. Worth
  checking this is set correctly on any new WSL box before installing
  plugins.

### First launch

```bash
nvim
```

`lazy.nvim` bootstraps itself and installs every plugin on first run if
`setup.sh` didn't already sync them. Once done, run `:Mason` and confirm
`ts_ls` and `biome` show installed (`mason-lspconfig` auto-installs both,
worth eyeballing once). Restart nvim after the first install completes.

```bash
tmux
```

TPM plugins install automatically via `setup.sh`. Inside tmux, `prefix + I`
re-syncs plugins after editing `tmux/tmux.conf`, `prefix + U` updates them.

## Keybinding reference

Leader/prefix: **`Space`** in vim and nvim, **`Ctrl-Space`** in tmux.

### tmux (`tmux/tmux.conf`)

| Key | Action |
|---|---|
| `Ctrl-Space` | prefix |
| `prefix + \|` / `prefix + -` | split vertical / horizontal (opens in current path) |
| `prefix + h/j/k/l` | move between panes (vim-style) |
| `prefix + c` | new window (opens in current path) |
| `prefix + r` | reload `tmux.conf` |
| `prefix + F` | tmux-fzf menu (sessions/windows/panes) |
| `prefix + I` / `U` | install / update TPM plugins |

Plugins: tmux-sensible, tmux-resurrect + tmux-continuum (auto-save every 15
min, auto-restore on start), tmux-yank (system clipboard, win32yank-aware on
WSL), vim-tmux-navigator (`Ctrl-h/j/k/l` moves between vim splits *and* tmux
panes seamlessly), tmux-fzf, catppuccin/tmux (Mocha).

### vim / MacVim (`vim/vimrc`)

| Key | Action |
|---|---|
| `Ctrl-P` | fuzzy file finder (CtrlP) |
| `<leader>fr` | recent files (CtrlP MRU) |
| `<leader>b` | open-buffer switcher (CtrlP) |
| `<leader>f` | grep (prompts for pattern) |
| `<leader>1` | toggle file tree (NERDTree) |
| `<leader>2` | reveal current file in tree (NERDTreeFind) |
| `<leader>w` / `q` | save / quit |
| `<leader>v` / `h` | vertical / horizontal split |
| `Ctrl-h/j/k/l` | move between splits |
| save a file | Biome formats it automatically (ALE fixer) |

Plugins (vim-plug): vim-airline (+themes), CtrlP, catppuccin/vim, NERDTree
(+ nerdtree-git-plugin, vim-devicons), ALE (Biome fixer, `g:ale_fix_on_save`).

### Neovim (`nvim/`)

| Key | Action |
|---|---|
| `<leader>ff` | fuzzy file finder (Telescope) |
| `<leader>fg` | live grep across project |
| `<leader>b` | open buffers (Telescope) |
| `<leader>fr` | recent files (Telescope oldfiles) |
| `<leader>fs` | document symbols |
| `<leader>fd` | diagnostics list |
| `<leader>1` | toggle file tree (nvim-tree) |
| `<leader>2` | reveal current file in tree |
| `gd` / `gr` | go to definition / references |
| `K` | hover docs |
| `<leader>rn` | rename symbol |
| `<leader>ca` | code action |
| `[d` / `]d` | prev / next diagnostic |
| `<leader>e` | show diagnostic float |
| `<leader>mp` | format buffer with Biome (also runs automatically on save) |
| `<leader>db/dc/do/di` | debug: toggle breakpoint / continue / step over / step into |
| `<leader>w` / `q` | save / quit |
| `Ctrl-h/j/k/l` | move between splits |

**Telescope picker controls** (once `<leader>ff`/`fg`/`b`/etc. is open):
type to fuzzy-filter, `Ctrl-n`/`Ctrl-p` (or ↓/↑) to move, `Enter` to open,
`Ctrl-v`/`Ctrl-x`/`Ctrl-t` to open in a vertical/horizontal split or new tab,
`Ctrl-c` or `Esc` twice to close without opening anything.

**nvim-tree controls** (once the tree has focus): `Enter`/`o` open or
expand/collapse, `a` create (end name with `/` for a folder), `d`/`D`
delete/trash, `r` rename, `R` refresh, `H` toggle dotfiles, `y`/`Y`/`gy`
copy name/relative path/absolute path, `q` close.

Plugins (lazy.nvim): catppuccin (Mocha), lualine, telescope + plenary,
nvim-tree + web-devicons, gitsigns, nvim-lspconfig + mason + mason-lspconfig,
nvim-cmp + LuaSnip (+ cmp sources), conform.nvim (Biome), nvim-treesitter,
nvim-dap + dap-ui + dap-vscode-js (optional — delete `lua/plugins/dap.lua`
if you don't want it).

## What to tweak if something feels off

- **`ts_ls` sluggish on a big monorepo** → in `nvim/lua/plugins/lsp.lua`,
  swap `ts_ls` for `vtsls` in `ensure_installed` and in the
  `lspconfig.<name>.setup(...)` call.
- **Don't want the nvim debugger scaffolding** → delete
  `nvim/lua/plugins/dap.lua`, nothing else references it.
- **Different colorscheme** → swap `catppuccin/nvim` in
  `nvim/lua/plugins/ui.lua` (or `catppuccin/vim` in `vim/vimrc`) for
  anything else — same plugin-spec pattern either way.
- **fzf missing** (`tmux-fzf` plugin installed but no `prefix + F` menu) →
  `setup.sh` doesn't install `fzf` itself on Linux since it needs `apt`
  outside a passwordless sudo context on some machines; run
  `brew install fzf` (mac) or `sudo apt install fzf` (Ubuntu/WSL) manually.

## Keeping configs versioned across laptops

Since `~/.tmux.conf`, `~/.vimrc`, and `~/.config/nvim` are symlinks into
this repo, day-to-day edits already land inside `~/dotfiles-cli`:

```bash
cd ~/dotfiles-cli
git status         # see what changed
git add -A && git commit -m "..."
git push
```

On another machine, `git pull` picks the change up immediately — no
re-linking needed since the symlink target doesn't change, just its
contents.
