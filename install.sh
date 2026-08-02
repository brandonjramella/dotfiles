#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

PACKAGES="stow tmux neovim"

missing() {
  ! command -v stow >/dev/null 2>&1 || ! command -v tmux >/dev/null 2>&1 || ! command -v nvim >/dev/null 2>&1
}

if missing; then
  if command -v brew >/dev/null 2>&1; then
    brew install $PACKAGES
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y $PACKAGES
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y $PACKAGES
  elif command -v apk >/dev/null 2>&1; then
    sudo apk add $PACKAGES
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm $PACKAGES
  else
    echo "No package manager found -- bootstrapping Homebrew" >&2
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -d /opt/homebrew/bin ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d /home/linuxbrew/.linuxbrew/bin ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
    brew install $PACKAGES
  fi
fi

cd "$SCRIPT_DIR"
stow tmux nvim ssh

HOOK_MARKER="# Dotfiles auto-update"
case "$SHELL" in
  */zsh) RC_FILE="$HOME/.zshrc" ;;
  *) RC_FILE="$HOME/.bashrc" ;;
esac

if [ -f "$RC_FILE" ] && ! grep -qF "$HOOK_MARKER" "$RC_FILE"; then
  cat >>"$RC_FILE" <<EOF

$HOOK_MARKER
if [ -d "$SCRIPT_DIR/.git" ]; then
  git -C "$SCRIPT_DIR" pull --quiet --ff-only 2>/dev/null
fi
EOF
fi
