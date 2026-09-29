#!/usr/bin/env bash

usage() {
    echo "Usage: $0 [-c] [-g] [-s] [-d] [-k|--skill]"
    echo "  -c            Claude"
    echo "  -g            Gemini"
    echo "  -s            Setup"
    echo "  -d            Delete"
    echo "  -k, --skill   Mount the Claudio skill (Claude only, Setup only)"
    exit 1
}

# Translate long options into the short ones getopts understands.
args=()
for a in "$@"; do
    case "$a" in
        --skill) args+=("-k") ;;
        *)       args+=("$a") ;;
    esac
done
set -- "${args[@]}"

claude=false
gemini=false
setup=false
delete=false
skill=false

while getopts "cgsdk" opt; do
    case "$opt" in
        c) claude=true ;;
        g) gemini=true ;;
        s) setup=true ;;
        d) delete=true ;;
        k) skill=true ;;
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

if $skill && ! $claude; then
    echo "Error: --skill (-k) is only available for Claude (-c)."
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

# Build the bind mounts that inject the Claudio skill into the auth volume.
# The :Z suffix relabels the host paths for SELinux (Bluefin and other
# immutable distros). The skill dir is writable so "add to the skill" edits
# persist back to the repo copy; the hook and settings are read-only reference.
skill_mounts=()
if $skill; then
    claudio_dir="$(cd "$build_dir/.claudio" && pwd)"
    skill_mounts+=( -v "$claudio_dir/claudio":"$home_dir/.claude/skills/claudio":Z )
    skill_mounts+=( -v "$claudio_dir/hooks/claudio-session-start.sh":"$home_dir/.claude/hooks/claudio-session-start.sh":ro,Z )
    skill_mounts+=( -v "$claudio_dir/settings.json":"$home_dir/.claude/settings.json":ro,Z )
fi

if $setup; then
    echo "Building Image..."
    podman build -t "$image" "$build_dir"

    echo "Creating auth volume..."
    podman volume create "$volume"

    $skill && echo "Mounting Claudio skill..."

    echo "Starting container..."
    podman run -it --rm \
        -v ~/Desktop/CHANGEME:/mnt/host_context \
        -v "$volume":"$home_dir" \
        -v "$output_dir":/app/output \
        "${skill_mounts[@]}" \
        "$image"

elif $delete; then
    echo "Removing Image..."
    podman rmi "$image"

    echo "Removing Volumes..."
    podman volume rm "$volume"

    echo "Cleaning System..."
    podman system prune -f
fi
