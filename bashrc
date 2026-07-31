#!/usr/bin/env bash

# ----- Appearance -----

# ----- OS Detection -----
case "$(uname -s)" in
	Darwin) OS="mac" ;;
	Linux)  OS="linux" ;;
esac

case "$(uname -s)" in
	Darwin) export STARSHIP_OS_COLOR="light blue" ;;
	Linux) export STARSHIP_OS_COLOR="orange" ;;
esac


# ----- Host checker -----
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
host_file="$DOTFILES_DIR/hosts/$(hostname -s).sh"
[[ -f $host_file ]] && source "$host_file"

# ----- HomeBrew (Mac only) -----
# TODO move this to mac only file
if [[ $OS == "mac" ]] && [[ -x /opt/homebrew/bin/brew ]]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ----- PATH -----
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"

# ----- History -----
HISTCONTROL=ignoredups:erasdeups
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# ----- Defaults -----
export EDITOR=nvim
export VISUAL=nvim
export STARSHIP_CONFIG="$HOME/.dotfiles/starship.toml"

# ----- Aliases -----

# Git Aliases
alias gaa='git add .'
alias gcm='git commit -m'
alias gpsh='git push'
alias gs='git status'

# Directory shortcuts
alias root='cd /'
alias dev='cd ~/dev'
alias godot='cd ~/dev/godot'
alias o="open ." # Open the current directory in Finder

# Docker shortcuts
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dcp='docker compose pull && docker compose up -d'

# application shortcuts
alias vi='nvim'
alias vim='nvim'
#alias ls='eza --icons'
#alias ll='eza -l --icons --git'
#alias la='eza -la --icons --git'
#alias lt='eza --tree --icons'
#alias cat='bat'
#alias grep='rg'

# config shortcuts - #TODO change this to open the non prod configs, maybe add a flag option to open prod with --prod?
alias vimrc='vim ~/dev/.env/.config/nvim'
alias bashrc='vim ~/dev/.env/.config/bashrc'
alias loadbash='source ~/.bash_profile'

# fd/bat linux alias #TODO move this to linux only file
# apt installs fd and bat as fdfind and batcat
if [[ $OS == "linux" ]]; then
	alias fd=fdfind
	alias bat=batcat
fi

# ----- MKCD command -----
function mkcd()
{
	mkdir $1 && cd $1
}

# ----- Fleet ping checker -----
sshl() {
	local ssh_config="$HOME/.ssh/config"
	[[ -f $ssh_config ]] || { echo "No ~/.ssh/config found at $ssh_config"; return 1;}

	#get every non wildcard host alias
	local aliases
	aliases=$(awk '/^[Hh]ost[[:space:]]/{for(i=2;i<=NF;i++) if ($i !~ /[*?]/) print $i}' "$ssh_config")

	local h target
	for h in $aliases; do
		target=$(ssh -G "$h" 2>/dev/null | awk '/^hostname /{print $2}')
		target="${target:-$h}"

		if ping -c1 -W1 "$target" &>/dev/null; then
			printf '  \033[32m*\033[0m %s\n' "$h"
		else
			printf '  \033[31m*\033[0m %s\n' "$h"
		fi
	done
}

# ----- Tool Init -----
command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
command -v fzf &>/dev/null && eval "$(fzf --bash)"
command -v starship &>/dev/null && eval "$(starship init bash)"
command -v atuin &>/dev/null && eval "$(atuin init bash)"

# ----- SSH Agent Re-direct -----
export SSH_AUTH_SOCK="$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

# ----- Auto start TMUX over SSH -----
if [[ -n $SSH_CONNECTION ]] && [[ -z $TMUX ]] && command -v tmux &>/dev/null; then
	tmux attach -t SSH || tmux new -s SSH
fi

