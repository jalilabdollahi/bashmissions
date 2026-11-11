# Walkthrough: Usage and --help

## The plan
One function holds the help text. The script decides, before doing any real work,
whether the caller asked for help (stdout, status 0), made a mistake (stderr, status 2)
or gave valid input (do the job).

## Building it
First the function. A quoted here-document keeps the text exactly as written:

```bash
usage() {
  cat <<'TXT'
Usage: ticket.sh CUSTOMER SUBJECT
Prints a one-line ticket stub.
TXT
}
```

Then the help flag. `${1:-}` is "the first argument, or empty if there is none";
without it `set -u` would stop the script before we got to the argument count.

```bash
case "${1:-}" in
  -h|--help) usage; exit 0 ;;
esac
```

Then the argument count. Number comparisons use `-ne` inside `[ ]`:

```bash
if [ "$#" -ne 2 ]; then
  usage >&2
  exit 2
fi
```

Exit status 2 is the traditional "you invoked me wrongly"; 1 is kept for "I tried
and failed".

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
usage() { ... }
case "${1:-}" in -h|--help) usage; exit 0 ;; esac
if [ "$#" -ne 2 ]; then usage >&2; exit 2; fi
echo "ticket for $1: $2"
```

## Try it
```
./solution.sh --help
./solution.sh Harbour            # usage on stderr
./solution.sh Harbour "No power" # ticket for Harbour: No power
./solution.sh Harbour "No power" 2>/dev/null; echo $?
```

## Alternative
Printing usage with a series of `echo` lines works too, but a here-document is
easier to edit and shows the output shape at a glance.
