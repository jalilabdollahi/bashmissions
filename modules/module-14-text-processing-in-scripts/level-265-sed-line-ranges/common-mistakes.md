# Common Mistakes

- **Forgetting -n.** `sed '/BEGIN backup/,/END backup/p' log` prints the whole log with the selected lines doubled. Add `-n`.
- **Using -n without p.** `sed -n '/A/,/B/' file` prints nothing at all: the range selects lines but no command prints them.
- **Expecting one block only.** The range re-opens after each end marker, so later blocks are printed too. If you want just the first, add `q` to stop after it: `sed -n '/A/,/B/{p;/B/q;}'`.
- **Patterns that match too much.** `/backup/,/backup/p` starts and ends on neighbouring lines. Use markers that are unique to the start and the end.
- **Mixing number and pattern ends carelessly.** `/A/,3p` stops at line 3, and if the match is after line 3 only that one line is printed. Keep both ends of the same kind unless you mean it.
