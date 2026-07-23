# Cheatsheet

Quick per-tool reference. For install steps and platform notes, see
[HOWTO.md](HOWTO.md). For the high-level overview, see [README.md](README.md).

Leader/prefix: **`Space`** in vim and nvim, **`Ctrl-Space`** in tmux.

## tmux (`tmux/tmux.conf`)

| Key | Action |
|---|---|
| `Ctrl-Space` | prefix |
| `prefix + \|` / `prefix + -` | split vertical / horizontal (opens in current path) |
| `prefix + h/j/k/l` | move between panes (vim-style) |
| `prefix + c` | new window (opens in current path) |
| `prefix + r` | reload `tmux.conf` |
| `prefix + F` | tmux-fzf menu (sessions/windows/panes) |
| `prefix + I` / `U` | install / update TPM plugins |

Plugins: tmux-sensible, tmux-resurrect + tmux-continuum (auto-save every 5
min, auto-restore on start), tmux-yank (system clipboard, win32yank-aware on
WSL), vim-tmux-navigator (`Ctrl-h/j/k/l` moves between vim splits *and* tmux
panes seamlessly), tmux-fzf, catppuccin/tmux (Mocha).

## vim / MacVim (`vim/vimrc`)

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

## Neovim (`nvim/`)

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
| `<leader>v` / `h` | vertical / horizontal split |
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

## Shell aliases (`shell/aliases`, symlinked to `~/.aliases`)

Sourced from both `~/.zshrc` and `~/.bashrc`. Git aliases are intentionally
sparse here — oh-my-zsh's `git` plugin already provides a large set
(`gst`, `gaa`, `gcam`, `glog`, `gd`, ...); the few redefined below
(`gs`, `gco`, `gc`, `gp`, `gpo`) override those specific names on purpose.

| Alias | Command |
|---|---|
| `vi` | `nvim` |
| `p` | `pnpm` |
| `pni` / `pnb` | `pnpm install` / `pnpm build` |
| `dev` / `test` | `pnpm run dev` / `pnpm test` |
| `gs` / `gco` / `gc` / `gp` / `gpo` | `git status` / `checkout` / `commit -m` / `pull` / `push origin` |
| `gnb <branch>` | create branch and push with upstream tracking (function) |
| `qc "<msg>"` | `git add .` + commit + push in one step (function) |
| `..` / `...` / `....` | up 1 / 2 / 3 directories |
| `mkcd <dir>` | `mkdir -p <dir> && cd <dir>` (function) |
| `killport <port>` | kill whatever's listening on a port (function) |
| `cl` / `ll` | `clear` / `ls -la` |
| `le` / `lt` | `eza -la --icons --git` / `eza --tree --icons --git-ignore` (only if `eza` installed — see caveat below) |
| `lg` | `lazygit` |
| `reload` | restart the current shell |
| `zconf` / `zsource` | open / re-source `~/.zshrc` |
| `pbcopy` / `pbpaste` | clipboard via `xclip` |
| `kdev` / `kacc` / `kprod` | switch kubectl context |
| `k` / `kgp` / `kgs` / `kaf` / `kl` | `kubectl` / get pods / get svc / apply -f / logs -f |
| `d` / `dc` / `dps` | `docker` / `docker compose` / `docker ps` |
| `dcu` / `dcd` / `dcl` | compose up -d / down / logs -f |
| `ta <name>` | attach to `<name>`, or create it if it doesn't exist yet |
| `tls` / `tn <name>` / `tk <name>` | list / new / kill session |
| `dotf` | `cd ~/dotfiles-cli` |
| `please` | re-run the last command with `sudo` |
| `gundo` | undo last commit, keep changes staged (function) |
| `gbclean` | delete local branches already merged into main/master (function) |
| `dsh <container>` | `docker exec -it <container> sh` (function) |
| `kexec <pod>` | `kubectl exec -it <pod> -- sh` (function) |
| `up [n]` | go up `n` directories, default 1 (function) |
| `extract <file>` | extract almost any archive (`.tar.gz`/`.zip`/`.rar`/...) (function) |
| `backup <file>` | copy to `file.bak-<timestamp>` (function) |
| `hist <term>` | grep shell history (function) |
| `myip` | show public + local IP (function) |

## Productivity tools

| Tool | Use it via | Does |
|---|---|---|
| **fzf** | `Ctrl-R` | fuzzy-search shell history |
| | `Ctrl-T` | fuzzy-insert a file path at the cursor (bat-previewed) |
| | `Alt-C` | fuzzy-cd into a subdirectory |
| **zoxide** | `z <partial-name>` | jump to your most-used matching directory, from anywhere |
| | `zi` | fzf-picker over all visited directories |
| **eza** | `le` / `lt` | modern `ls`/tree — see the caveat in [HOWTO.md](HOWTO.md) before relying on it |
| **bat** | `bat <file>` | `cat` with syntax highlighting (Catppuccin Mocha theme) |
| **delta** | automatic | any `git diff`/`git log -p`/`git show` renders side-by-side with syntax highlighting — no separate command, just wired in as git's pager |
| **k9s** | `k9s` | terminal UI for kubectl — browse pods/logs, `:ctx` to switch context, `d` describe, `l` logs, `s` shell into a pod, `Ctrl-d` delete, `/` filter, `:q` quit |
| **lazygit** | `lg` | terminal UI for git — full keybinding table and workflow in [GIT.md](GIT.md) |

New to the CLI git flow? Start with [GIT.md](GIT.md) — it's written as a
read-once tutorial, not just a lookup table.
