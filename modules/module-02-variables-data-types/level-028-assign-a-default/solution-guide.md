# Walkthrough: Assign a Default

## The plan
Settle `REGION` in one place. Every later line then uses `$REGION` and cannot disagree with the others.

## Step by step
The `:-` form from last level only substitutes. If you wrote `${REGION:-north-pier}` in each of three lines, you would repeat the default three times, and the day it changes you must edit three places.

The `:=` form assigns as it substitutes:

```bash
echo "${REGION:=north-pier}"
```

prints `north-pier` and also leaves `REGION=north-pier` behind. But we do not want to print at this point, only to settle the value. The shell command `:` does nothing and ignores its arguments, but Bash still expands them first, so:

```bash
: "${REGION:=north-pier}"
```

is the standard idiom for "make sure this variable has a value". The quotes protect a default that contains spaces.

After that the variable is simply set:

```bash
echo "deploying to $REGION"
echo "backups: /backups/$REGION"
echo "tag: release-$REGION"
```

## Complete solution
```bash
#!/usr/bin/env bash
: "${REGION:=north-pier}"
echo "deploying to $REGION"
echo "backups: /backups/$REGION"
echo "tag: release-$REGION"
```

## Try it by hand
```
./solution.sh
REGION=harbour-east ./solution.sh
REGION= ./solution.sh
```

## Alternative
`REGION=${REGION:-north-pier}` has the same result and is also common. It restates the name twice, which is a place for typos. `:=` says it once.
