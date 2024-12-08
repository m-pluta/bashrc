#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the source and target directories
SRC_DIR="$SCRIPT_DIR"  # Use the directory where the script is located as the source
TARGET_DIR="$HOME"

# Function to back up existing files
backup_file() {
    local target_file="$1"
    if [ -e "$target_file" ]; then
        backup_file="${target_file}.backup.$(date +%Y%m%d%H%M%S)"
        mv "$target_file" "$backup_file"
        echo "Backed up $target_file to $backup_file"
    fi
}

# Back up and create symlinks
for file in .bashrc .bash_aliases .bash_logout; do
    target_file="$TARGET_DIR/$file"
    src_file="$SRC_DIR/$file"
    
    backup_file "$target_file"  # Back up the existing file
    ln -sf "$src_file" "$target_file"  # Create the symlink
    
    echo "Symlink created: $target_file -> $src_file"
done

