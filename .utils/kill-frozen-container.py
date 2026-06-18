#!/usr/bin/env python3
import argparse
import subprocess


def kill_frozen_container(cmds):
    print("--- Searching frozen containers ---")
    ids = []
    for cmd in cmds:
        try:
            out = subprocess.check_output(cmd.split()).decode().split()
            ids.extend(out)
        except subprocess.CalledProcessError as e:
            print(f"Warning: lookup failed for '{cmd}': {e}")

    if not ids:
        print("No matching containers found.")
        return

    for c_id in ids:
        print(f"Killing container: {c_id}")
        try:
            subprocess.run(["docker", "kill", c_id], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error killing {c_id}: {e}")

    print("Success: Frozen containers killed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Kill your Claude/Gemini containers."
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-c", action="store_true", help="Claude's container")
    group.add_argument("-g", action="store_true", help="Gemini's container")
    group.add_argument("-a", action="store_true", help="Both containers")

    args = parser.parse_args()

    if args.a:
        cmds = [
            "docker ps -q --filter ancestor=gemini-env",
            "docker ps -q --filter ancestor=claude-env",
        ]
    elif args.g:
        cmds = ["docker ps -q --filter ancestor=gemini-env"]
    else:
        cmds = ["docker ps -q --filter ancestor=claude-env"]

    kill_frozen_container(cmds)