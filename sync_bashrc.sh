#!/bin/bash

# Navigate to the .config/bashrc directory
cd ~/.config/bashrc || {
    echo "Directory ~/.config/bashrc not found."
    exit 1
}

# Perform a git pull and check for changes
output=$(git pull)

# Check if the output contains the string "Already up to date."
if [[ $output != *"Already up to date."* ]]; then
    echo "Successfully updated .config/bashrc"
else
    echo "No available updates were found."
fi

