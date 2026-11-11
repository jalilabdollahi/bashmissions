# Walkthrough: A Proper Header

## The plan
Nothing about the counting changes. We improve the first five lines of the file so
that the script is portable, explains itself, and refuses to limp on after an error.

## Step by step
1. Replace `#!/bin/bash` with `#!/usr/bin/env bash`. On some systems bash lives in
   `/usr/local/bin` or `/opt/homebrew/bin`; `env` searches PATH and finds it.
2. Add a description comment on line 2 so that anyone opening the file knows its job:
   ```bash
   # Description: Print the number of lines in a file given as the first argument.
   ```
3. Add strict mode on its own line before the first real command:
   ```bash
   set -euo pipefail
   ```
   Why each letter matters here: `cat missing | wc -l` ends with `wc`, which succeeds,
   so without `pipefail` the pipeline "worked" and printed `0`. With it, the failure
   of `cat` is the pipeline's status and `-e` stops the script. With `-u`, running the
   script without an argument is an error instead of an empty file name.
4. Quote `"$1"`.

## The complete solution
```bash
#!/usr/bin/env bash
# Description: Print the number of lines in a file given as the first argument.
set -euo pipefail

n=$(cat "$1" | wc -l | tr -d ' ')
echo "lines: $n"
echo "done"
```

## Try it by hand
```
printf 'a\nb\n' > t.txt
./solution.sh t.txt      # lines: 2, done
./solution.sh nope.txt   # error from cat, exit status 1, no "done"
./solution.sh            # unbound variable
```

## An alternative
`n=$(wc -l < "$1")` avoids the `cat` and fails properly on its own, which is nicer
code. This level keeps the pipeline on purpose, because it is the situation where
`pipefail` earns its place.
