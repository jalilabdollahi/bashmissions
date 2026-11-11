# Walkthrough: How Long Is It?

## The plan
Store the argument, ask Bash for its length, print it, then sort the length into
one of three buckets.

## Step by step
Grab the argument. The `-` after `1` gives an empty default so that `set -u`
does not abort when nobody passed anything:

```bash
name=${1-}
```

The length of a value is written `${#name}`. It counts characters, so spaces count
too, and an empty value gives `0`:

```bash
len=${#name}
echo "length=$len"
```

Now the decision. Inside `(( ))` the variable can be used without a dollar sign:

```bash
if (( len < 3 )); then
  echo "status=too-short"
elif (( len > 12 )); then
  echo "status=too-long"
else
  echo "status=ok"
fi
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
name=${1-}
len=${#name}
echo "length=$len"
if (( len < 3 )); then
  echo "status=too-short"
elif (( len > 12 )); then
  echo "status=too-long"
else
  echo "status=ok"
fi
```

## Try it by hand
```bash
./solution.sh marlin42
./solution.sh "gull anchor"
./solution.sh ""
```

## Alternative
`len=$(echo -n "$name" | wc -c)` gives a similar number, but it starts two extra
processes, and `wc -c` pads its output on macOS. `${#name}` is faster, shorter
and identical on every system.
