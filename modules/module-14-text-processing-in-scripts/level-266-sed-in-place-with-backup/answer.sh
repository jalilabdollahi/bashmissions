#!/usr/bin/env bash
set -euo pipefail

old=$1 new=$2 file=$3

# -i.bak   edit the file itself and save the original as "$file.bak".
#          Writing the suffix directly after -i works on both GNU and BSD sed;
#          a bare "-i" does not (BSD would take the next word as the suffix).
# The double quotes let the shell put the words into the s command.
sed -i.bak "s/$old/$new/g" "$file"

echo "patched $file"
