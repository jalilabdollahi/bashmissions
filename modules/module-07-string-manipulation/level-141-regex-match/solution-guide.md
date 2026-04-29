# Guide for Regex Match

Goal: Use a regex to check whether the first argument is exactly three digits. Print `match` or `no match`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `[[ $str =~ regex ]]`.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str =~ ^[0-9]{3}$ ]]; then
  echo "match"
else
  echo "no match"
fi
```
