# Walkthrough: Negated Classes

## The problem
`msg="(.*)"` looks right, but `.*` is greedy and `.` also matches a quote. On
`msg="disk is 91% full" host="halibut"` the group takes everything up to the
*last* quote: `disk is 91% full" host="halibut`.

Many regex flavours cure that with a lazy `.*?` ("as few as possible"). POSIX
extended regex, which Bash, `grep -E` and `sed -E` use, **does not have it**.

## The idea
Do not ask for "as little as possible". State what the content is: any character
except a double quote. That is a **negated character class**:

```
[^"]*
```

A caret right after the opening bracket flips the set. `[^"]*` matches any run of
non-quote characters and physically cannot step over a quote, so it stops at the
next one: the closing quote of `msg`.

## The regex
```
msg="([^"]*)"
```
- `msg="` the literal start,
- `([^"]*)` the captured text, possibly empty (`*` allows zero),
- `"` the closing quote.

`message="x"` does not match: it contains `message="`, and `msg="` is not a substring of that.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='msg="([^"]*)"'
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    echo "msg: ${BASH_REMATCH[1]}"
  else
    echo "no msg"
  fi
done
```

## Try it by hand
```bash
echo 'user="ollie" msg="disk is 91% full" host="halibut"' | ./solution.sh
```

## Alternative
`${line#*msg=\"}` followed by `${rest%%\"*}` with parameter expansion also cuts
out the text. It works for this exact layout, but you would need two steps and a
separate test for "no msg" (level 141's patterns again). The regex does the test
and the extraction in one.
