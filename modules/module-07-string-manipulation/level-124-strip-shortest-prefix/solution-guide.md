# Guide for Strip Shortest Prefix

Goal: Remove the shortest prefix through the first `/` from the first argument using `${str#*/}`.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `${str#pattern}`.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
echo "${str#*/}"
```
