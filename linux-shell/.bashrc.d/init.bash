export SSH_AUTH_SOCK=~/.1password/agent.sock

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"

bash -c '[ -d "/home/brandonr/Documents/Projects/dotfiles/.git" ] && git -C "/home/brandonr/Documents/Projects/dotfiles" pull --quiet --ff-only &>/dev/null' &


