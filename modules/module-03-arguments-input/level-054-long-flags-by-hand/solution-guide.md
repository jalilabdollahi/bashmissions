# Walkthrough: Long Flags by Hand

## The plan
Treat the arguments as a queue. Look at the front item, handle it, remove it, and
repeat until the queue is empty. After the loop, validate the result and report.

## Building it
Defaults first, so the final `echo` always has something to print:

```bash
customer=""
plan="basic"
dry_run="no"
```

The loop runs while arguments remain (`$#` is the count, `-gt` means "greater
than"). Inside, `case` compares the front argument `$1` with patterns:

```bash
while [[ $# -gt 0 ]]; do
  case $1 in
    --customer) customer=${2:-}; shift 2 ;;
    --plan)     plan=${2:-};     shift 2 ;;
    --dry-run)  dry_run="yes";   shift ;;
    *)          echo "error: unknown option: $1" >&2; exit 2 ;;
  esac
done
```

The important lines are the `shift`s. A flag with a value occupies two slots
(`--plan harbour`), so it uses `shift 2`; a switch occupies one. Forget a shift and
the loop never ends, because `$1` never changes.

`${2:-}` keeps `set -u` quiet if the value is missing (`--plan` as the last word).

After the loop, the required flag is checked with the `-z` guard from level 51.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
customer=""
plan="basic"
dry_run="no"
while [[ $# -gt 0 ]]; do
  case $1 in
    --customer) customer=${2:-}; shift 2 ;;
    --plan)     plan=${2:-};     shift 2 ;;
    --dry-run)  dry_run="yes";   shift ;;
    *)          echo "error: unknown option: $1" >&2; exit 2 ;;
  esac
done
[[ -z $customer ]] && { echo "usage: solution.sh --customer NAME [--plan PLAN] [--dry-run]" >&2; exit 2; }
echo "customer=$customer plan=$plan dry_run=$dry_run"
```

## Try it by hand
```bash
./solution.sh --customer "Tidewater Books" --plan harbour --dry-run
./solution.sh --dry-run --customer Dory
./solution.sh --customer Dory --colour blue
```

## Alternative
`getopts` (the next level) handles short flags like `-v` with less code, but it
cannot parse `--long` names. For long flags this hand-rolled loop is the
standard approach in Bash.
