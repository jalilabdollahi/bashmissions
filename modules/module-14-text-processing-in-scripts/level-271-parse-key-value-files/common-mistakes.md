# Common Mistakes

- **Using cut for the value.** `cut -d= -f2` drops everything after a second `=`, so `url=a?b=1` becomes `a?b`. With `IFS='=' read -r key value` the value keeps the rest.
- **Setting IFS globally.** `IFS='='` on a line of its own changes word splitting for the rest of the script. Put it in front of `read` so it applies only there.
- **Forgetting -r.** Without it, `path=C:\temp\new` loses its backslashes. Use `read -r`.
- **Missing the last line.** A file ending without a newline loses its final entry in a plain `while read`. Add `|| [[ -n $key ]]` to the condition.
- **Stopping at the first match.** Config files often override earlier lines, so `break` after the first hit returns the wrong value. Keep reading and let the last one win.
