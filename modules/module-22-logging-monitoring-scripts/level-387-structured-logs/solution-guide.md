# Walkthrough: Structured Logs

## The plan
A structured log line is a row of `key=value` pairs separated by spaces. Humans
can still read it, and `grep level=error`, `awk` or Priya's search tool can pick
fields apart reliably. The script builds the row in a variable: fixed fields
first (time, level, msg), then whatever extra pairs the caller passed.

## Step by step
1. Check the argument count, save the level in lowercase, then `shift 2` so
   that `"$@"` holds only the extra fields:

   ```bash
   level=${1,,}
   msg=$2
   shift 2
   ```

2. Validate the level with `case`. Reject early, with the message on stderr:

   ```bash
   case $level in debug|info|warn|error) ;; *) echo "bad level: $level" >&2; exit 2;; esac
   ```

3. Get the time. `NOW` lets tests (and replays of old events) set the clock;
   otherwise ask `printf -v` to store a formatted time in a variable:

   ```bash
   printf -v stamp '%(%Y-%m-%dT%H:%M:%SZ)T' -1
   ```

4. Escape quotes in the message, because a stray `"` would end the quoted
   value early and break every parser downstream:

   ```bash
   msg=${msg//\"/\\\"}
   ```

5. For each extra field, split at the first `=` (`${field%%=*}` and
   `${field#*=}`), quote the value if it holds a space, and append with `+=`.

6. Print once with `printf '%s\n'`.

## Try it by hand
```
NOW=2026-03-01T10:00:00Z ./solution.sh warn "disk is filling" host=eel pct=91
./solution.sh info "invoice sent" "site=Harbour Bakery"
```

## Alternative
Print each field with its own `printf` call. It works, but then the line can be
cut in half by another process writing in between, and the quoting logic ends
up duplicated. One complete line, written once, is the safer habit.
