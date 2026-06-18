#!/bin/bash

sed -i '$ a alias c="clear"' ~/.bashrc > /dev/null 2>&1
source ~/.bashrc

echo "--- Utility Aliases ---"
alias
echo 
echo "To run Claude in 'YOLO MODE', use the command: 'claude --dangerously-skip-permissions'"
echo "To trigger Claude 'YOLO MODE' with Shift+Tab, use the command: 'claude --allow-dangerously-skip-permissions'"