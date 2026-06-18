#!/bin/bash

# Define context source path
SOURCE="/mnt/host_context"
# Define context destination path
DEST="/app/context"

# Print folder sync message
echo "--- Syncing Context Folder ---"

# Check if source exists
if [ -d "$SOURCE" ]; then
    # Create destination directory structure
    mkdir -p "$DEST"
    
    # Clean previous context files
    rm -rf "$DEST"/*
    
    # Copy files from host
    if ! cp -rp "$SOURCE"/. "$DEST/"; then
        # Print file copy error
        echo "Error: File copy failed."
    fi
    
    # Print sync success message
    echo "Success: Context copied internally."
else
    # Print missing source error
    echo "Error: Context source missing!"
fi

# Print shell startup message
echo "--- Opening Interactive Shell ---"

chmod +x /app/utility/utility.sh || (echo "Chmod failed" && exit 1)
bash /app/utility/utility.sh || (echo "Utility script execution failed" && exit 1)

# Execute interactive bash shell
exec /bin/bash