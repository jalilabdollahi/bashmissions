# Walkthrough: Integer Variables

## The plan
Make `total` a number-aware variable, feed it the sum as an expression, and add the spares.

## Step by step
First, see what goes wrong without help:

```bash
total=$WEB+$DB+$CACHE
echo "$total"        # 3+2+1
```

A plain variable stores exactly the characters you give it. To change that, declare it:

```bash
declare -i total
```

The `-i` is an attribute: "this variable holds an integer". Every later assignment to `total` is evaluated as arithmetic. Now the same line gives a number:

```bash
total=$WEB+$DB+$CACHE
echo "servers: $total"     # servers: 6
```

(Bash first expands the settings to `3+2+1`, and then the integer attribute evaluates it.)

`+=` changes meaning too. On a normal variable it appends text, on an integer variable it adds:

```bash
total+=2
echo "with spares: $total"  # with spares: 8
```

## Complete solution
```bash
#!/usr/bin/env bash
declare -i total
total=$WEB+$DB+$CACHE
echo "servers: $total"
total+=2
echo "with spares: $total"
```

## Try it by hand
```
WEB=3 DB=2 CACHE=1 ./solution.sh
WEB=0 DB=0 CACHE=0 ./solution.sh
```

## Alternative
Without `declare -i` you can use the arithmetic expansion `$(( ... ))`, which is the more common tool in modern scripts and works anywhere. `declare -i` is handy when one variable keeps changing, because the arithmetic follows it around.
