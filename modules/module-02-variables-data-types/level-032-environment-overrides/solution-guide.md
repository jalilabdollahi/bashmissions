# Walkthrough: Environment Overrides

## The plan
Turn five loose inputs into four resolved variables, then print them. The order of precedence is the interesting part: the most specific setting wins, then the more general one, then the built-in default.

## Step by step
The three simple settings are exactly the fallback form from earlier, stored in variables so you can reuse them:

```bash
name=${APP_NAME:-lanternfish-web}
mode=${APP_MODE:-production}
workers=${APP_WORKERS:-2}
```

For the port, there are two environment sources. The word after `:-` is expanded like any other text, so it can hold another expansion:

```bash
port=${APP_PORT:-${PORT:-8080}}
```

Read from the inside out: the innermost `${PORT:-8080}` is "`PORT`, or 8080". The outer one is "`APP_PORT`, or whatever the inner one gave". An empty `APP_PORT` falls through to `PORT`, just as a missing one does.

Because everything is resolved into variables first, the output needs no logic. A here-document from module 1 keeps the block readable, and `listen` is built from the same variables:

```bash
cat <<EOF
name=$name
mode=$mode
port=$port
workers=$workers
listen=$name:$port
EOF
```

## Complete solution
Put the four assignments first and the here-document after them; that is the whole script apart from the shebang line.

## Try it by hand
```
./solution.sh
PORT=3000 ./solution.sh
APP_PORT=9100 PORT=3000 APP_NAME=dory-api ./solution.sh
APP_PORT= PORT=4040 ./solution.sh
```

## Alternative
Four `: "${VAR:=default}"` lines (assign-a-default) would also work, but they overwrite the original names. Resolving into new, lower-case variables keeps what the caller passed untouched and makes the precedence visible on one line.
