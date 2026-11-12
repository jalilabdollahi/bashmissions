# Common Mistakes

- **Splitting the openssl line with `cut -d' '`.** `Mar  4` has two spaces, so the day is empty for single-digit dates.
  - Right: `read -r mon day time year zone <<< "${line#notAfter=}"`
- **Month `08` as octal.** `$(( 08 + 1 ))` is an error because the leading zero means octal.
  - Right: `$(( 10#$m ))`
- **Sorting as text.** `sort` puts `-9` and `100` in the wrong order against `14`.
  - Right: `sort -n`
- **Ignoring leap years.** Multiplying months by 30 or years by 365 drifts; February 2028 has 29 days.
  - Right: use a day-number formula that handles century and leap rules.
- **Letting one bad certificate abort the report.** A broken file under `set -e` hides every healthy line after it.
  - Right: `if ! line=$(openssl ...); then ...; continue; fi`
