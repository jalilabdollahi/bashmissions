# Common Mistakes

- **A bare -i.** `sed -i 's/a/b/' f` works on Linux but fails on macOS with "invalid command code". Use `-i.bak`.
- **A space before the suffix.** `sed -i .bak ...` gives the suffix as a separate argument on GNU, which then treats `.bak` as the script. Attach it: `-i.bak`.
- **Single quotes around variables.** `sed -i.bak 's/$old/$new/g' "$file"` looks for a literal `$old`. The program must be in double quotes for the shell to fill it in.
- **Forgetting g.** `s/anchovy/flounder/` changes only the first match on each line, so `old-db old-db.local` ends up half changed.
- **Redirecting onto the input.** `sed 's/a/b/' f > f` empties `f` before sed reads it. Use `-i.bak`, or write a new file and `mv` it.
