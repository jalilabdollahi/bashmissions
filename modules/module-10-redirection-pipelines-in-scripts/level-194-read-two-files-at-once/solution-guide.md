# Walkthrough: Read Two Files at Once

## The plan

Hold the addresses file open on descriptor 3. Loop over the names file as
usual and, for each name, pull one more line from descriptor 3.

## Step by step

First validate. A short loop over both arguments reports the first unreadable
one in the right order:

```bash
for f in "$1" "$2"; do
  [[ -r $f ]] || { echo "cannot read: $f" >&2; exit 1; }
done
```

A loop `while read ...; done < file` connects the file to the loop's stdin, and
`read` consumes a line per iteration. Inside the same loop we cannot read the
second file from stdin too, as it is taken. So give the second file its own
number:

```bash
exec 3< "$2"
```

Now `read -u 3` means "read from descriptor 3 instead of stdin". Each call
continues where the last one stopped, because the open file remembers its
position:

```bash
while IFS= read -r name; do
  IFS= read -r -u 3 address || address="(none)"
  echo "$name -> $address"
done < "$1"
```

When the addresses run out, `read` returns non-zero and `address` is empty;
`||` replaces it with `(none)`. Extra addresses are never read because the
loop ends with the names. `IFS=` and `-r` keep spaces and backslashes as typed.

Finish with `exec 3<&-` to close the descriptor.

## The complete solution

See answer.sh.

## Trying it by hand

```bash
printf 'a\nb\n' > n.txt; printf '1\n' > a.txt
./solution.sh n.txt a.txt
```

## An alternative

`paste -d'|' names addresses` would be the first thing to try on a normal
box. It does not mark missing addresses, and the exercise is about controlling
two input streams yourself.
