# Walkthrough: Fallback Values

## The plan
For each setting, print its value, but substitute a default when the setting was not provided. Bash has a built-in expansion for exactly that, so each output line is a single `echo`.

## Step by step
The form is `${name:-default}`. Read it as "the value of `name`, or `default` when `name` is unset or empty".

```bash
echo "level=${LOG_LEVEL:-info}"
```

Try the two cases:

```
bash solution.sh                    # level=info
LOG_LEVEL=debug bash solution.sh    # level=debug
LOG_LEVEL= bash solution.sh         # level=info
```

The last one is the point of the colon. A setting that exists but is empty is useless to a log viewer, so the colon form treats it as missing.

The default itself can contain slashes, digits, anything that is plain text:

```bash
echo "dir=${LOG_DIR:-/var/log/lanternfish}"
echo "lines=${MAX_LINES:-200}"
```

## Complete solution
```bash
#!/usr/bin/env bash
echo "level=${LOG_LEVEL:-info}"
echo "dir=${LOG_DIR:-/var/log/lanternfish}"
echo "lines=${MAX_LINES:-200}"
```

## Try it by hand
```
./solution.sh
LOG_DIR=/srv/logs MAX_LINES=50 ./solution.sh
```

## Alternative
You could test with `if [[ -z "$LOG_LEVEL" ]]; then LOG_LEVEL=info; fi` for each variable. It does the same job in three lines instead of one, and is much easier to get subtly wrong. Fallback expansions are the idiomatic way; they also leave the original variable untouched, which the next level will contrast.
