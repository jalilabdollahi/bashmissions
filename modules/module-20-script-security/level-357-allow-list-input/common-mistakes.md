# Common Mistakes

- **Substring match.** Wrong: `grep -q "$service" fixtures/allowed-services.txt` accepts `we`, `a` and `""`. Right: `grep -Fxq -- "$service" ...` matches only a whole line.
- **Regex match on user text.** Wrong: `grep -xq "$service" list` lets `.*` through. Right: add `-F` so the value is plain text.
- **Unquoted pattern in `[[ ]]`.** Wrong: `[[ $service == $allowed ]]` treats `$allowed` as a glob. Right: `[[ $service == "$allowed" ]]`.
- **Writing before checking.** Wrong: appending to `queue.txt` and validating afterwards leaves the bad entry behind. Right: refuse first, write last.
- **Forgetting `--`.** Wrong: `grep -Fxq "$service" list` with `service=-v` makes grep read a flag. Right: `grep -Fxq -- "$service" list`.
