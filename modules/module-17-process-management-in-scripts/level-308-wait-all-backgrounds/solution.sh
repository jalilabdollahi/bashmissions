#!/usr/bin/env bash
set -euo pipefail

{ sleep 0.05; echo one > one.txt; } &
{ sleep 0.05; echo two > two.txt; } &
wait
cat one.txt two.txt | sort
