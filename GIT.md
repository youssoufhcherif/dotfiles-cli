# Git, from the ground up

WebStorm's Git tool window hides almost everything below. This doc is meant
to be read once top-to-bottom, then kept as a reference. It assumes nothing.

Every alias/function mentioned is already installed — see [CHEATSHEET.md](CHEATSHEET.md)
for the full list, or `~/dotfiles-cli/shell/aliases` for the source.

## 1. The mental model

Four things, and almost everything else is a variation on moving stuff
between them:

- **Working directory** — the files on disk, as you're editing them.
- **Staging area (the "index")** — a draft of what your *next* commit will
  contain. `git add` copies changes from the working directory here.
- **Commits** — permanent, immutable snapshots. Each one points at its
  parent commit(s), forming a chain — that chain is your history.
- **Branches** — just a movable label pointing at one commit. `main`,
  `feature/x`, whatever — they're all just pointers. `HEAD` is a pointer
  to *the branch you're currently on* (or, in "detached HEAD" state,
  directly to a commit).

**Remotes** (`origin`) are just other copies of this same graph of commits,
living on GitHub. `git fetch` downloads their commits without touching your
branches. `git pull` = fetch + merge (or rebase) into your current branch.
`git push` uploads your commits to update the remote's branch pointer.

WebStorm's Git tool window is a UI over exactly this graph — lazygit (see
§10) gives you the same picture in the terminal.

## 2. Daily flow

```bash
git status          # gs   — what's changed, what's staged
git add <file>       # or `git add .` for everything
git commit -m "msg"   # gc "msg"
git push             # gpo (push to origin, current branch)
git pull             # gp
git log --oneline --graph --decorate   # glog (oh-my-zsh alias)
```

`git status` is the command you run *constantly* — before add, before
commit, after checkout, whenever you're not sure what state you're in.
There's no such thing as checking it too often.

## 3. Branching

```bash
git branch                 # list local branches
git branch -a               # list local + remote branches
git checkout -b feature/x    # gco -b feature/x — create + switch
git checkout main            # gco main — switch
git branch -d feature/x      # delete (only if merged)
git branch -D feature/x      # delete (force, even if unmerged)
```

`gnb feature/x` (your function) does `checkout -b` **and** pushes it
upstream in one step — use it the moment you start a new piece of work, so
the branch exists on GitHub from commit one (useful for draft PRs).

`gbclean` (your function) deletes every local branch already merged into
main/master — run it after cleaning up merged PRs so `git branch` doesn't
accumulate cruft.

## 4. Merge vs rebase

Both answer "bring these two branches' changes together" — they just leave
different history behind.

- **Merge** (`git merge feature/x`, run from `main`) creates a new "merge
  commit" with two parents. History shows exactly what happened, including
  every side-branch, but the log gets noisy with merge commits.
- **Rebase** (`git rebase main`, run from `feature/x`) replays your
  branch's commits one by one on top of the latest `main`. History ends up
  linear — no merge commits — as if you'd branched off *today's* main all
  along.

**Rule of thumb**: rebase your own feature branch onto main before opening
a PR (clean, linear history, no surprise merge commits). Never rebase a
branch other people are also pulling from — rebase rewrites commit hashes,
so anyone else's copy of that branch diverges and gets confusing to
reconcile. Merge is what actually happens when a PR gets merged on GitHub
(or via `git merge` locally) — that part isn't a choice either way.

```bash
git checkout feature/x
git fetch origin
git rebase origin/main       # replay your commits on latest main
# if conflicts: fix files, `git add <file>`, then `git rebase --continue`
git push --force-with-lease   # rebase rewrote your commits, force-push is expected
```

`--force-with-lease` (not plain `--force`) refuses to push if someone else
pushed to that branch since you last fetched — it protects you from
overwriting work you haven't seen yet.

## 5. Interactive rebase — the biggest capability upgrade

This is the thing WebStorm barely exposes. `git rebase -i` lets you rewrite
your branch's commit history before anyone else sees it: squash three
"wip" commits into one, reorder commits, edit a commit message, or drop a
commit entirely.

```bash
git rebase -i HEAD~3    # rewrite the last 3 commits
# or:
git rebase -i main      # rewrite everything since branching off main
```

This opens your editor (nvim, per your config) with a list like:

```
pick a1b2c3d Add login form
pick e4f5g6h wip
pick i7j8k9l fix typo
```

Change `pick` to:
- `squash` (or `s`) — fold this commit into the one above it, combining
  their messages
- `reword` (or `r`) — keep the commit, but let you edit its message
- `drop` (or `d`) — remove the commit entirely
- reorder lines — commits replay top-to-bottom, so moving a line moves
  where it applies

A typical cleanup before opening a PR: turn "Add login form" / "wip" /
"fix typo" into one clean "Add login form" commit via
`pick` / `squash` / `squash`. Save and close — git replays the commits per
your instructions, then you're done. If a step conflicts, fix the file,
`git add`, `git rebase --continue` (same as regular rebase).

