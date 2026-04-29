# Guide for Split String to Array

Goal: Split the first argument on commas into an array and print `count=N first=<first> last=<last>`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `IFS` split.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

IFS=, read -r -a parts <<< "$1"
last_index=$((${#parts[@]} - 1))
printf 'count=%s first=%s last=%s\n' "${#parts[@]}" "${parts[0]}" "${parts[$last_index]}"
```
