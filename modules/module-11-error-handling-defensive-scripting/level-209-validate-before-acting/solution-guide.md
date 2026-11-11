# Walkthrough: Validate Before Acting

## The plan
The starter does "check one, move one, check one, move one". If the third check
fails, two moves have already happened and cannot be undone by `exit 1`. We
separate the loop into two phases: a read-only pass that decides whether the whole
job is possible, and a second pass that carries it out.

## Step by step
1. Keep the usage check: no arguments means exit 2.

2. Phase 1 loops over every argument and only looks. For each bad one print a
   `missing: NAME` line and add to a counter, but do not leave yet:

   ```bash
   bad=0
   for f in "$@"; do
     if [[ ! -f $f ]]; then
       echo "missing: $f" >&2
       bad=$(( bad + 1 ))
     fi
   done
   ```

   `-f` is true only for regular files, so a folder named in the list is also
   reported. Quoting `"$@"` keeps names with spaces whole.

3. Decide once: `if (( bad > 0 )); then exit 1; fi`. Because nothing has been
   moved, and the `archive` folder has not even been created, a failed run leaves
   the world exactly as it found it.

4. Phase 2 acts. Everything has been verified, so `mkdir -p archive` and the `mv`
   loop run on known-good inputs. The count is simply `$#`.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
touch a.txt c.txt
./solution.sh a.txt b.txt c.txt; echo "exit=$?"   # missing: b.txt, nothing moved
ls                                                # a.txt and c.txt are still here
./solution.sh a.txt c.txt                         # archived 2 files
```

## Alternative
Making the whole thing "all or nothing" with a rollback (move back whatever was
moved when something fails) is possible but much more code and more things that
can fail. Validating first is simpler and just as safe whenever the checks can be
made before the action starts.
