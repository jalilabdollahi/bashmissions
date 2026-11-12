# Common Mistakes

- **Comparing decimals with `(( ))`.** Wrong: `(( load >= 5 ))` with `load=7.2` is a syntax error. Right: let awk compare, `awk -v v="$load" 'BEGIN { exit !(v + 0 >= 5) }'`.
- **Unquoted operators.** Wrong: `case $op in > | >= ) ...` (shell redirection). Right: quote them: `'>' | '>=' | '<'`.
- **Alerting forever.** Wrong: snapshotting on every run while the metric stays high. Right: store the time of the last snapshot per rule and compare it with the cooldown.
- **Writing straight into the final directory.** Wrong: a crash mid-collection leaves `INC-0007-high-load/` that looks complete. Right: build in `mktemp -d`, then `mv`, and let a trap remove the leftover.
- **Letting one collector kill the snapshot.** Wrong: `ss -tn > net.txt` under `set -e` aborts everything when `ss` fails. Right: `if ! collect ...`, record the failure, keep going.
- **Sorting unpadded numbers.** Wrong: `INC-10` sorts before `INC-2`, so pruning deletes the wrong ones. Right: `printf '%04d'`.
