# Walkthrough: Timestamped Log Lines

## The plan
A log line needs two things: when, and what. The message is just the
arguments after the first one. The time is the interesting part: Bash can
format any epoch itself, so the script never needs to start `date`.

## Step by step
1. Refuse bad calls first. Fewer than two arguments, or a first argument that is
   neither `now` nor digits, gets the usage message on stderr and exit status 2:

   ```bash
   usage() { echo "usage: solution.sh WHEN MESSAGE..." >&2; exit 2; }
   [[ $# -ge 2 ]] || usage
   ```

2. Take WHEN off the argument list with `shift`, so `$*` now holds only the
   message words:

   ```bash
   when=$1
   shift
   ```

3. Translate the word `now` into the number `-1`. In `printf '%(...)T'`, `-1`
   means "the current time":

   ```bash
   if [[ $when == now ]]; then when=-1
   elif [[ ! $when =~ ^[0-9]+$ ]]; then usage
   fi
   ```

4. Print. The `%(...)T` conversion takes a strftime format between the
   parentheses and the epoch as its argument:

   ```bash
   printf '%(%Y-%m-%dT%H:%M:%SZ)T %s\n' "$when" "$*"
   ```

## Try it by hand
```
./solution.sh 1772359200 snapshot finished
./solution.sh now disk check done
./solution.sh yesterday hello; echo $?
```

## Alternative
`date -u +%Y-%m-%dT%H:%M:%SZ` gives the same text, but it starts a new
process for every log line, and the options for formatting a given epoch differ
between Linux and macOS. The builtin is faster and behaves the same everywhere.
