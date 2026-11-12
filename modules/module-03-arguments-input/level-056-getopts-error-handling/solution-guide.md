# Walkthrough: getopts Error Handling

## The plan
Build on level 55 in three steps: take control of error reporting, handle the two
kinds of option mistake, and validate the required option after the loop.

## Building it
**Silent mode.** A colon as the *first* character of the option string tells
`getopts` to stay quiet and report problems through the loop variable instead:

```bash
while getopts ":h:p:q" opt; do
```

Here `h:` and `p:` take values, `q` is a switch.

**Two new branches.** In silent mode, `opt` can also be `?` or `:`:

| `$opt` | meaning | `$OPTARG` holds |
|---|---|---|
| `?` | unknown option letter | the letter, e.g. `x` |
| `:` | option needs a value but none was given | the option letter, e.g. `p` |

```bash
\?) echo "error: unknown option: -$OPTARG" >&2; exit 2 ;;
:)  echo "error: option -$OPTARG needs a value" >&2; exit 2 ;;
```

The question mark must be escaped (`\?`) because in a `case` pattern a bare `?`
means "any one character".

**Required option.** `getopts` cannot enforce that `-h` was given, so after the
loop use the guard from level 43:

```bash
[[ -z $host ]] && { echo "usage: solution.sh -h HOST [-p PORT] [-q]" >&2; exit 2; }
```

**Output.** Quiet mode prints just `host:port`; otherwise the full sentence.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
host=""
port=443
quiet="no"
while getopts ":h:p:q" opt; do
  case $opt in
    h) host=$OPTARG ;;
    p) port=$OPTARG ;;
    q) quiet="yes" ;;
    \?) echo "error: unknown option: -$OPTARG" >&2; exit 2 ;;
    :)  echo "error: option -$OPTARG needs a value" >&2; exit 2 ;;
  esac
done
[[ -z $host ]] && { echo "usage: solution.sh -h HOST [-p PORT] [-q]" >&2; exit 2; }
if [[ $quiet == "yes" ]]; then
  echo "$host:$port"
else
  echo "probing $host on port $port"
fi
```

## Try it by hand
```bash
./solution.sh -h anchovy -p 8443
./solution.sh -h eel -x ; echo "status=$?"
./solution.sh -h flounder -p ; echo "status=$?"
```

## Alternative
Without the leading colon, `getopts` prints its own message
(`illegal option -- x`) and sets `opt` to `?`. That works, but the wording differs
between systems and you cannot control it, so tools meant for other people use
silent mode.
