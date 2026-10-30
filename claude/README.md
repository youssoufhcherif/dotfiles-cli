# Claude Code settings (opt-in, disabled by default)

`settings.json` is a copy of `~/.claude/settings.json`. It is **not** linked by
`setup.sh` unless you ask for it, because Claude Code is not part of the base
setup on every machine:

    DOTFILES_CLAUDE=1 ./setup.sh      # also links ~/.claude/settings.json

Install Claude Code itself separately (`npm install -g @anthropic-ai/claude-code`
or the native installer); the settings only take effect once it is installed.
