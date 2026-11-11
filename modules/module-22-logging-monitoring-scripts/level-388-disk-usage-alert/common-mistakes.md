# Common Mistakes

- **Plain `df` instead of `df -P`.** Symptom: on long device names the columns slide onto the next line and `pct` holds garbage. Right: `df -P`.
- **Comparing with the percent sign.** Wrong: `[[ $pct -ge 90 ]]` with `92%` errors or compares as 0. Right: strip it first, `pct=${pct%\%}`.
- **Forgetting the header.** Symptom: the first line has `Capacity` in the pct column and breaks the arithmetic. Eat it with a `read -r _header` before the loop.
- **Counting inside a pipeline.** Wrong: `df -P | while read ...; do alerts=$((alerts+1)); done` and then testing `$alerts`: the loop ran in a subshell, so the counter is still 0. Right: feed the loop with `<<<` or process substitution.
- **Alerting on tmpfs.** `tmpfs` at 100% in `/dev/shm` is normal for some setups. Filter on `[[ $device == /dev/* ]]` so only real disks wake someone.
