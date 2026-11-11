# Common Mistakes

- **Fixing the symptom.** Wrong: change the last line to `kept: $(( total - deleted + 1 ))`, which makes the number look right but still deletes the wrong backup. Right: fix the loop; the summary was correct all along.
- **Subtracting one from the wrong side.** Wrong: `i <= total - keep - 1` also works, but `i < total - keep - 1` is another off-by-one. If you change the number rather than the operator, re-run the edge cases.
- **Testing only the example from the bug report.** Five backups and KEEP=3 pass after almost any change. KEEP=0, exactly KEEP and an empty list are the inputs that catch the next bug.
- **Rewriting the script.** A larger change brings new bugs and hides which line was at fault. Change the single character, then compare.
- **Confusing the array length with the last index.** `${#files[@]}` is 5 for five items, but the last valid index is 4. Reading `files[5]` yields an empty value, or an "unbound variable" error under `set -u`.
