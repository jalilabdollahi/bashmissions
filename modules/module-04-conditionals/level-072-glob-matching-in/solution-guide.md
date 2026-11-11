# Walkthrough: Glob Matching in [[ ]]

## The plan

The rules describe the shape of a name, not its full value. A glob pattern
describes a shape: `*` stands for any run of characters (including none) and
`?` stands for exactly one. Inside `[[ ]]`, `==` understands these patterns when
the right-hand side is not quoted. The rules are tried in order, so this is a
ladder.

## Building it

```bash
name="$1"
```

Rule 1: anything starting with `tmp-`:

```bash
if [[ $name == tmp-* ]]; then
  echo "$name -> delete"
```

Rule 2: anything ending in `.log`:

```bash
elif [[ $name == *.log ]]; then
  echo "$name -> archive"
```

Rule 3: `crash-`, then exactly one character, then `.dump`. This is where `?` is
needed; `*` would also let `crash-12.dump` through:

```bash
elif [[ $name == crash-?.dump ]]; then
  echo "$name -> ticket"
```

Everything else:

```bash
else
  echo "$name -> ignore"
fi
```

`tmp-old.log` matches rules 1 and 2. The ladder stops at the first true test, so
it is deleted, not archived. That is what "first rule wins" means in code.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

name="$1"

if [[ $name == tmp-* ]]; then
  echo "$name -> delete"
elif [[ $name == *.log ]]; then
  echo "$name -> archive"
elif [[ $name == crash-?.dump ]]; then
  echo "$name -> ticket"
else
  echo "$name -> ignore"
fi
```

## Try it by hand

```bash
for f in tmp-1 a.log crash-3.dump crash-33.dump; do ./solution.sh "$f"; done
```

## An alternative

You can do the same with `grep -E` or with `case`. Glob matching in `[[ ]]`
needs no extra process and no escaping of dots, so it is the lightest option for
simple name shapes. `case` is neater when there are many rules, as the next levels show.
