# Walkthrough: Counting from the End

## The plan
Reject keys that are too short, then slice off the last four characters and glue
four stars in front.

## Step by step
First the guard. The length expansion from the first level of this module does
the counting; the message goes to stderr so it cannot end up in a ticket:

```bash
key=$1
if (( ${#key} < 4 )); then
  echo "key too short" >&2
  exit 1
fi
```

Now the slice. A negative offset counts backwards from the end of the value:

```bash
last4=${key: -4}
```

The space matters. `${key:-4}` (no space) is the "use default value" expansion
from the variables module: it would print the whole key, or `4` if the key were
empty. With the space, Bash knows it is an offset.

Finally print:

```bash
echo "masked=****$last4"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
key=$1
if (( ${#key} < 4 )); then
  echo "key too short" >&2
  exit 1
fi
last4=${key: -4}
echo "masked=****$last4"
```

## Try it by hand
```bash
./solution.sh lf_live_9f3a7c21
./solution.sh xyz; echo "exit=$?"
```

## Alternative
You could compute the offset yourself: `${key:${#key}-4}`. It works and shows what
the negative form means, but `${key: -4}` says "the last four" directly. Parentheses
`${key:(-4)}` avoid the space if you prefer that style.
