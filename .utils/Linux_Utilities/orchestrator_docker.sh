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
    auth_dir="/home/node/.claude"
    config_dir="/home/node/.config"
    build_dir="$script_dir/../../Claude"
    out_target="$script_dir/../../Claude/claude_output"
else
    name="gemini"
    auth_dir="/root/.gemini"
    config_dir="/root/.config"
    build_dir="$script_dir/../../Gemini"
    out_target="$script_dir/../../Gemini/gemini_output"
fi

mkdir -p "$out_target"
output_dir="$(cd "$out_target" && pwd)"

image="${name}-env"
auth_volume="${name}-auth-data"
config_volume="${name}-config-data"

# Build the bind mounts that inject the Claudio skill into the auth volume.
# The skill dir is writable so "add to the skill" edits persist back to the
# repo copy; the hook and settings are read-only reference.
skill_mounts=()
if $skill; then
    claudio_dir="$(cd "$build_dir/.claudio" && pwd)"
    skill_mounts+=( -v "$claudio_dir/claudio":"$auth_dir/skills/claudio" )
    skill_mounts+=( -v "$claudio_dir/hooks/claudio-session-start.sh":"$auth_dir/hooks/claudio-session-start.sh":ro )
    skill_mounts+=( -v "$claudio_dir/settings.json":"$auth_dir/settings.json":ro )
fi

if $setup; then
    echo "Building Image..."
    docker build -t "$image" "$build_dir"

    echo "Creating volumes..."
    docker volume create "$auth_volume"
    docker volume create "$config_volume"

    $skill && echo "Mounting Claudio skill..."

    echo "Starting container..."
    docker run -it --rm \
        -v ~/Desktop/CHANGEME:/mnt/host_context \
        -v "$auth_volume":"$auth_dir" \
        -v "$config_volume":"$config_dir" \
        -v "$output_dir":/app/output \
        "${skill_mounts[@]}" \
        "$image"

elif $delete; then
    echo "Removing Image..."
    docker rmi "$image"

    echo "Removing Volumes..."
    docker volume rm "$auth_volume" "$config_volume"

    echo "Cleaning System..."
    docker system prune -f
fi
