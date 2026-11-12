# Walkthrough: The Script Knows Its Name

## The plan
Two small facts are needed. The first is the script's own name, which Bash keeps in `$0`. The second is the file name of a path, which `basename` extracts. Output text mixes fixed words with those two results, exactly like the previous level.

## Step by step
1. `$0` holds the command word used to start the script. If you ran `bash solution.sh`, it is `solution.sh`. If you ran `/home/team/tools/solution.sh`, it is the whole path, which is why we want `basename` too.
2. `basename "$0"` therefore gives the bare file name in both cases.
3. Do the same for `$REPORT_PATH`. Quote the variable: the test path contains spaces.
4. Place each result in its line with `$( ... )`.

## Complete solution

```bash
#!/usr/bin/env bash
echo "This script is called $(basename "$0")"
echo "Report file: $(basename "$REPORT_PATH")"
```

## Trying it by hand
`REPORT_PATH=/var/reports/nightly.txt bash solution.sh`, then copy the file under another name and run it again to see the first line change.

## An alternative
Bash can trim a path without starting a command: `${0##*/}`. It is quick and you will learn it in the string levels. `basename` is easier to read at this stage, and it is the tool most scripts use.
