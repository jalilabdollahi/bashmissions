# Walkthrough: Delete and Squeeze

## The plan
There are two clean-ups. One removes a character (the carriage return); the
other collapses repeats of a character (the spaces). `tr` has a mode for each,
and a pipe runs them one after the other.

## Step by step
1. A Windows text file ends each line with two characters: carriage return
   (`\r`) then newline (`\n`). Unix tools only expect the newline, so the `\r`
   ends up glued to the last word, invisible in the terminal but fatal to an
   import script that compares strings. Delete it:

   ```bash
   tr -d '\r'
   ```

   `-d` deletes every character in the set, anywhere in the input.

2. Squeeze the spaces. With `-s`, any run of the same character from the set
   is replaced by one copy:

   ```bash
   tr -s ' '
   ```

   Only the characters you list are squeezed. Tabs, letters and newlines are
   untouched, so empty lines stay empty lines.

3. Join the steps. `tr` reads standard input, so the first one's output feeds
   the second:

   ```bash
   tr -d '\r' | tr -s ' '
   ```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
tr -d '\r' | tr -s ' '
```

## Try it by hand
```bash
printf 'a   b\r\n' | ./solution.sh | od -c      # no \r left
printf 'a   b\r\n' | tr -d '\r' | wc -c
printf 'aabbcc\n' | tr -s 'a-c'                  # abc
printf 'hello world\n' | tr -d 'aeiou'           # hll wrld
```

## Alternative
`tr -ds '\r' ' '` can delete and squeeze in one call, but it uses two sets with different
meanings, which is easy to misread. Two small tr commands in a pipe are clearer. `sed 's/\r$//'` also removes a
trailing CR, but `\r` in sed is not portable to every system, while `tr -d '\r'` works the same
everywhere.
