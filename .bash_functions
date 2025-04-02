t () {
  pushd $(mktemp -d /tmp/$1.XXXX)
}

cd () {
    builtin cd "$@" || return
    limit=50
    count=$(ls -1 | wc -l)
    if [ "$count" -le "$limit" ]; then
        ls
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

vim() {
    if command -v lvim >/dev/null 2>&1; then
        lvim "$@"
    else
        command vim "$@"
    fi
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

addalias() {
    local alias_name="$1"
    shift
    local command="$*"

    if [[ -z "$alias_name" || -z "$command" ]]; then
        echo "Usage: addalias <alias_name> <command>"
        return 1
    fi

    # Ensure ~/.bash_aliases exists
    touch ~/.bash_aliases

   # Append the new alias (properly quoted)
    echo "alias $alias_name='$command'" >> ~/.bash_aliases

    # Ensure ~/.bash_aliases is sourced in ~/.bashrc
    if ! grep -q "source ~/.bash_aliases" ~/.bashrc; then
        echo "source ~/.bash_aliases" >> ~/.bashrc
    fi

    # Apply the alias immediately
    source ~/.bash_aliases

    echo "Alias '$alias_name' added successfully."
}

rmalias() {
    local alias_name="$1"

    if [[ -z "$alias_name" ]]; then
        echo "Usage: removealias <alias_name>"
        return 1
    fi

    # Ensure ~/.bash_aliases exists
    touch ~/.bash_aliases

    # Comment out the alias if it exists and is not already commented
    if grep -q "^alias $alias_name=" ~/.bash_aliases; then
        sed -i "s/^alias $alias_name=/# alias $alias_name=/" ~/.bash_aliases
        echo "Alias '$alias_name' has been commented out in ~/.bash_aliases."
    else
        echo "Alias '$alias_name' not found in ~/.bash_aliases."
    fi

    # Apply changes immediately
    unalias "$alias_name" 2>/dev/null

    echo "Run 'source ~/.bash_aliases' to refresh manually, or restart your shell."
}


flamegraph() {
    if [ -z "$1" ]; then
        echo "Usage:   flamegraph \"<your_command_here>\" [frequency]"
        echo "Example: flamegraph \"ls -l\" 99"
        return 1
    fi
    ls -lAh    
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
