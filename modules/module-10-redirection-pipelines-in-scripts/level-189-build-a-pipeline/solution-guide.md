# Walkthrough: Build a Pipeline

## The plan

Think assembly line. Each station does one tiny job and passes its result
to the next.

1. keep only 404 lines (`grep`)
2. keep only the first field, the address (`cut`)
3. bring equal addresses together (`sort`)
4. count each group (`uniq -c`)
5. biggest count first (`sort -rn`)
6. top three (`head`)
7. reformat as `address: count` (`awk`)

## Step by step

Build it one stage at a time and look at the output after each addition. That
is how everyone writes pipelines.

```bash
grep -E '" 404 ' access.log
grep -E '" 404 ' access.log | cut -d' ' -f1
... | sort | uniq -c
... | sort -rn | head -n 3
```

Why the odd-looking `'" 404 '`? The status code is the field right after the
closing quote of the request. Searching only for `404` would also match a
file size of 404 or a path like `/page404`, which one of the tests includes.

`uniq -c` prefixes each line with a padded count, so last, `awk` swaps the
columns: `awk '{ print $2 ": " $1 }'`.

Next, the corner cases. With `set -o pipefail`, a failing stage fails the whole
pipeline. `grep` exits 1 when nothing matches, so wrap it: `{ grep ... || true; }`.
Then test the result: if it is empty, print `no 404 responses`.

## The complete solution

See answer.sh: a file check, the pipeline stored in `top`, and a final
`if [[ -z $top ]]`.

## Trying it by hand

```bash
printf '10.0.0.1 - - [x] "GET / HTTP/1.1" 404 1\n' > t.log
./solution.sh t.log
```

## An alternative

A single `awk` program could count and rank in one process. It is faster on a
huge log, but the pipeline is easier to read, to debug stage by stage, and to
change. The pipeline is the one to learn first.
