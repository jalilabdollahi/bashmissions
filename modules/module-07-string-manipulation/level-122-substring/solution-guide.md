# Guide for Substring

Goal: Print five characters from the first argument starting at offset 2 using `${str:2:5}`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `${str:2:5}`.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
echo "${str:2:5}"
```
