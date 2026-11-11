# Walkthrough: Brace Ranges

## The plan
There are two small jobs. First, protect the script from a missing prefix. Second, count from 08 to 12 without typing the numbers, and glue each one to the prefix.

## Step by step
1. Guard the door. `[[ $# -lt 1 ]]` is true when nobody passed an argument. Print the usage text to stderr with `>&2` and leave with `exit 2`.
2. Save the prefix in a variable so the loop reads well: `prefix=$1`.
3. Write the loop list as a brace range: `{08..12}`. Bash expands it before the loop even starts, into `08 09 10 11 12`. Because the first number begins with a zero, all results are padded to two digits, so `09` stays `09`.
4. In the body, print the prefix, a dash and the number: `echo "$prefix-$n"`.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh PREFIX" >&2
  exit 2
fi

prefix=$1
for n in {08..12}; do
  echo "$prefix-$n"
done
```

## Trying it by hand
Run `bash solution.sh web`, then without an argument, then check `echo $?`. In the shell, `echo {1..5}` and `echo {a..e}` show the expansion on its own. Try `echo {01..10}` to see the padding.

## An alternative
`seq -w 8 12` also prints padded numbers, but it starts another process and its padding rules are a bit different. Brace ranges are built into Bash and cost nothing. The catch is that they cannot use variables, so for "from 1 to $n" you need the next level's tools.
