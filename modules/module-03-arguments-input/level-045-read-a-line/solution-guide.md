# Walkthrough: Read a Line

## The plan
There is no `$1` this time. The data comes in on standard input, the stream a
pipe (`|`) or a keyboard feeds into your script. `read` is the built-in command
that takes one line off that stream and stores it in a variable.

## Building it
```bash
read title
```

Without `-r`, `read` treats a backslash as an escape character, so `C:\backups`
turns into `C:backups`. For almost every real script you want the raw text:

```bash
read -r title
```

Then use the variable like any other:

```bash
echo "paging on-call about: $title"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
read -r title
echo "paging on-call about: $title"
```

## Try it by hand
```bash
echo 'restore C:\backups\nightly failed' | ./solution.sh
printf 'first\nsecond\n' | ./solution.sh      # only "first"
./solution.sh                                  # waits for you to type; press Enter
```
At a terminal with no pipe the script waits for typing. Press Ctrl-D to send an
end-of-input if you want to leave without a line.

## Alternative
`title=$(head -n 1)` also gets a line, but it starts a separate process for
something Bash does itself, and it gives you no way to tell "empty line" from "no
input". Stick to `read -r`.
