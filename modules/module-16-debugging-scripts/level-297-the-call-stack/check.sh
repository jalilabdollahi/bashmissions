#!/usr/bin/env bash
# Each "called from line N" must name a line of solution.sh that really holds
# a call to that function (not its definition), so off-by-one index mistakes
# are caught whatever the layout.
[[ -s $BM_STDERR_FILE ]] || exit 0
while IFS= read -r line; do
  fn=${line#  at }; fn=${fn%%,*}
  n=${line##* }
  src=$(sed -n "${n}p" solution.sh)
  if [[ $src != *"$fn"* ]] || [[ $src =~ ^[[:space:]]*(function[[:space:]]+)?"$fn"[[:space:]]*\(\) ]]; then
    echo "You said $fn was called from line $n, but that line of solution.sh is: $src"
    echo "Check which BASH_LINENO index belongs to which FUNCNAME index."
    exit 1
  fi
done < "$BM_STDERR_FILE"
exit 0
