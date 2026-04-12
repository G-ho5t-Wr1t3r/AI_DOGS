#!/usr/bin/env python3

import subprocess

def kill_frozen_container():
    # Print start of process
    print("--- Searching frozen containers ---")
    
    try:
        # Find active container IDs
        cmd = "docker ps -q --filter ancestor=gemini-env"
        ids = subprocess.check_output(cmd.split()).decode().split()
        
        for c_id in ids:
            # Force kill the container
            print(f"Killing container: {c_id}")
            subprocess.run(["docker", "kill", c_id], check=True)
            
        # Confirm cleanup success
        print("Success: Frozen containers killed.")
    except Exception as e:
        # Handle execution errors
        print(f"Error during kill: {e}")

if __name__ == "__main__":
    kill_frozen_container()
