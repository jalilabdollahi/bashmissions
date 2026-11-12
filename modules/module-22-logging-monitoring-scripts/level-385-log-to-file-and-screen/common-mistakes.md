# Common Mistakes

- **Forgetting `-a`.** Wrong: `... | tee "$log"` overwrites the log on every line, so only the last line survives. Right: `tee -a "$log"`.
- **Using `>>` and expecting the screen output.** Wrong: `printf ... >> "$log"` writes the file but shows nothing. Right: pipe into `tee -a`, which does both.
- **Teeing the whole loop line by line with `>`.** Wrong: `done > "$log"` truncates once, then you lose the screen output. Right: `tee -a` inside the loop, or `done | tee -a "$log"` for the whole loop.
- **Counting inside a pipe.** Wrong: `printf ... | while read ...; do count=...; done` runs the loop in a subshell in some forms, so `$count` is 0 afterwards. Here the loop reads stdin directly, so the counter survives; keep it that way.
- **Not checking the folder.** Symptom: `tee: logs/sync.log: No such file or directory` appears once per line while the screen output carries on. Test with `[[ -d $(dirname "$log") ]]` first.
