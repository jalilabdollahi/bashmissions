# Walkthrough: Quote Your Variables

## The plan
Nothing needs to be added to this script, only protected. Every bare `$CUSTOMER` has to become `"$CUSTOMER"`.

## Step by step
Run the broken version with `CUSTOMER="Gull & Anchor Pub" bash solution.sh` and read the error: Bash says `ambiguous redirect`. After the variable is replaced, the redirect target `Gull & Anchor Pub.txt` is four separate words, and a redirect can only have one.

That is **word splitting**: unquoted, the result of a `$variable` is cut at every space, tab and newline.

The second problem is **globbing**. Unquoted, the result is also checked for `*` and `?` and replaced by matching file names. With `CUSTOMER="*"`, `printf 'Filed: [%s]\n' $CUSTOMER` receives `solution.sh` and `fixtures` instead of a star, and prints two lines.

Double quotes turn both features off:

```bash
echo "Welcome, $CUSTOMER" > "$CUSTOMER.txt"
printf 'Filed: [%s]\n' "$CUSTOMER"
```

The `$` still works inside double quotes - only the splitting and globbing stop.

## Complete solution
```bash
#!/usr/bin/env bash
echo "Welcome, $CUSTOMER" > "$CUSTOMER.txt"
printf 'Filed: [%s]\n' "$CUSTOMER"
```

## Try it by hand
```
CUSTOMER="North Pier Dental" ./solution.sh
ls
```
You should see one file with spaces in its name.

## Alternative
Single quotes would stop the expansion completely and print the text `$CUSTOMER`, which is not what we want. Backslash-escaping each space cannot work because you do not know the value in advance.
