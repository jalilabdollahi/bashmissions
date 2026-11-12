# Walkthrough: Cron Inventory

## The plan

One table of everything that runs by itself. The work is classification: each
line of a crontab is a comment, an environment setting, a job with an
`@keyword` schedule, or a job with five time fields. Once the line is
classified, printing is trivial.

## Building it

Define a `row` function around `printf '%-10s %-17s %s\n'` and use it for the
header and for every data row, so the columns can never drift apart.

Loop over `"$dir"/*`. The glob is sorted by name, which gives the required
user order, and `*` does not match names starting with a dot. Skip anything that
is not a regular file. The user name is the file name: `${path##*/}`.

For each line (the `|| [[ -n $line ]]` keeps a final line without a newline),
first throw away what is not a job. A regex for blank-or-comment, and another
for `NAME=value`, with optional leading blanks, do that.

Then split. Peek at the first word with `read -r first rest`. If it starts with
`@` the schedule is that word and the command is the rest. Otherwise `read -r m
h dom mon dow command` takes five fields and the remainder: because `read` splits
on runs of blanks, tabs and doubled spaces vanish, and the schedule is rebuilt
with single spaces. If the command is empty the line was malformed: complain on
stderr and carry on.

Count jobs per user. A user with none gets the `-` / `(no jobs)` row; the others
add to the totals for the final line.

## Complete solution

See answer.sh.

## Trying it by hand

```
mkdir ct; printf '# hi\n0 3 * * * /bin/backup\n' > ct/root
./solution.sh ct
```

## Alternative

`awk` can classify and format in one program, but with per-file counters and the
stderr messages the shell loop stays easier to read.
