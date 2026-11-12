# Walkthrough: Redefining a Function

## The plan
The library's `report` builds its sentence from two helper functions. We keep
`report` and swap the helpers, which gives us a customised report with no copying.

## Building it
First read the library:

```bash
cat fixtures/defaults.sh
```

`report` calls `notify` and `retention_days` by name every time it runs. Bash looks
the name up at the moment of the call, so whichever definition is current at that
moment is used.

Source the library, then define the two replacements. They must come after the
`source` line, otherwise sourcing would overwrite them:

```bash
source fixtures/defaults.sh

retention_days() {
  echo 90
}

notify() {
  echo "[ops-desk] $*"
}
```

Finally call the library's own function:

```bash
report "$SITE"
```

`$*` joins all of notify's arguments into a single string, which suits a message
that arrives as one quoted argument.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
SITE=${1:-}
if [[ -z $SITE ]]; then
  echo "usage: solution.sh SITE" >&2
  exit 2
fi
source fixtures/defaults.sh
retention_days() { echo 90; }
notify() { echo "[ops-desk] $*"; }
report "$SITE"
```

## Try it by hand
```bash
./solution.sh eel-street
```
Move the two overrides above the `source` line and run again: the output goes back to
`notice: ... 30 days`.

## Alternative
Copy `defaults.sh`, edit it, and use the copy. That works until the platform team
improves the original, and then you silently miss every fix. Overriding keeps only
the differences in your file.
