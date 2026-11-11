# Walkthrough: Here-Docs with Variables

## The plan

The notice is a fixed template with four blanks. A here-document lets us keep
the template looking like the final text, which makes the script easy to proof-read.

## Step by step

Start by naming the arguments, which the starter already does. Then open a
here-document on `cat`:

```bash
cat <<EOF
...text...
EOF
```

Everything between `<<EOF` and the line that contains only `EOF` becomes the
standard input of `cat`, which prints it. Because the opening word `EOF` is
**not quoted**, the shell treats the body like a double-quoted string:

- `$customer`, `$start` and `$USER` are replaced by their values;
- `${host^^}` runs the uppercase parameter expansion you learned earlier;
- `$(command)` would also be run, and `\$` would print a literal dollar.

Keep the blank lines exactly as in the objective; the tests compare them.

## The complete solution

```bash
#!/usr/bin/env bash
customer=$1
host=$2
start=$3
cat <<EOF
Dear $customer,

We will update ${host^^} starting at $start UTC.
Please expect a restart of about 10 minutes.

Signed: $USER, Lanternfish Hosting
EOF
```

## Trying it by hand

```bash
./solution.sh "Harbour Bakery" cuttlefish 02:00
USER=mara ./solution.sh "Gull & Anchor Pub" halibut 23:30
```

## An alternative

A chain of `echo` or one big `printf` string also works. The here-document is
preferred for multi-line text because quotes, ampersands and line breaks
need no escaping, and the script reads like the message it prints.
