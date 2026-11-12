# Walkthrough: Log Levels and Filtering

## The plan
Severity is an order, and orders are easiest to handle as numbers. Give each
level word a number, convert the threshold once, then convert each line's first
word and compare.

## Step by step
1. An associative array is a lookup table from words to values. Number the
   levels so that smaller means more important:

   ```bash
   declare -A rank=([ERROR]=1 [WARN]=2 [INFO]=3 [DEBUG]=4)
   ```

2. Read the dial. `${LOG_LEVEL:-INFO}` falls back to INFO when the variable is
   not set. A key that is not in the table expands to nothing, so an empty
   test tells you the word is unknown. The `:-` inside the braces keeps
   `set -u` happy:

   ```bash
   threshold=${LOG_LEVEL:-INFO}
   [[ -n ${rank[$threshold]:-} ]] || { echo "unknown LOG_LEVEL: $threshold" >&2; exit 2; }
   ```

3. Loop over stdin. `IFS= read -r line` keeps each line exactly as it is. The
   first word is `${line%% *}`: remove the longest suffix that starts with a
   space.

4. Skip what you cannot rank (note on stderr), and print when the line's
   number is at most the threshold's:

   ```bash
   (( rank[$level] <= rank[$threshold] )) && printf '%s\n' "$line"
   ```

   With `set -e`, a failing `&&` list can end the script on the last line, so
   the complete solution uses an `if`.

## Try it by hand
```
printf 'INFO a\nERROR b\nDEBUG c\n' | LOG_LEVEL=WARN ./solution.sh
printf 'INFO a\n' | LOG_LEVEL=LOUD ./solution.sh; echo $?
```

## Alternative
A `case` statement with four branches would also work, but then every place
that compares levels needs its own copy of the order. One table, one number
comparison, and adding a TRACE level is a one-word change.
