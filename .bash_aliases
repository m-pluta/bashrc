# General
alias c='clear'
alias reload='source ~/.bashrc'
alias size="sudo du -sh .[!.]* *"

# Ubuntu/WSL
alias update='sudo apt-get update && sudo apt-get upgrade'
alias pls='sudo apt-get'
alias install='sudo apt-get install !!'
alias rmid='rm *:Zone.Identifier'

# bashrc
alias sync-bashrc="~/.config/bashrc/sync_bashrc.sh"
alias setup-bashrc="~/.config/bashrc/setup_symlink.sh"

# Slurm
alias squeue="squeue -l"
alias q="squeue"

# Python & pip
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
alias rebuild='sudo nixos-rebuild switch --flake ~/nixos#mikey'
alias edit='sudo nvim ~/nixos/home/default.nix'

# Misc
alias k="kubectl"

mkcd() {
    mkdir -p "$1" && cd "$1"
}

cb() {
    # Check if an argument is provided
    if [ -z "$1" ]; then
        echo "Usage: cb <number_of_levels>"
        return 1
    fi

    # Get the number of levels to go up
    levels=$1

    # Build the directory path with n ".."
    path=""
    for ((i = 0; i < levels; i++)); do
        path+="../"
    done

    # Change to the constructed path
    cd "$path" || return
}

flamegraph() {
    if [ -z "$1" ]; then
        echo "Usage:   flamegraph \"<your_command_here>\" [frequency]"
        echo "Example: flamegraph \"ls -l\" 99"
        return 1
    fi

    local freq=${2:-99}

    # Check if FlameGraph directory exists, if not clone it
    local flamegraph_dir="$HOME/FlameGraph"
    if [ ! -d "$flamegraph_dir" ]; then
        echo "FlameGraph directory not found at $flamegraph_dir"
        echo "Cloning FlameGraph from GitHub..."
        git clone https://github.com/brendangregg/FlameGraph.git "$flamegraph_dir" || {
            echo "Failed to clone FlameGraph."
            echo "Clone using git clone https://github.com/brendangregg/FlameGraph.git"
            return 1
        }
    fi

    # Generate the flamegraph
    perf record -F "$freq" -a -g -- bash -c "$1" && \
    perf script | perl "$flamegraph_dir/stackcollapse-perf.pl" | perl "$flamegraph_dir/flamegraph.pl" --hash > flamegraph.svg

    local full_path="$(realpath flamegraph.svg)"
    if [ -f "$full_path" ]; then
        echo "Flamegraph saved to $full_path"

        # Auto-upload the flamegraph and get the link
        local upload_response=$(upload "$full_path")
        echo "$upload_response"
    else
        echo "Failed to generate flamegraph."
    fi
}

upload() {
    if [ -z "$1" ]; then
        echo "Usage: upload <path_to_file_or_directory>"
        echo "Directories are saved as a .tar.gz"
        return 1
    fi

    local file_path="$1"

    if [ -d "$file_path" ]; then
        local tar_file="${file_path%/}.tar.gz"
        tar -czf "$tar_file" -C "$(dirname "$file_path")" "$(basename "$file_path")" || {
            echo "Failed to create tar.gz archive from directory: $file_path"
            return 1
        }
        file_path="$tar_file"
        echo "Directory archived as: $(realpath "$file_path")"
    elif [ ! -f "$file_path" ]; then
        echo "File not found: $file_path"
        return 1
    fi

    # Upload the file
    local response=$(curl -s -F "file=@$file_path" https://tmpfiles.org/api/v1/upload)

    # Extract the URL from the response
    local url=$(echo "$response" | grep -oP '"url":"\K[^"]+')

    if [ -n "$url" ]; then
        echo "File uploaded successfully: $url"
    else
        echo "Failed to upload file."
    fi
}
