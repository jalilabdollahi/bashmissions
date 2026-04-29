# Common Mistakes for Print Script Name

- Hard-coding `script: solution.sh`. The point is to *read* the script's name from `$0`, so this passes the test but skips the lesson.

- Using `$0` directly without `basename`. If the script is invoked as `./solution.sh` or `/full/path/solution.sh`, `$0` will include the path — the test expects the bare filename.

- Forgetting the inner quotes: `basename $0` breaks if the path has a space. The robust form is `basename "$0"`.

- Confusing `$0` with `$1`. `$0` is the script itself; `$1` is the first argument *after* the script name.

- Using `${0##*/}` is fine — Bash parameter expansion that strips everything up to the last `/`, equivalent to `basename "$0"` and faster (no subprocess).
