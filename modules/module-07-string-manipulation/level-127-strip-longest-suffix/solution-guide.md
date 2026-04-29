# Guide for Strip Longest Suffix

Goal: Remove the longest suffix from the first `.` onward using `${str%%.*}`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `${str%%pattern}`.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
echo "${str%%.*}"
```
