# Walkthrough: printf Placeholders

## The plan
The line has a fixed skeleton with three holes: a name and two numbers. `printf` is built for exactly that: you describe the skeleton once, with placeholders, and pass the values separately.

## Step by step
1. Write the skeleton with the placeholders: `Customer: %s | open: %d | oldest: #%d`. `%s` means "text goes here", `%d` means "a whole number goes here".
2. End the format with `\n`, because printf will not add a line break for you.
3. After the format, list the values in the same order as the holes. The environment variables are used as `"$CUSTOMER"`, `"$TICKETS"` and `"$OLDEST"`. The double quotes keep a name like `North Pier Dental` as a single value.

## Complete solution

```bash
#!/usr/bin/env bash
printf 'Customer: %s | open: %d | oldest: #%d\n' "$CUSTOMER" "$TICKETS" "$OLDEST"
```

## Trying it by hand
Set the values for one run only and call the script:

```
CUSTOMER="Harbour Bakery" TICKETS=3 OLDEST=1201 bash solution.sh
```

## An alternative
Plain `echo "Customer: $CUSTOMER | open: $TICKETS ..."` produces the same text for this input. printf is better when you need control, such as the widths in the next two levels, and it refuses to treat `-n`-looking values as options.
