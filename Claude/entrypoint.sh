#!/bin/bash

SOURCE="/mnt/host_context"
DEST="/app/context"

echo "--- Syncing Context Folder ---"

if [ -d "$SOURCE" ]; then
    mkdir -p "$DEST"
    rm -rf "${DEST:?}/"* 2>/dev/null
    if cp -rp "$SOURCE"/. "$DEST"/ 2>/dev/null; then
        echo "Success: Context copied internally."
    else
        echo "Warning: File copy failed (continuing)."
    fi
else
    echo "Warning: Context source missing (continuing)."
fi

echo "--- Checking Claude Authentication ---"

if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "Auth: using ANTHROPIC_API_KEY."
elif [ -f "${CLAUDE_CONFIG_DIR:-/root/.claude}/.credentials.json" ]; then
    echo "Auth: found persisted credentials."
else
    echo "Auth: no credentials found. Run 'claude' and log in once;"
    echo "      the token will be saved to the mounted volume for next time."
fi

echo "--- Running Utility Script ---"

if [ -f /app/utility/utility.sh ]; then
    chmod +x /app/utility/utility.sh 2>/dev/null
    bash /app/utility/utility.sh || echo "Warning: utility script failed (continuing)."
fi

echo "--- Opening Interactive Shell ---"

exec /bin/bash