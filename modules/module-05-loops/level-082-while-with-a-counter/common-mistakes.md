# Common Mistakes

- **Never updating the counter.** The condition stays true forever.
  Wrong: a body that prints but never touches `week` (endless output, stop it with Ctrl-C)
  Right: `week=$(( week + 1 ))` as the last line of the body
- **Starting the counter in the wrong place.** If `week=1` sits inside the loop, it resets every round.
  Wrong: `while (( week <= weeks )); do week=1; ...`
  Right: set it once, above the loop
- **Off by one with `<` versus `<=`.** `week < weeks` stops one week early.
  Wrong: for 3 weeks, only weeks 1 and 2 print
  Right: `week <= weeks`
- **Forgetting that `$(( ))` is needed for assignments.** Plain `week=week+1` stores the text "week+1".
  Right: `week=$(( week + 1 ))` or `(( week++ ))`
