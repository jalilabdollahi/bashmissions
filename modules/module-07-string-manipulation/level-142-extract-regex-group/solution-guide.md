# Guide for Extract Regex Group

Goal: Extract the name from `user:<name>` using a regex capture group and print `name=<name>`. If it does not match, print `no match`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `${BASH_REMATCH[1]}`.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str =~ ^user:([A-Za-z0-9_]+)$ ]]; then
  echo "name=${BASH_REMATCH[1]}"
else
  echo "no match"
fi
```
