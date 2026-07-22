# HOWTO

Detailed install steps and platform gotchas. For the quick overview, see
[README.md](README.md); for the full keybinding/alias reference, see
[CHEATSHEET.md](CHEATSHEET.md).

## Install

```bash
git clone git@github.com:youssoufhcherif/dotfiles-cli.git ~/dotfiles-cli
cd ~/dotfiles-cli
./setup.sh
```

`setup.sh` is idempotent — re-run it any time after pulling changes to pick
up newly required packages. It:

1. Installs tmux, vim, a current Neovim (0.10+), ripgrep, and fd via apt/the
   platform installer, plus biome, lazygit, delta, fzf, zoxide, eza, bat,
   and k9s via **Homebrew** on both macOS and Linux/WSL (these aren't in
   apt at all, or are old/quirky versions when they are). On Linux, if
   Homebrew itself isn't installed yet, `setup.sh` installs it first.
2. Symlinks `~/.tmux.conf`, `~/.vimrc`, `~/.config/nvim`, `~/.aliases`,
   `~/.config/lazygit`, `~/.config/bat`, and `~/.config/k9s` to the files in
   this repo, makes sure `~/.zshrc`/`~/.bashrc` source `~/.aliases`, and
   adds a `[include]` in `~/.gitconfig` pointing at this repo's
   `git/config` (delta + merge/diff settings — your `user.name`/
   `user.email` stay in `~/.gitconfig` itself, not versioned here).
   Anything already at those paths that *isn't* one of these symlinks gets
   moved to `~/.dotfiles-backup-<timestamp>/` first — nothing is silently
   overwritten.
3. Installs TPM (tmux), vim-plug (vim), and syncs lazy.nvim (nvim) plugins,
   and builds bat's theme cache (`bat cache --build`) so the Catppuccin
   syntax theme actually renders.

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

## What to tweak if something feels off

- **`ts_ls` sluggish on a big monorepo** → in `nvim/lua/plugins/lsp.lua`,
  swap `ts_ls` for `vtsls` in `ensure_installed` and in the
  `lspconfig.<name>.setup(...)` call.
- **Don't want the nvim debugger scaffolding** → delete
  `nvim/lua/plugins/dap.lua`, nothing else references it.
- **Different colorscheme** → swap `catppuccin/nvim` in
  `nvim/lua/plugins/ui.lua` (or `catppuccin/vim` in `vim/vimrc`) for
  anything else — same plugin-spec pattern either way.
- **`ll`/`le`/`lt` (eza) hanging or misbehaving** → in testing, `eza`
  reliably hung with zero output in automated/non-interactive shells here,
  regardless of flags or directory — `ls`, `bat`, `delta`, `fzf`, and
  `zoxide` were all fine in the same environment. Because of that, `ll` is
  deliberately still plain `ls -la`; eza is only exposed as `le`/`lt` in
  `shell/aliases`. Try those yourself in a real terminal — if solid, change
  `ll`'s alias definition there to `eza -la --icons --git`.
- **No git user.name/email after a fresh `setup.sh` run** → identity is
  deliberately not versioned in this public repo. Set it once per machine:
  `git config --global user.name "..."` and `--global user.email "..."`.

## Keeping configs versioned across laptops

Since `~/.tmux.conf`, `~/.vimrc`, `~/.config/nvim`, `~/.aliases`,
`~/.config/lazygit`, `~/.config/bat`, and `~/.config/k9s` are all symlinks
into this repo, day-to-day edits already land inside `~/dotfiles-cli`
(the exception is `~/.gitconfig` itself, which stays local on purpose —
only its `[include]` line points here):

```bash
cd ~/dotfiles-cli
git status         # see what changed
git add -A && git commit -m "..."
git push
```

On another machine, `git pull` picks the change up immediately — no
re-linking needed since the symlink target doesn't change, just its
contents.