## 6. Undoing things safely — the "oh no" toolkit

The good news: it's very hard to actually lose work in git, even when it
feels like you have. Know these four:

**Uncommitted changes:**
```bash
git restore <file>          # discard uncommitted changes to a file
git restore --staged <file>  # unstage, but keep the changes in the file
```

**Last commit, not yet pushed:**
```bash
gundo                        # your function: git reset --soft HEAD~1
                              # undoes the commit, keeps changes staged
git commit --amend           # or: fix the commit in place (new message/content)
```
`reset --soft` moves the branch pointer back but leaves your files and the
staging area untouched — nothing is lost, you just get to re-commit
differently. (`--mixed`, the default, also un-stages; `--hard` discards the
changes entirely — that one **does** lose work, only use it when you
genuinely mean "throw this away.")

**Already pushed, need to undo publicly:**
```bash
git revert <commit>    # creates a NEW commit that undoes an old one
```
Use `revert`, not `reset`, on anything already pushed/shared — it adds to
history instead of rewriting it, so it's safe for branches others have.

**"I did something and now I'm not sure what state I'm in":**
```bash
git reflog
```
This is the actual safety net. It's a log of every place `HEAD` has
pointed recently — every commit, every reset, every rebase step — even
ones no longer reachable from any branch. If a rebase went wrong or you
deleted a branch you needed, `git reflog` almost always has the commit
hash you need; `git checkout <that-hash>` or `git branch recovered
<that-hash>` gets it back. This is the command that makes "I can't undo
this in git" almost never true.

## 7. Stash, diff, blame, cherry-pick, tags

```bash
git stash              # shelve uncommitted changes, working dir goes clean
git stash pop           # bring them back (and remove from the stash list)
git stash list          # see everything shelved
```
Use this when you need to switch branches but aren't ready to commit —
WebStorm's "Shelve Changes" is the same idea.

```bash
git diff                # unstaged changes (delta renders this — see CHEATSHEET.md)
git diff --staged        # staged changes, not yet committed
git diff main..feature/x  # everything feature/x has that main doesn't
git blame <file>          # who last touched each line, and in which commit
```

```bash
git cherry-pick <commit>   # apply one specific commit from another branch onto this one
```
Useful for "I need just that one fix from a branch I'm not ready to merge."

```bash
git tag v1.2.0            # tag the current commit
git tag -a v1.2.0 -m "..."  # annotated tag (preferred — has its own message/author)
git push origin v1.2.0     # tags don't push automatically, push explicitly
```

## 8. Bonus: `git worktree`

Checking out a different branch to review a PR normally means stashing
whatever you're mid-way through. `git worktree` instead checks out another
branch into a **separate folder**, sharing the same `.git` history — no
stashing needed:

```bash
git worktree add ../review-pr-42 origin/feature/x
cd ../review-pr-42     # a fully separate checkout, open it in a new nvim/tmux pane
# when done:
git worktree remove ../review-pr-42
```

Great for "review this PR" or "quickly check something on main" without
disturbing whatever's currently checked out in your main folder.

## 9. The actual daily flow, put together

```bash
gnb feature/add-login       # branch + push upstream, in one step
# ...edit, edit, edit...
gs                            # check status often
git add .
gc "Add login form"           # or several small commits as you go
# ...more edits...
qc "Fix validation edge case"   # add + commit + push in one step, for quick iterations

# before opening the PR: clean up history
git rebase -i main             # squash the "wip"/"fix typo" commits into one
git push --force-with-lease

gh pr create                   # open the PR (gh is already installed)
# ...review feedback, more commits, more `qc`...

# once merged on GitHub:
git checkout main
gp                              # gp = git pull
gbclean                          # delete the now-merged local branch
```

If a rebase or a commit ever goes sideways: `git status` first, `git reflog`
if you're truly lost. Nothing here is unrecoverable.

## 10. lazygit — the visual layer on top of all of this

Everything above works from lazygit too, without memorizing flags. Run
`lg` from inside any git repo. It's Catppuccin-themed and uses delta for
diffs. The core flow:

- **Files panel** (top-left): `space` stages/unstages a file, `a` stages
  all, `c` commits, `enter` on a file shows its diff and lets you stage
  individual **hunks** (or even individual lines) instead of the whole
  file — the one thing WebStorm's Git panel actually does well, and
  lazygit matches it.
- **Branches panel**: `n` new branch, `space` checkout, `M` merge selected
  branch into current, `r` starts an interactive rebase visually — pick
  which commits to squash/drop/reorder without hand-editing a rebase todo
  file.
- **Commits panel**: browse history, `enter` to see a commit's diff, `p`
  to cherry-pick it onto your current branch.
- **Stash panel**: `s` to stash from the files panel, apply/pop from here.
- `x` anywhere opens a menu of every keybinding available in that panel —
  the fastest way to discover what's possible without leaving the app.
