# Assign If Unset

`${var:=default}` is `${var:-default}`'s side-effecting cousin. It both **substitutes** the default and **assigns** it to the variable for use later in the script.

```bash
: "${PORT:=8080}"
echo "starting on port $PORT"   # 8080
echo "$PORT"                    # 8080  — the variable now holds the default
```

The `:` (no-op) command is the standard way to trigger the expansion when you don't want to use the substituted value yet. The expansion runs, the assignment happens, and `:` discards the output.

Restrictions and pitfalls:

- Cannot be used on positional parameters: `${1:=foo}` errors with `cannot assign in this way`. Copy first: `name="$1"; : "${name:=foo}"`.
- Cannot be used on read-only variables.
- Like `:-`, the colon makes empty strings count as "unset". Without the colon (`${var=default}`), only truly unset variables get the default.

Useful in scripts that read config values from the environment with a documented default:

```bash
: "${LOG_LEVEL:=info}"
: "${MAX_RETRIES:=3}"
```

After those two lines, both variables are guaranteed to hold a value — either inherited from the environment or the script's default.
