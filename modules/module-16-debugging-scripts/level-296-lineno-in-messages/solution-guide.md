# Walkthrough: LINENO in Messages

## The plan
Two checks, two error messages, and each message must say which line of the
script produced it. `$LINENO` is a variable Bash updates before every command,
so we let Bash do the counting.

## Step by step
1. Test the file with `[[ ! -e $1 ]]` (does not exist) and, after that,
   `[[ ! -s $1 ]]` (exists but has size zero). The order matters: an empty
   file passes `-e`.

2. In the first block write the message to stderr, with the line number inside:

   ```bash
   echo "error (line $LINENO): file not found: $1" >&2
   exit 1
   ```

3. In the second block do the same with the other text and `exit 2`.

4. Run it with each situation:

   ```
   $ ./solution.sh ghost.conf
   error (line 7): file not found: ghost.conf
   $ : > blank.conf; ./solution.sh blank.conf
   error (line 12): file is empty: blank.conf
   ```

   The two numbers differ because they are the lines of two different echos.
   Open your file at line 7 and you land exactly on the message. If you add a
   comment above, the numbers move with it; typed numbers would not.

## Complete solution
```bash
#!/usr/bin/env bash
set -u
if [[ ! -e $1 ]]; then
  echo "error (line $LINENO): file not found: $1" >&2
  exit 1
fi
if [[ ! -s $1 ]]; then
  echo "error (line $LINENO): file is empty: $1" >&2
  exit 2
fi
echo "config ok: $1"
```

## Try it by hand
```bash
echo "listen=8080" > web.conf
./solution.sh web.conf; ./solution.sh nope; echo "status=$?"
```

## Alternative
A shared `die()` function keeps messages short, but `$LINENO` inside the function
reports the line of the `echo` *inside die*, not of the caller. To get the
caller's line you would pass `$LINENO` as an argument (`die "$LINENO" "..."`) or
read `BASH_LINENO`, which the next levels cover.
