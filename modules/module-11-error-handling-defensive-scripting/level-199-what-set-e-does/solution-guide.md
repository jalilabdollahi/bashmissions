# Walkthrough: What set -e Does

## The plan
Two requirements pull in opposite directions: stop on a failed `cp`, but survive
a `grep` that finds nothing. `set -e` gives us the first; knowing its exceptions
gives us the second.

## Step by step
1. Add the tripwire as the second line of the script:

   ```bash
   set -e
   ```

   From now on, any plain command that returns non-zero ends the script, and the
   script's exit status is that command's status.

2. Handle the grep. If we wrote a bare `grep -q FATAL "$1"`, a clean log would
   give status 1 and set -e would kill the script before it could print anything.
   Bash does not apply errexit to a command that is being *tested*: the condition
   of `if`, `while` or `until`, anything after `!`, and every part of an `&&` or
   `||` list except the last one.

   ```bash
   if grep -q FATAL "$1"; then
     echo "fatal lines present"
   else
     echo "no fatal lines"
   fi
   ```

3. Keep the copy unguarded. When `archive/` is missing, `cp` fails, set -e fires,
   and "done" is never printed. That is exactly the point.

## Complete solution
```bash
#!/usr/bin/env bash
set -e
echo "start"
if grep -q FATAL "$1"; then
  echo "fatal lines present"
else
  echo "no fatal lines"
fi
cp "$1" archive/log.copy
echo "done"
```

## Try it by hand
```bash
mkdir archive; printf 'FATAL x\n' > a.log
./solution.sh a.log; echo "exit=$?"
rmdir archive; ./solution.sh a.log; echo "exit=$?"
```

## Alternative
`grep -q FATAL "$1" && echo "fatal lines present" || echo "no fatal lines"` also
survives set -e, but if the first `echo` ever failed the second would run too.
`if/else` says exactly what it means.
