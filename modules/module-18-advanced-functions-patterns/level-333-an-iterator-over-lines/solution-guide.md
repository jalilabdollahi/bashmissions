# Walkthrough: An Iterator over Lines

## The plan

An iterator is "give me the next item" plus a record of how far you got.
`while read` has both built in, but only for one line per turn. With
a function and a cursor you can take as many lines as each loop turn needs.

## Step by step

Check the file, load it, put the cursor at the start:

```bash
[[ -r $file ]] || { echo "lines: cannot read '$file'" >&2; exit 1; }
mapfile -t lines < "$file"
cursor=0
```

`mapfile -t` (also called `readarray`) stores one line per array element and
strips the newlines.

The iterator. Its contract: on success `LINE` holds the next line and the
cursor has moved; at the end it fails with status 1 and changes nothing:

```bash
next_line() {
  (( cursor < ${#lines[@]} )) || return 1
  LINE=${lines[cursor]}
  cursor=$(( cursor + 1 ))
}
```

Because the status means "exhausted", the iterator can drive the loop:

```bash
while next_line; do
  name=$LINE
```

After reading the name, `cursor` is the 1-based number of the line just
handed out, which is exactly what the error message needs, so save it:

```bash
  start=$cursor
```

The plan and price come from two more calls. If either fails, the file ended
inside a record. Chaining with `&&` stops at the first failure:

```bash
  if ! { next_line && plan=$LINE && next_line && price=$LINE; }; then
    echo "incomplete record starting at line $start" >&2
    exit 1
  fi
  echo "$name: $plan plan, $price EUR/month"
done
```

## Try it by hand

```
printf 'Harbour Bakery\nbasic\n9\n' > queue.txt
./solution.sh queue.txt
printf 'Harbour Bakery\nbasic\n' > queue.txt; ./solution.sh queue.txt
```

## Alternative

Open the file on a descriptor and `read -r -u 3 line` three times per turn.
It streams instead of loading the whole file, which matters for huge files, but
the cursor (and the line number for error messages) is then implicit and harder
to inspect.
