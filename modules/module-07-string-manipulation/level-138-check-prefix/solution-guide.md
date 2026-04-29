# Guide for Check Prefix

Goal: Print `yes` if the first argument starts with `pre`, otherwise print `no`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `[[ $str == prefix* ]]`.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
if [[ $str == pre* ]]; then
  echo "yes"
else
  echo "no"
fi
```
