# Guide for Substring from End

Goal: Print the last three characters of the first argument using a negative substring offset.

Work in this order:

1. Store the input string in a variable.
2. Apply the string operation from this concept: negative offset.
3. Quote input assignments so spaces remain part of the string.
4. Print exactly the transformed value or classification requested by the mission.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

str="$1"
echo "${str: -3}"
```
