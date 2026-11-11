# Walkthrough: Indirect References

## The plan
Work out which variable to read, then read it. Two steps, because the name of the variable depends on the customer.

## Step by step
For `CUSTOMER=bakery` the quota lives in a variable called `LIMIT_bakery`. First build that name as ordinary text and keep it in a variable:

```bash
quota_var=LIMIT_$CUSTOMER
```

Now `quota_var` contains the *text* `LIMIT_bakery`. Printing `$quota_var` would show exactly that, not the quota. To follow the name to the variable it points at, put an exclamation mark after the opening brace:

```bash
echo "${!quota_var}"
```

This is **indirect expansion**: Bash first reads `quota_var` to get a name, then reads the variable with that name.

The fallback operators you know work on the result as well, which handles the customer with no quota and the one whose quota is blank:

```bash
echo "quota for $CUSTOMER: ${!quota_var:-unlimited}"
```

## Complete solution
```bash
#!/usr/bin/env bash
quota_var=LIMIT_$CUSTOMER
echo "quota for $CUSTOMER: ${!quota_var:-unlimited}"
```

## Try it by hand
```
CUSTOMER=bakery LIMIT_bakery=50 ./solution.sh
CUSTOMER=pub ./solution.sh
```

## Alternative
A `case "$CUSTOMER" in bakery) ...;; books) ...;; esac` block works but must be edited for every new customer. Indirection scales: a new `LIMIT_...` setting is found automatically. (For real tables of key-value pairs, Bash offers associative arrays, which come in a later module.)
