#!/usr/bin/env bash
set -euo pipefail

declare -A grid
grid[0,0]=A
grid[0,1]=B
grid[1,0]=C
grid[1,1]=D

echo "${grid[0,0]}${grid[0,1]}"
echo "${grid[1,0]}${grid[1,1]}"
