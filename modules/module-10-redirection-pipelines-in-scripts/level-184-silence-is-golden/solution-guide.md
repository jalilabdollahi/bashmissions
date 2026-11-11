# Walkthrough: Silence Is Golden

## The plan

We only want the verdict, which is encoded in the exit status. So run the tool
as an `if` condition and make its streams disappear.

## Step by step

An `if` runs a command and branches on its exit status: 0 means "true". That
means we do not need `$?` at all:

```bash
if probe-host "$host"; then
  echo "$host is up"
fi
```

That works, but `probe-host` still prints its chatter, so the script's output
is polluted. The black hole for that is `/dev/null`. Reading from it gives
immediate end-of-file; writing to it succeeds and keeps nothing.

```bash
probe-host "$host" > /dev/null 2>&1
```

You know this pair from the previous level: first stdout to the black hole,
then stderr copied onto stdout. Put it in the `if`:

```bash
if probe-host "$host" > /dev/null 2>&1; then
  echo "$host is up"
else
  echo "$host is down"
fi
```

The missing-argument check from the starter stays at the top.

## The complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh HOST" >&2
  exit 2
fi
host=$1
if probe-host "$host" > /dev/null 2>&1; then
  echo "$host is up"
else
  echo "$host is down"
fi
```

## Trying it by hand

```bash
./solution.sh anchovy
./solution.sh down-flounder
```

Remove the redirection once to see how much noise you were hiding.

## An alternative

`grep -q` and `command -v tool >/dev/null` follow the same idea. `grep -q`
silences itself, but a custom tool like `probe-host` has no quiet flag, so
`/dev/null` is the general answer.
