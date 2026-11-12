# Walkthrough: Disk Usage Alert

## The plan
`df -P` prints one filesystem per line in a fixed column order. Read the
output, split every line into columns, strip the `%` from the capacity column,
and compare it with the limit. The only subtle parts are skipping things that
are not real disks and noticing when `df` itself breaks.

## Step by step
1. Validate LIMIT with a regex and a range check. The error message and
   exit status 2 mean "you called me wrongly":

   ```bash
   [[ $limit =~ ^[0-9]+$ ]] && (( limit >= 1 && limit <= 100 ))
   ```

2. Capture the table into a variable and test `df`'s exit status. Why capture
   first? In a pipeline `df -P | while ...` a failing `df` is easy to ignore:

   ```bash
   if ! table=$(df -P); then echo "df failed" >&2; exit 3; fi
   ```

3. Feed the table to a loop with a here-string (`<<< "$table"`). A lone
   `read -r _header` before the loop eats the title line. The loop itself splits
   each line into named columns:

   ```bash
   while read -r device _blocks _used _avail pct mount; do
   ```

   The leading underscore is a convention for "I do not use this one".

4. Skip everything but real devices: `[[ $device == /dev/* ]] || continue`.

5. Remove the percent sign with `${pct%\%}`, compare numerically with
   `(( pct >= limit ))`, print the alert and count it.

6. After the loop: exit 1 when there were alerts, otherwise print the
   all-clear line.

## Try it by hand
`df` in your workspace is a stub, so you can switch scenarios:
```
./solution.sh 90
FAKE_DF=busy ./solution.sh 90; echo $?
FAKE_DF=fail ./solution.sh 90; echo $?
```

## Alternative
A single `awk` command (`df -P | awk 'NR>1 && $1 ~ /^\/dev\//'`) is shorter, and
fine for one-liners. The Bash loop is easier to extend with more actions
per alert, such as logging or paging someone.
