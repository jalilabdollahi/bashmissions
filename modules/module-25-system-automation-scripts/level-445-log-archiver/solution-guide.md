# Walkthrough: Log Archiver

## The plan

Compressing a log is a tiny operation, but a destructive one: the original is
removed. So the script is a short pipeline of steps where each step only runs
if the previous one worked, and the original is the last thing to go.

## Building it

Validate the arguments. `[[ $days =~ ^[0-9]+$ ]]` rejects `soon` and `-5`
before they reach `find`. Check the directory exists.

Selecting files is a job for `find`: `-maxdepth 1` keeps it to the top folder,
`-type f` skips directories, `-name '*.log'` skips other files, and `-mtime
+30` means "modified more than 30 days ago". `find` lists in no particular
order, so pipe the list through `sort`. Read it with `while IFS= read -r path`
fed by process substitution `< <(...)`; that keeps the counters in the main
shell, whereas a pipe would run the loop in a subshell and lose them. Reading
whole lines also keeps names with spaces intact.

For each file build `out=$dir/archive/$name.gz`. If it exists, report a skip and
move on. Otherwise: `mkdir -p`, `gzip -c "$path" > "$out.partial"`, `gzip -t`
on the partial, `mv` it to its final name (a rename is atomic) and finally `rm`
the original. With `set -e`, if gzip or the test fails the script stops and the
log is still there.

## Complete solution

See answer.sh.

## Trying it by hand

```
mkdir logs; echo hi > logs/old.log; touch -t 202301010000 logs/old.log
./solution.sh logs 30; ls logs logs/archive
```

## Alternative

`gzip logs/old.log` compresses in place in one step, but it gives you no
`.partial` safety and no skip rule for an existing archive.
