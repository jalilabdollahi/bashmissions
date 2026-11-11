# Common Mistakes

- **Forgetting `wait`.** The script reads or exits before the probes finished.
  Wrong: report loop right after the launch loop (empty answers: `anchovy: `)
  Right: `wait` between the two loops
- **Printing from inside the jobs.** The order follows whoever finished first.
  Wrong: `probe-host "$host" | sed ... &` printing straight to the screen
  Right: save each result in its own file, print after `wait` in a fixed order
- **Sharing one output file.** Two jobs writing to the same file overwrite each other.
  Wrong: `probe-host "$host" > result.txt &`
  Right: one file per job, like `"$results/$i"`
- **Putting `&` on the wrong command.** `for ...; do ...; done &` backgrounds the whole loop and the jobs inside still run one after another.
  Right: put `&` on the single command you want to run in parallel
- **Using `wait` inside the launch loop.** That turns it back into a serial script.
