# Walkthrough: Reload on Signal

## The plan

A long-running program reads its configuration at start, then waits. When an
administrator edits the file and sends `HUP` (hang up, historically; now simply
"reload"), the program re-reads the file. Two rules make this safe: use the same
code to read the config in both places, and never replace the live settings with
something you have not validated. Our script plays all the parts so that the run is
deterministic.

## Building it

Start with `read_level`. It loops through the file the way earlier levels did
(trimmed `key=value`, unknown names ignored), remembers the value of the last
`level` line, and finishes with a `case`: valid levels are printed, anything else is
`return 1`. A function that either prints a value or fails can be used in `if`.

Load once at the start:

```bash
if ! level=$(read_level); then
  echo "no valid level in $config" >&2; exit 1
fi
echo "loaded: level=$level"
```

The handler is a function. It reads into a separate variable first, so a broken file
cannot damage the active setting:

```bash
reload() {
  local fresh
  if fresh=$(read_level); then
    level=$fresh; echo "reloaded: level=$level"
  else
    echo "reload rejected: keeping level=$level" >&2
  fi
}
trap reload HUP
```

Install the trap before the signal can arrive. Then act as the administrator:
append the new line (the "last one wins" rule makes appending a valid edit) and
signal yourself. `$$` is the script's own process id, and Bash runs the trap as soon
as the `kill` command returns, so the output order is fixed:

```bash
printf 'level=%s\n' "$newlevel" >> "$config"
kill -HUP $$
echo "done: level=$level"
```

## Trying it by hand

```
printf 'level=info\n' > t.conf; ./solution.sh t.conf debug; cat t.conf
```

## Alternative

Real daemons often poll the file's modification time instead of using a signal. That
needs no cooperation from the admin, but it wastes wakeups and can read a half
written file; the signal says "I am done editing" explicitly.
