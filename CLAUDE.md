# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Structure

Managed with GNU Stow. Each top-level directory is a "package" whose contents mirror `$HOME`; stowing a package symlinks its files into place.

- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `nvim/.config/nvim/` -> `~/.config/nvim/`
- `ssh/.ssh/config` -> `~/.ssh/config` (private keys stay untracked in `~/.ssh`, never in this repo)
- `cosmic/.config/cosmic/` -> `~/.config/cosmic/` (COSMIC desktop; only actually-customized keys are tracked, see below)

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

### cosmic package caveat

Unlike the other packages, `~/.config/cosmic/<component>/v1/<key>` files already exist as real files (COSMIC writes them on first boot), so a plain `stow cosmic` will fail with "existing target is not owned by stow". Use `stow --adopt cosmic` once -- this pulls the live file into the repo (overwriting the repo copy with whatever is currently on disk) and replaces it with a symlink, then `git diff` to make sure nothing unexpected got adopted before committing.

## COSMIC package contents

COSMIC (`~/.config/cosmic/`) stores every setting as one file per key across dozens of component directories, most of which are stock defaults or large generated blobs (theme color palettes, builder state). Only settings actually changed via the GUI are tracked here, kept barebones on purpose:

- `com.system76.CosmicComp/v1/` -- `autotile`, `autotile_behavior`, `focus_follows_cursor`, `xkb_config` (keyboard layout/repeat rate)
- `com.system76.CosmicIdle/v1/` -- `screen_off_time`, `suspend_on_ac_time` (both disabled)
- `com.system76.CosmicTk/v1/` -- `header_size`, `interface_density` (both `Spacious`)
- `com.system76.CosmicAppList/v1/` -- `favorites`, `enable_drag_source`
- `com.system76.CosmicAppletTime/v1/` -- `military_time`, `first_day_of_week`
- `com.system76.CosmicPanel.Panel/v1/` and `com.system76.CosmicPanel.Dock/v1/` -- `anchor`, `size`, `autohide`
- `com.system76.CosmicSettings.Shortcuts/v1/custom` -- custom keybindings, currently empty (`{}`)

Deliberately NOT tracked: theme/palette files (`com.system76.CosmicTheme.*`, huge generated color data -- just re-pick the accent color in Settings > Appearance on a new machine), `com.system76.CosmicBackground` (wallpaper path is machine-specific and points at a distro-provided image that won't exist elsewhere), and any third-party applet config that was still empty/default at the time this package was created (e.g. `dev.edfloreshz.CosmicTweaks`).

### Adding custom keyboard shortcuts

`com.system76.CosmicSettings.Shortcuts/v1/custom` is a RON file mapping a key combo to an action. Format (see [Mohamed-Badry/cosmic-dotfiles](https://github.com/Mohamed-Badry/cosmic-dotfiles) for more examples):

```ron
{
    (
        modifiers: [Super, Shift],
        key: "s",
        description: Some("Screenshot"),
    ): Spawn("cosmic-screenshot --interactive=true"),
    (
        modifiers: [Super],
        key: "Left",
    ): Focus(Left),
}
```

`modifiers` is a list of `Super`/`Shift`/`Ctrl`/`Alt`; `description` is optional and just shown in Settings; the value is either `Spawn("<command>")`, a `Focus(...)`/`System(...)` action, or one of COSMIC's other built-in actions. Easiest workflow: set the shortcut via Settings > Keyboard > Custom Shortcuts in the GUI, then `git diff` this file to see what COSMIC wrote and commit it -- editing the RON by hand works too but is easy to typo. The `system_actions` file in the same directory (not currently tracked, empty by default) maps built-in roles like `Terminal:` to a command.

Stow only symlinks an entire subdirectory (e.g. `~/.config/nvim`) if that directory doesn't already exist on the target machine; if it does, it descends and symlinks individual files instead. This matters for `ssh/.ssh/config`: `~/.ssh` already contains real key files, so stow will add just the `config` symlink alongside them rather than replacing the directory.

## Known TODOs

- `ssh/.ssh/config`: `IdentityAgent` defers to `$SSH_AUTH_SOCK` so the same config works across OSes. On WSL2, something still needs to set `SSH_AUTH_SOCK` to a local socket bridged from the Windows host's 1Password agent (npiperelay + socat, per 1Password's WSL docs). Not yet set up.
