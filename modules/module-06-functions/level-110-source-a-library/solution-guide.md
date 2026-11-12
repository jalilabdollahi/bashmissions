# Walkthrough: Source a Library

## The plan
Load the shared file, then use what it provides. No logic of our own beyond
formatting the lines.

## Building it
First look at the library:

```bash
cat fixtures/storage.sh
```

It sets `STORAGE_LIB_VERSION` and defines `kb_to_mb`. Loading it is one line:

```bash
source fixtures/storage.sh
```

`source` reads the file and runs each line inside *your* shell, so the variable
and the function now exist in your script. Then the usual loop, capturing the
function's output with `$( )` as in level 105:

```bash
echo "storage lib v$STORAGE_LIB_VERSION"
for kb in "$@"; do
  echo "$kb KB = $(kb_to_mb "$kb") MB"
done
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
source fixtures/storage.sh
echo "storage lib v$STORAGE_LIB_VERSION"
for kb in "$@"; do
  echo "$kb KB = $(kb_to_mb "$kb") MB"
done
```

## Try it by hand
```bash
./solution.sh 1 1025 5000
```
Then edit `fixtures/storage.sh` to change the version number and run again: the
script follows the library without any change of its own.

## Alternative
`. fixtures/storage.sh` is identical to `source`. Running the library with
`bash fixtures/storage.sh` does NOT work, because the child process ends and takes
its functions with it.
