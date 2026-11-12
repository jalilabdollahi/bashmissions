# Walkthrough: Capture Command Output

## The plan
Sort the list. The first line of the sorted list is the first name, the last line is the last name. Keep each in a variable so the three output lines can reuse them.

## Step by step
Try the pipeline on its own first:

```
sort fixtures/servers.txt | head -n 1
```

It prints `anchovy`. In module 1 you used `$(command)` inside an `echo`. Exactly the same thing works on the right-hand side of an assignment:

```bash
first=$(sort fixtures/servers.txt | head -n 1)
```

Bash runs the pipeline, collects what it printed, removes the trailing newline and stores the result in `first`.

The other end of the list is `tail`:

```bash
last=$(sort fixtures/servers.txt | tail -n 1)
```

Now the report is plain variable use. The `..` is ordinary text, and since a dot cannot be part of a variable name, `$first..$last` needs no braces:

```bash
echo "first: $first"
echo "last: $last"
echo "range: $first..$last"
```

## Complete solution
```bash
#!/usr/bin/env bash
first=$(sort fixtures/servers.txt | head -n 1)
last=$(sort fixtures/servers.txt | tail -n 1)
echo "first: $first"
echo "last: $last"
echo "range: $first..$last"
```

## Try it by hand
```
./solution.sh
printf 'zeta\nalpha\n' > fixtures/servers.txt
./solution.sh
```

## Alternative
`sort -r | head -n 1` finds the last name too. Both work; `tail` reads more naturally as "the other end". If you only needed the output once, putting `$(...)` straight into the `echo` would be enough - the variable earns its keep because we use each value twice.
