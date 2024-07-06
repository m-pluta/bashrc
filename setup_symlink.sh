#!/bin/bash

# Define the source and target directories
SRC_DIR="$HOME/.config/bashrc"
TARGET_DIR="$HOME"

# Create symlinks
ln -sf "$SRC_DIR/.bashrc" "$TARGET_DIR/.bashrc"
ln -sf "$SRC_DIR/.bash_aliases" "$TARGET_DIR/.bash_aliases"
ln -sf "$SRC_DIR/.bash_logout" "$TARGET_DIR/.bash_logout"

echo "Symlinks created:"
echo "$TARGET_DIR/.bashrc -> $SRC_DIR/.bashrc"
echo "$TARGET_DIR/.bash_aliases -> $SRC_DIR/.bash_aliases"
echo "$TARGET_DIR/.bash_logout -> $SRC_DIR/.bash_logout"