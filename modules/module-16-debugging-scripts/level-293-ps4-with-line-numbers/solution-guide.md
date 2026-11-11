# Walkthrough: PS4 with Line Numbers

## The plan
A trace is more useful when each line says where it came from. The `+ ` prefix
is stored in `PS4`, and Bash evaluates PS4 like a string with variables in it
for every single trace line. Put `$LINENO` in it and we get line numbers for free.

## Step by step
1. First see the plain trace. Add `set -x` and run `./solution.sh a.txt nope`:

   ```
   + for f in "$@"
   + [[ -e a.txt ]]
   ```

   Nine files and nine identical tests would be impossible to tell apart.

2. Set PS4 before turning tracing on:

   ```bash
   PS4='+ L${LINENO}: '
   set -x
   ```

3. Run again:

   ```
   + L7: for f in a.txt nope
   + L8: [[ -e a.txt ]]
   + L9: echo 'found: a.txt'
   ```

   (Your numbers follow your own layout.)

4. The quoting is the heart of it. With `PS4="+ L${LINENO}: "` the shell
   expands `${LINENO}` right away, while assigning, and every trace line would
   show the same number. Single quotes keep the text literal, and Bash expands it
   later, once per traced command.

## Complete solution
```bash
#!/usr/bin/env bash
PS4='+ L${LINENO}: '
set -x

for f in "$@"; do
  if [[ -e $f ]]; then
    echo "found: $f"
  else
    echo "missing: $f"
  fi
done
```

## Try it by hand
```bash
touch a.txt
./solution.sh a.txt nope 2>&1 | head
```

## Alternative
You can set PS4 from outside without editing the script:
`PS4='+ L${LINENO}: ' bash -x solution.sh a.txt`. That is the fastest way to
debug somebody else's script, but the version inside the file travels with it.
