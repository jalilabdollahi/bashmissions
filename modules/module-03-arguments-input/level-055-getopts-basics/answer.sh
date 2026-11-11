#!/usr/bin/env bash
set -euo pipefail

count=3
verbose="no"

# "vn:" lists the accepted letters; the colon after n means -n takes a value.
# Each loop turn puts the next option letter into $opt, and its value into $OPTARG.
while getopts "vn:" opt; do
  case $opt in
    v) verbose="yes" ;;
    n) count=$OPTARG ;;
  esac
done

[[ $verbose == "yes" ]] && echo "showing first $count lines"

head -n "$count"
