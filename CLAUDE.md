# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Structure

Managed with GNU Stow. Each top-level directory is a "package" whose contents mirror `$HOME`; stowing a package symlinks its files into place.

- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `nvim/.config/nvim/` -> `~/.config/nvim/`
- `ssh/.ssh/config` -> `~/.ssh/config` (private keys stay untracked in `~/.ssh`, never in this repo)

## Applying configs (stow)

`.stowrc` sets `--target=$HOME` explicitly. Without it, stow defaults to the *parent* of the stow directory (here, `~/Projects`) as the target, which silently symlinks into the wrong place -- this bit us once already, see the fallout it left behind before `.stowrc` existed.

From the repo root, stow a package into `$HOME`:

```
stow tmux
stow nvim
stow ssh
```

Or all at once: `stow */`.

To remove the symlinks a package created: `stow -D <package>`.

Stow only symlinks an entire subdirectory (e.g. `~/.config/nvim`) if that directory doesn't already exist on the target machine; if it does, it descends and symlinks individual files instead. This matters for `ssh/.ssh/config`: `~/.ssh` already contains real key files, so stow will add just the `config` symlink alongside them rather than replacing the directory.

## Known TODOs

- `ssh/.ssh/config`: `HostName`/`User` are placeholders for the `dellg5` and `truenas` hosts.
- `ssh/.ssh/config`: `IdentityAgent` points at `~/.1password/agent.sock`, which requires a WSL2 bridge (npiperelay + socat, per 1Password's WSL docs) to actually reach the 1Password agent on the Windows host. Not yet set up.
