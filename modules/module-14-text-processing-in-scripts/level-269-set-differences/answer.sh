#!/usr/bin/env bash
set -euo pipefail

old=$1 new=$2

# comm prints three columns: only in file 1, only in file 2, in both.
# -1 -2 -3 each switch one column off. comm needs sorted input.
#   -13 : hide "only in 1" and "both"  -> lines only in the NEW list
#   -23 : hide "only in 2" and "both"  -> lines only in the OLD list
comm -13 <(sort "$old") <(sort "$new") | sed 's/^/+ /'
comm -23 <(sort "$old") <(sort "$new") | sed 's/^/- /'
