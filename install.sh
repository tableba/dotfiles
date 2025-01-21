#!/bin/bash

OK="$(tput setaf 2)[OK]$(tput sgr0)"
ERROR="$(tput setaf 1)[ERROR]$(tput sgr0)"
NOTE="$(tput setaf 3)[NOTE]$(tput sgr0)"
WARN="$(tput setaf 5)[WARN]$(tput sgr0)"
CAT="$(tput setaf 6)[ACTION]$(tput sgr0)"
WHITE=$(tput setaf 7)
ORANGE=$(tput setaf 166)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Define source and target directories
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.config"

# Function to create symlinks
link_files() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ] && [ -L "$target" ]; then
        echo "$WARN $target already exists, skipping."
    else
        if [ -e "$target" ] && [ ! -L "$target" ]; then
          echo "$WARN $target already exists but is $RED$(tput bold)NOT$RESET a symlink, skipping."
          echo "If you want to overwrite it you need to remove it first with:"
          echo "$ORANGE$(tput bold)rm -rf $target$RESET"
          echo "and run this script again."
        else
            ln -s "$source" "$target"
            echo "Linked $source -> $target"
        fi
    fi
}

#create .config if it is not already there
if [ ! -d "$HOME/.configgg" ]; then
  mkdir "$HOME/.configgg"
fi

# Link individual files
link_files "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"

# Iterate over subdirectories in .config and create symlinks
for subdir in "$DOTFILES_DIR/.config/"*; do
    if [ -d "$subdir" ]; then
        base_name=$(basename "$subdir")
        target_subdir="$TARGET_DIR/$base_name"

        link_files "$subdir" "$target_subdir"
    fi
done

echo "Dotfiles installation complete."

