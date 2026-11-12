# Walkthrough: Alternation

## The plan
Two regexes, one for each decision. Count lines into three counters, print once
at the end.

## The alternation
`|` means "or", and it has very low priority: `ACTION=DROP|REJECT` would mean
"`ACTION=DROP` or `REJECT`". Wrapping the choice in parentheses limits it to the
action word:

```
ACTION=(DROP|REJECT|DENY)
```

## Closing the word
Without anything after the group, `ACTION=DROPPED` matches, because `DROP` is
found at its start. The line says the field is always followed by a space or the
end of the line, so a second group closes the word: `( |$)`. Here `$` inside
the parentheses still means "end of the string".

## Chain of decisions
An `if / elif / else` makes each line count once. A line without `ACTION=` falls
through to `other`, and so does lowercase, because regex is case-sensitive.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
block_re='ACTION=(DROP|REJECT|DENY)( |$)'
allow_re='ACTION=(ACCEPT|ALLOW)( |$)'
blocked=0 allowed=0 other=0
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $block_re ]]; then
    blocked=$(( blocked + 1 ))
  elif [[ $line =~ $allow_re ]]; then
    allowed=$(( allowed + 1 ))
  else
    other=$(( other + 1 ))
  fi
done
echo "blocked=$blocked allowed=$allowed other=$other"
```

## Try it by hand
```bash
printf 'fw: ACTION=DROP\nfw: ACTION=DROPPED\nfw: ACTION=ALLOW\n' | ./solution.sh
```

## Alternative
A `case` statement with `*"ACTION=DROP "*|*"ACTION=REJECT "*)` also works, but it
needs one glob per word and cannot express "space or end of line". Alternation
keeps the shared prefix in one place.
