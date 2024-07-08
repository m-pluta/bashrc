# System
alias c='clear'
alias reload='source ~/.bashrc'
alias please='sudo apt-get'
alias rmid='rm *:Zone.Identifier'
alias update='sudo apt-get update && sudo apt-get upgrade'
alias sync-bashrc="~/.config/bashrc/sync-bashrc.sh"

# Python and pip
alias python='python3'
alias pipi='pip install'
alias pipr='pip install -r'
alias pipf='pip freeze > requirements.txt'
alias pipu='pip install --upgrade pip'

# Python venv
alias venv='python -m venv .venv && srcv'
alias srcv='source .venv/bin/activate'
alias redo-src='srcv && source .env'

# Git
alias git-test='git commit -m '\''WIP'\'' && git stash -u'
alias git-undo-test='git reset --soft HEAD^'

# Nix
alias rebuild='sudo nixos-rebuild switch --flake /etc/nixos#mikey'
alias edit='sudo nvim /etc/nixos/hosts/default/configuration.nix'
