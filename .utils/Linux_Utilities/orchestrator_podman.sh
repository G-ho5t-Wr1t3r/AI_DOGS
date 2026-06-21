#!/usr/bin/env bash

usage() {
    echo "Usage: $0 [-c] [-g] [-s] [-d]"
    echo "  -c  Claude"
    echo "  -g  Gemini"
    echo "  -s  Setup"
    echo "  -d  Delete"
    exit 1
}

claude=false
gemini=false
setup=false
delete=false

while getopts "cgsd" opt; do
    case "$opt" in
        c) claude=true ;;
        g) gemini=true ;;
        s) setup=true ;;
        d) delete=true ;;
        *) usage ;;
    esac
done

[ "$OPTIND" -eq 1 ] && usage

n_target=0
$claude && n_target=$((n_target+1))
$gemini && n_target=$((n_target+1))

n_action=0
$setup && n_action=$((n_action+1))
$delete && n_action=$((n_action+1))

if [ "$n_target" -ne 1 ] || [ "$n_action" -ne 1 ]; then
    echo "Error: choose exactly one target (-c/-g) and one action (-s/-d)."
    usage
fi

script_dir="$(cd "$(dirname "$0")" && pwd)"

if $claude; then
    name="claude"
    home_dir="/home/node"
    build_dir="$script_dir/../../Claude"
    out_target="$script_dir/../../Claude/claude_output"
else
    name="gemini"
    home_dir="/root"
    build_dir="$script_dir/../../Gemini"
    out_target="$script_dir/../../Gemini/gemini_output"
fi

mkdir -p "$out_target"
output_dir="$(cd "$out_target" && pwd)"

image="${name}-env"
volume="${name}-auth-data"

if $setup; then
    echo "Building Image..."
    podman build -t "$image" "$build_dir"

    echo "Creating auth volume..."
    podman volume create "$volume"

    echo "Starting container..."
    podman run -it --rm \
        -v ~/Desktop/CHANGEME:/mnt/host_context \
        -v "$volume":"$home_dir" \
        -v "$output_dir":/app/output \
        "$image"

elif $delete; then
    echo "Removing Image..."
    podman rmi "$image"

    echo "Removing Volumes..."
    podman volume rm "$volume"

    echo "Cleaning System..."
    podman system prune -f
fi