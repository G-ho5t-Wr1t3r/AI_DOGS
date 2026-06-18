#!/bin/bash

sed -i '$ a alias c="clear"' ~/.bashrc > /dev/null 2>&1
source ~/.bashrc

echo "--- Utility Aliases ---"
alias