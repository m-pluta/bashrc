# General
alias c='clear'
alias reload='. ~/.bash_profile'
alias size="sudo du -sh .[!.]* *"
alias ls="ls -A --color=auto"

# Ubuntu/WSL
alias update='sudo apt-get update && sudo apt-get upgrade'
alias pls='sudo apt-get'
alias install='sudo apt-get install !!'
alias rmid='rm *:Zone.Identifier'

# Slurm
alias squeue="squeue -l"
alias q="squeue"

# Python & pip
alias python='python3'
alias pipi='pip install'
alias pipr='pip install -r requirements.txt'
alias pipf='pip freeze > requirements.txt'
alias pipu='python -m pip install --upgrade pip && pip install --upgrade pip'

# Python venv
alias venv='python -m venv .venv && srcv'
alias srcv='source .venv/bin/activate'
alias redo-src='srcv && source .env'

# Git
alias git-prune='git remote prune origin'
alias git-rm-feature-branch='git branch --merged | grep -v "^\*\\|main" | xargs -n 1 git branch -d'

# Nix
alias rebuild='sudo nixos-rebuild switch --flake ~/nixos#mikey'
alias edit='sudo nvim ~/nixos/home/default.nix'

# Misc
alias k="kubectl"
alias dc="docker-compose"
alias remake='make clean && make'