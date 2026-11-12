# Walkthrough: Flip a Condition

## The plan

Searching a file for an address is straightforward; the interesting part is the
sentence "if it is NOT there". The `!` operator reverses a condition: true
becomes false and false becomes true. The BLOCK branch can then sit first, right
where Priya's attention is.

## Building it

Start with the search. Three grep options carry the details of the spec:

- `-q` quiet: no output, just an exit status
- `-x` the whole line must match, so `10.0.0.1` does not match `10.0.0.15`
- `-F` fixed string: dots are dots, not "any character"

```bash
grep -qxF "$ip" allowlist.txt
```

That command succeeds when the address is listed. Put `!` in front of it so the
`then` branch runs when it is NOT listed:

```bash
ip="$1"
if ! grep -qxF "$ip" allowlist.txt; then
  echo "BLOCK $ip"
else
  echo "allow $ip"
fi
```

Without `!` you would write the same logic backwards, with the interesting branch
under `else`. Negation lets the code mirror the sentence you want to say.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

ip="$1"

if ! grep -qxF "$ip" allowlist.txt; then
  echo "BLOCK $ip"
else
  echo "allow $ip"
fi
```

## Try it by hand

```bash
printf '10.0.0.15\n192.168.1.20\n' > allowlist.txt
./solution.sh 192.168.1.20
./solution.sh 10.0.0.1
```

## An alternative

You can swap the branches and drop the `!`: `if grep -qxF ...; then allow; else
BLOCK; fi`. It gives identical output. Use `!` when the "not" case is the one
you care about or when there is no `else` at all, as in `if ! command; then
echo "failed"; exit 1; fi`.
