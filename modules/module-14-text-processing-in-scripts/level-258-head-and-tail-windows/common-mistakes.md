# Common Mistakes

- **Reading `tail -n 3` as "from line 3".** That prints the last three lines. From line 3 on is `tail -n +3`.
- **Off by one in the second step.** To get lines 3 to 5, `head -n 5 | tail -n +3` is correct. `tail -n +2` would start at line 2, and `tail -n +4` would lose line 3.
- **Putting the filters in the wrong order.** `tail -n +"$first" "$file" | head -n "$last"` counts LAST from the new start, so lines 3 to 5 would give lines 3 to 7. Cut at the end first, then at the start.
- **Using LAST as a count.** `head -n 5` takes five lines, but the window 3..5 has only three. The two options do different jobs; do not pass the same number to both.
- **Quoting.** Leaving `$file` unquoted breaks on `my log.txt`. Use `"$file"` for every path.
