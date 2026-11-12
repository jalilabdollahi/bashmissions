# Walkthrough: Is the Port Open?

## The plan
For each port run `nc` in scan mode and let its exit status decide the line to print. Count the closed ones, exit non-zero if there were any.

## Steps
1. We need a host and at least one port, so check `$# -lt 2`.
2. `host=$1; shift`. Now `"$@"` holds only ports.
3. Test each port in an `if`:
   ```bash
   if nc -z -w 2 "$host" "$port"; then
   ```
   `-z` connects and immediately hangs up; nothing is sent. `-w 2` is the timeout. Without it, a host whose firewall silently drops packets would hold the script for as long as the system's TCP timeout (minutes).
4. Because the command is the `if` condition, a non-zero exit is just "false", and `set -e` is not triggered.
5. Print `open` or `closed`, keep a counter, and exit 1 at the end if any port was closed.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh HOST PORT..." >&2
  exit 2
fi
host=$1
shift

closed=0
for port in "$@"; do
  if nc -z -w 2 "$host" "$port"; then
    echo "$host:$port open"
  else
    echo "$host:$port closed"
    closed=$((closed + 1))
  fi
done

if (( closed > 0 )); then
  exit 1
fi
```

## Try it by hand
```
./solution.sh mail.lanternfish.example 25 587 993
./solution.sh blackhole.lanternfish.example 22
cat .calls.log
```
Try the blackhole host without `-w`: the pretend nc tells you what a real one would do (wait).

## Alternative
Bash can open a TCP connection by itself: `(exec 3<>/dev/tcp/$host/$port) 2>/dev/null`. It needs no extra tool, but there is no built-in timeout, and it only exists in bash, which is why `nc -z -w` is the usual choice.
