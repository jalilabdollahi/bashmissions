# Walkthrough: A log() Helper

## The plan
Two small functions: `level_num` turns a level name into a number, and `log` uses
it to compare a message's level with the threshold. The main script then just
logs what it does.

## Building it
Numbers first, so levels compare with `>=`:

```bash
level_num() {
  case $1 in
    DEBUG) echo 0 ;;
    INFO)  echo 1 ;;
    WARN)  echo 2 ;;
    ERROR) echo 3 ;;
    *)     echo 1 ;;
  esac
}
```

`log` removes the level from the arguments with `shift` and treats the rest as the
message. `${LOG_LEVEL:-INFO}` is the threshold from the environment, INFO when
unset:

```bash
log() {
  local level=$1
  shift
  if (( $(level_num "$level") >= $(level_num "${LOG_LEVEL:-INFO}") )); then
    echo "[$level] $*" >&2
  fi
}
```

The decisions in the main part are an ordinary `if`/`elif`, with the highest
threshold first so 95 is reported as ERROR only, not WARN also:

```bash
if (( pct >= 90 )); then
  log ERROR "disk almost full: $pct%"
elif (( pct >= 75 )); then
  log WARN "disk filling up: $pct%"
fi
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

# level_num NAME -> prints 0..3 so levels can be compared as numbers
level_num() {
  case $1 in
    DEBUG) echo 0 ;;
    INFO)  echo 1 ;;
    WARN)  echo 2 ;;
    ERROR) echo 3 ;;
    *)     echo 1 ;;     # unknown names behave like INFO
  esac
}

# log LEVEL MESSAGE...  - print "[LEVEL] message" on stderr if LEVEL is important enough
log() {
  local level=$1
  shift
  if (( $(level_num "$level") >= $(level_num "${LOG_LEVEL:-INFO}") )); then
    echo "[$level] $*" >&2
  fi
}

pct=$1
log DEBUG "raw argument: $pct"
log INFO "checking disk usage"
if (( pct >= 90 )); then
  log ERROR "disk almost full: $pct%"
elif (( pct >= 75 )); then
  log WARN "disk filling up: $pct%"
fi
echo "checked: $pct%"
```

## Try it by hand
```bash
./solution.sh 80
LOG_LEVEL=DEBUG ./solution.sh 80
LOG_LEVEL=ERROR ./solution.sh 80
./solution.sh 80 2>/dev/null     # only the stdout line remains
```

## Alternative
Write one `log_info`, `log_warn`, `log_error` function each. Easy to read, but the
threshold logic is repeated and every new level costs a new function. A single
`log LEVEL` function scales better.
