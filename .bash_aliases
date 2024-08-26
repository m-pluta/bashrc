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
alias git-prune='git remote prune origin'
alias git-rm-feature-branch='git branch --merged | grep -v "^\*\\|main" | xargs -n 1 git branch -d'

# Nix
alias rebuild='sudo nixos-rebuild switch --flake ~/nix#mikey'
alias edit='sudo nvim ~/nix/home/default.nix'
