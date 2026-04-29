# Guide for Trim Both Ends

Goal: Trim leading and trailing whitespace from the first argument.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: combined trimming.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail
shopt -s extglob

str="$1"
str="${str##+([[:space:]])}"
str="${str%%+([[:space:]])}"
echo "$str"
```
