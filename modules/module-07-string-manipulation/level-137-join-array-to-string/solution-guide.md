# Guide for Join Array to String

Goal: Join the arguments with commas using the `IFS=,` array join trick.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: `IFS=,` join trick.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

items=("$@")
joined=$(IFS=,; echo "${items[*]}")
echo "$joined"
```
