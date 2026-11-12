# Walkthrough: Migrate an Old Format

## The plan

A migration tool is judged by what it refuses to do as much as by what it converts.
So we put guards first: right number of arguments, readable input, not already in the
new format, and no existing output file. Only then do we convert, and we convert in
memory so that the file on disk is written once, complete, at the end.

## Building it

The guards are plain `if`s with the exit codes from the objective. The "already v2"
check is the interesting one: it makes the tool idempotent (running it twice is the
same as running it once). Find the first line that is not blank and not a comment, and
compare it with `version=2`. A `break` after the first real line is enough; the
header can only be the first thing in the file.

The conversion loop trims every line and decides what it is: empty lines vanish,
comments are kept verbatim, lines without a colon are reported with their number and
skipped. For the rest, split at the FIRST colon, because values such as
`127.0.0.1:5432` contain colons themselves:

```bash
name=$(trim "${line%%:*}")
value=$(trim "${line#*:}")
```

A `case` on the name maps the four known settings. `Debug` is a value migration, not
just a rename: `on` becomes `log_level=debug`, everything else `log_level=info`.
`Timeout` strips an old unit with `${value%s}`. The `*)` branch warns and keeps the
setting under a lowercase name, because silently dropping a customer's setting is
worse than a warning.

Results go into an array with `out+=("port=$value")`. After the loop, one brace group
writes the header and the array to the new file with a single `>`. The count is
printed last.

## Trying it by hand

```
printf 'Listen: 80\nDebug: on\n' > old.conf
./solution.sh old.conf new.conf && cat new.conf
./solution.sh old.conf new.conf       # refuses: new.conf exists
```

## Alternative

You could pipe the old file through `sed -E` rules. That works for pure renames, but the
value changes (`on` to `debug`, units), the warnings and the line numbers make a
loop clearer.
