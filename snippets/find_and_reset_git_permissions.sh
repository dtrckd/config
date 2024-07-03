#!/bin/bash

# Git Permission Reset
git_reset_permissions() {
    # Initialize an empty variable to hold the patch content
    patch_content=""

    # Get the list of files with permission changes
    # output in form of: mode change 100644 => 100755 lambda.js
    files=$(git diff --summary --diff-filter=MT | grep 'mode change' | awk '{print $3, $5, substr($0, index($0,$6))}')

    # Iterate over each line in 'files'
    while IFS= read -r line; do
        # Skip empty lines
        if [ -z "$line" ]; then
            continue
        fi

        # Read the old_mode, new_mode, and file name
        old_mode=$(echo "$line" | awk '{print $1}')
        new_mode=$(echo "$line" | awk '{print $2}')
        file=$(echo "$line" | awk '{print substr($0, index($0,$3))}')

        # Append to the patch content
        patch_content="${patch_content}diff --git a/$file b/$file\n"
        patch_content="${patch_content}old mode $new_mode\n"
        patch_content="${patch_content}new mode $old_mode\n"
    done <<< "$files"

    # Apply the patch directly from the variable
    if ! [[ -z "$patch_content" ]]; then
        echo -e "$patch_content" | git apply
    fi
}

# Define the function to find .git directories and run the git_reset_permissions script
find_git_directories_and_reset_permissions() {
    local base_dir="$1"

    # Find all directories containing a .git directory
    find "$base_dir" -type d -name ".git" -print0 | while IFS= read -r -d '' git_dir; do
        # Get the parent directory of the .git directory
        cd "$git_dir/.."

        # Run the git_reset_permissions script on the repository directory
        echo "Resetting permissions in $git_dir"
        git_reset_permissions
        cd - > /dev/null
    done
}

# Check if the base directory is provided as an argument
if [ -z "$1" ]; then
    echo "Usage: $0 <base_directory>"
    exit 1
fi

# Call the function with the provided base directory
find_git_directories_and_reset_permissions "$1"

# Fix other basic permissions
#for EXT in txt yaml yml json toml conf csv xlsx data gql graphql log md sql jinja bru doc docx jpeg jpg png pdf mp3 wav mp4 flac;
#    find -type f -name "*.$EXT" -print0 | xargs -0  chmod -x
#end
