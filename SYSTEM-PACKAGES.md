# System packages (apt)

Inventory of apt packages manually installed on `dell-g5` (Ubuntu 26.04 LTS), beyond what the installer put down. Companion to `Brewfile`, which covers Homebrew + Flatpak — this covers the base OS layer. Generated 2026-08-08 by diffing `apt-mark showmanual` against the package set from the original install (`/var/log/apt/history.log`, first `Start-Date` block).

The system was installed 2026-08-07; every package below was added within about a day of that install, mostly through the GNOME Software / Ubuntu installer's "additional drivers" flow or a terminal `apt install`.

## Third-party repositories required

- **WezTerm** (`apt.fury.io/wez`) — `/etc/apt/sources.list.d/wezterm.list`, signed by `/usr/share/keyrings/wezterm-fury.gpg`. Needed before `wezterm` can be installed on a fresh machine:
  ```
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt update
  ```

Everything else below comes from standard Ubuntu repos (`main`/`restricted`/`universe`/`multiverse`).

## Packages, by purpose

**Terminal / dev tooling**
- `wezterm` — terminal emulator (replaced the stock GNOME Terminal; see `dotfiles` note that Alacritty was tried and dropped in favor of this)
- `curl`, `git` — installed together, basic dev tooling
- `build-essential` — gcc/g++/make toolchain
- `bazaar` — Bazaar VCS (`bzr`)

**Disk / boot / encryption** — all installed together via `aptdaemon` (GUI-driven), consistent with setting up a ZFS root with LUKS encryption and EFI boot:
- `cryptsetup` — LUKS disk encryption
- `zfsutils-linux`, `zfs-dracut` — ZFS filesystem + initramfs (dracut) integration
- `efibootmgr`, `grub-efi-amd64`, `grub-efi-amd64-signed`, `shim-signed` — EFI bootloader + Secure Boot signing
- `mdadm` — Linux software RAID (installed separately, ~2.5 hours after the disk/boot batch)

**GPU**
- `nvidia-driver-595-open`, `linux-modules-nvidia-595-open-generic-hwe-26.04` — NVIDIA open kernel driver, installed together via `apt-get -o DPkg::options::=--force-confnew`

**Desktop / locale**
- `flatpak`, `gnome-software-plugin-flatpak` — Flatpak support + GNOME Software integration (installed together; see `Brewfile` for the actual Flatpak app list)
- `ubuntu-restricted-addons` — codecs/fonts (GUI-installed)
- `wbritish` — British English spellcheck dictionary (GUI-installed)

**Remote access**
- `openssh-server` — SSH daemon

## Reproducing on a new machine

1. Add the WezTerm repo (above) before installing packages that depend on it.
2. `sudo apt update && sudo apt install cryptsetup zfsutils-linux zfs-dracut efibootmgr grub-efi-amd64 grub-efi-amd64-signed shim-signed mdadm nvidia-driver-595-open linux-modules-nvidia-595-open-generic-hwe-26.04 flatpak gnome-software-plugin-flatpak ubuntu-restricted-addons wbritish openssh-server curl git build-essential bazaar wezterm`
3. Disk/boot packages (`cryptsetup`, ZFS, GRUB/EFI, `mdadm`) only matter if replicating the same ZFS-on-LUKS root + software RAID layout — skip them for a simpler install.
4. Then run `dotfiles/install.sh` and `brew bundle install --file=Brewfile` for the rest.
