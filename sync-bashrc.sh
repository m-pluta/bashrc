#!/bin/bash

# Navigate to the .config/bashrc directory
cd ~/.config/bashrc || {
    echo "Directory ~/.config/bashrc not found."
    exit 1
}

# Perform a git pull
git pull || {
    echo "Failed to pull from git repository."
    exit 1
}

echo "Successfully updated .config/bashrc"

