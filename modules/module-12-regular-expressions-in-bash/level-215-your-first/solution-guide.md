# Walkthrough: Your First =~

## The plan
Read stdin line by line. For each line ask "does it contain `Failed password`?"
and print it with a prefix only when the answer is yes.

## Step by step
The reading loop is the one you already know:

```bash
while IFS= read -r line || [[ -n $line ]]; do
  ...
done
```

The `|| [[ -n $line ]]` part keeps a last line that has no trailing newline.

Inside it comes the new tool. `[[ ... ]]` is Bash's test command, and next to
`==` it has a second comparison, `=~`. The left side is a string, the right
side is a *regular expression*. The test is true when the expression can be
found anywhere in the string. Letters and digits in a regex stand for
themselves, so `Failed password` matches exactly that text.

One catch: Bash splits the right-hand side at unquoted spaces, so the space has
to be escaped with a backslash: `Failed\ password`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ Failed\ password ]]; then
    echo "ALERT: $line"
  fi
done
```

## Try it by hand
```bash
printf 'sshd: Failed password for root\nsshd: Accepted publickey for mara\n' | ./solution.sh
echo 'failed password' | ./solution.sh     # prints nothing: case matters
```

## Alternative
`case "$line" in *"Failed password"*) ... ;; esac` also works, and so does
`[[ $line == *"Failed password"* ]]`. Those are glob patterns. They are fine
for "contains this text", but they cannot say "digits here, then a dot", which
is why the rest of this module teaches the regex language instead.
