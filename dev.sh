#!/bin/sh

# Save current directory
cd_old="$(pwd)"

# Change to the directory where the script is located
cd "$(dirname "$0")"

if [ -f "launcher_linux" ]; then
    # Start launcher_linux with arguments in background (similar to 'start')
    ./launcher_linux -dev +set lua_nocompile 1 "$@" &
else
    echo "Error: launcher_linux not found in this script's directory."
    echo "Press any key to exit . . ."
    read -n 1 -s
fi

# Return to original directory
cd "$cd_old"