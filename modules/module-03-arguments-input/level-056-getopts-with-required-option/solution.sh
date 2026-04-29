#!/usr/bin/env bash
set -euo pipefail

file=""

while getopts ":f:" opt; do
  case "$opt" in
    f) file="$OPTARG" ;;
    :) exit 1 ;;
    \?) exit 1 ;;
  esac
done

if [[ -z $file ]]; then
  exit 1
fi

echo "file=$file"
