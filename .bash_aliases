# General
alias c='clear'
alias reload='. ~/.bash_profile'
alias size="sudo du -sh .[!.]* *"
alias ls="ls -A --color=auto"

# Ubuntu/WSL
alias update='sudo apt-get update && sudo apt-get upgrade'
alias pls='sudo apt-get'
alias install='sudo apt install !!'
alias rmid='rm *:Zone.Identifier'

# Slurm
alias squeue="squeue -l"
alias q="squeue"
alias myq="squeue -u $USER"
alias scancel-all="scancel --user=$USER"

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
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gu='git pull'
alias gl='git log --all --graph --date=format-local:"%a %b %d %Y %H:%M:%S %z" --pretty=format:"%C(magenta)%h %C(white)%an  %C(yellow)%d%n%C(green)%ad (%ar)%n%s%n"'


alias gb='git branch'
alias gi='git init'
alias gcl='git clone'
alias gco='git checkout'
alias gs='git status'
alias git-prune='git remote prune origin'
alias git-rm-feature-branch='git branch --merged | grep -v "^\*\\|main" | xargs -n 1 git branch -d'

# Nix
alias rebuild='sudo nixos-rebuild switch --flake ~/nixos#mikey'
alias edit='sudo nvim ~/nixos/home/default.nix'

# Misc
alias k="kubectl"
alias dc="docker-compose"
alias remake='make clean && make'
alias rust-book='pushd /home/mikey/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/doc/rust/html && python -m http.server && popd'

