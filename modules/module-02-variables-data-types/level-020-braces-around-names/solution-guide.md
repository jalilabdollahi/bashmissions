# Walkthrough: Braces Around Names

## The plan
Print three labels that all start from the same value, `NODE`, and add different text right after it. The only trick is telling Bash where the variable's name ends.

## Step by step
First try the obvious thing in your head:

```bash
echo "archive: $NODE_backup.tar.gz"
```

Bash scans the characters after `$`. Letters, digits and `_` all count, so it reads `NODE_backup` as one name. That variable does not exist, so it expands to nothing and you get `archive: .tar.gz` - exactly Theo's bug.

Curly braces end the argument:

```bash
echo "archive: ${NODE}_backup.tar.gz"
```

The same applies to the digit in the second line: `$NODE2` would look up a variable called `NODE2`.

```bash
echo "replica: ${NODE}2"
```

The dot in the third line would have been safe without braces (a dot cannot be part of a name), but using braces for everything glued to a variable is a good habit and costs nothing.

## Complete solution
```bash
#!/usr/bin/env bash
echo "archive: ${NODE}_backup.tar.gz"
echo "replica: ${NODE}2"
echo "host: ${NODE}.lanternfish.example"
```

## Try it by hand
```
NODE=dory ./solution.sh
NODE=grouper9 ./solution.sh
```
The second command shows why the digit case matters.

## Alternative
You could build the pieces in a separate variable first, or write `"$NODE"_backup` with the quotes closed early. Braces are shorter and the more common idiom.
