# Walkthrough: Uptime Probe Report

## The plan
Three small parts: read the list safely, run the right probe for each kind, and turn the outcome into one line plus two counters. The summary and the exit status come last.

## Steps
1. Validate the argument and the file (`[[ -r $file ]]`); both problems exit 2.
2. Two helper functions keep the bookkeeping in one place: `report_up NAME` and `report_down NAME REASON` print the line and increase `up` or `down`.
3. Read the list with `while read -r kind name a b; do ... done < "$file"`. The `-r` stops backslashes being interpreted. `read` splits on whitespace, so for `tcp mail host 25` the variables are `tcp`, `mail`, `host`, `25`; for `http web URL` the URL lands in `a`.
4. Skip blank lines and comments: `case $kind in ''|'#'*) continue ;; esac`.
5. Probe:
   - http: get the code with `curl -s -o /dev/null -w '%{http_code}' --max-time 3 "$a"` and add `|| true`, because a timeout makes curl fail while still printing `000`. Then classify with `case`: `000` no connection, `[23]??` up, anything else `HTTP code`.
   - tcp: `if nc -z -w 2 "$a" "$b"` decides between up and port closed.
   - anything else is a configuration mistake and is reported as such, loudly.
6. Print the summary and exit 1 if `down` is above zero.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh PROBE_FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 2
fi

up=0
down=0
report_up()   { echo "UP $1"; up=$((up + 1)); }
report_down() { echo "DOWN $1 ($2)"; down=$((down + 1)); }

while read -r kind name a b; do
  case $kind in ''|'#'*) continue ;; esac
  case $kind in
    http)
      code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 "$a") || true
      case $code in
        000)            report_down "$name" "no connection" ;;
        [23][0-9][0-9]) report_up "$name" ;;
        *)              report_down "$name" "HTTP $code" ;;
      esac
      ;;
    tcp)
      if nc -z -w 2 "$a" "$b"; then report_up "$name"; else report_down "$name" "port closed"; fi
      ;;
    *) report_down "$name" "unknown type $kind" ;;
  esac
done < "$file"

echo "summary: $up up, $down down"
if (( down > 0 )); then
  exit 1
fi
```

## Try it by hand
Create `probes.txt` with a few of the lines from the objective, then:
```
./solution.sh probes.txt; echo "exit=$?"
FAKE_DOWN=www.lanternfish.example ./solution.sh probes.txt
```

## Alternative
Printing a table with `printf '%-10s %s\n'` aligns the columns for people. The plain `UP name` form is easier for another script (or `grep DOWN`) to consume, so this level keeps it simple.
