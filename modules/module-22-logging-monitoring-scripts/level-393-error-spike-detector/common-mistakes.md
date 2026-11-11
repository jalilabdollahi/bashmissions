# Common Mistakes

- **Forgetting `sort` before `uniq -c`.** Wrong: `cut -c1-16 log | uniq -c` splits one minute into several groups whenever other lines interrupt it. Right: `sort | uniq -c`.
- **Matching ERROR anywhere.** Wrong: `grep ERROR log` counts `INFO no ERROR here`. Right: anchor to the level field, `grep -E '^[0-9-]+ [0-9:]+ ERROR '`.
- **Cutting the wrong width.** Wrong: `cut -c1-19` keeps seconds, so every line is its own group and nothing ever reaches the threshold. Right: `cut -c1-16` stops at the minute.
- **Pipe-ending loop with a counter.** Wrong: `... | uniq -c | while read ...; do spikes=$((spikes+1)); done` and testing `$spikes` afterwards: the loop ran in a subshell. Right: `done < <( ... )`.
- **grep and `set -e`.** Symptom: on a quiet log the script dies without a message, because grep found nothing and exited 1. Guard it: `{ grep ... || true; }`.
