# Walkthrough: Fix the Off-by-One

## The plan
Debugging is a short loop: reproduce the problem, shrink it, locate the line,
make the smallest change, run the same reproduction again. Resist the urge to
rewrite.

## Step by step
1. Reproduce. The bug report says that with five backups and KEEP=3, two are
   left:

   ```bash
   printf 'mon\ntue\nwed\nthu\nfri\n' | ./solution.sh 3
   ```

   Output: three `delete:` lines and `kept: 2`. Expected: two deletes, `kept: 3`.

2. Narrow it down. Only the loop deletes things, so run it under trace:

   ```bash
   printf 'mon\ntue\nwed\nthu\nfri\n' | bash -x ./solution.sh 3
   ```

   You see `echo 'delete: mon'`, `tue`, `wed`: three iterations where two were
   wanted.

3. Do the arithmetic. Five backups, keep three, so two are deleted: indexes 0 and
   1. The loop condition is `i <= total - keep`, that is `i <= 2`, which visits
   indexes 0, 1 and 2: one too many. A loop that must run `n` times from
   index 0 stops when `i < n`.

4. Fix just that character:

   ```bash
   for (( i = 0; i < total - keep; i++ )); do
   ```

5. Check the edges. KEEP=0 with two names: `i < 2` deletes both. KEEP larger
   than the list: `total - keep` is negative, no iterations. Empty input: the
   array is empty and nothing happens. (With the old `<=`, KEEP=0 even read
   `files[2]` past the end and `set -u` aborted the script.)

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
keep=$1
mapfile -t files
total=${#files[@]}
deleted=0
for (( i = 0; i < total - keep; i++ )); do
  echo "delete: ${files[i]}"
  deleted=$(( deleted + 1 ))
done
echo "kept: $(( total - deleted ))"
```

## Try it by hand
```bash
printf 'a\nb\nc\nd\ne\n' | ./solution.sh 3
printf 'a\nb\n' | ./solution.sh 0
./solution.sh 2 < /dev/null
```

## Alternative
Print the intermediate numbers (`echo "i=$i total=$total keep=$keep" >&2`) instead
of using `bash -x`. Tracing is faster because you do not edit the code at all.
