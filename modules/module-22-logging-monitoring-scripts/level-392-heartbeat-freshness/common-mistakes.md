# Common Mistakes

- **Skipping the existence test.** Wrong: only `[[ $beat -ot $stamp ]]`; a heartbeat that never existed is not older than anything, so it prints `fresh`. Right: test `-e` first and report MISSING.
- **Parsing `ls -l` for times.** Wrong: `ls -l "$beat" | awk '{print $6,$7,$8}'` yields text whose format depends on the system and on how old the file is. Right: compare with `-nt` / `-ot`.
- **Mixing up the direction.** Wrong: `[[ $beat -nt $stamp ]]` as the *stale* test prints the opposite of reality. A *newer* heartbeat is the healthy one.
- **Forgetting that equal times are neither newer nor older.** Testing only `-nt` for freshness marks a heartbeat from the very same second as stale. Test for `-ot` as the stale condition instead.
- **Stopping at the first problem.** Symptom: only one STALE line, though three jobs are down. Record the failure in a variable and keep looping.
