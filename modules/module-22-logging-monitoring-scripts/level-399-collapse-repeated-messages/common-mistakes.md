# Common Mistakes

- **Forgetting the final flush.** Symptom: a log that ends with a flood loses the "repeated N times" line. Call the flush function once more after the loop.
- **Comparing whole lines.** Wrong: `[[ $line == "$prev_line" ]]` never matches, because the timestamps differ. Compare `${line#* }` (the message) instead.
- **Printing the note too early.** Wrong: printing "repeated" as soon as the second copy arrives; you do not know yet whether there will be a third. Count silently and print when the run ends.
- **Merging across gaps.** Wrong: keeping an associative array of counts per message folds `retry ... connected ... retry` into one group and hides the recovery. Compare only with the previous line.
- **Off by one.** Wrong: reporting the total copies (3) when the spec counts the *extra* copies after the first (2). Start the counter at zero for the first line and add one per repeat.
