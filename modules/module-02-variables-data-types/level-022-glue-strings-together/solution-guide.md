# Walkthrough: Glue Strings Together

## The plan
Bash has no special "join" operator. You concatenate simply by writing pieces next to each other. For a longer result, start a variable and keep appending to it.

## Step by step
The first piece is the scheme and the site. Writing a `$variable` right after plain text just works, because the text and the expansion sit in the same word:

```bash
url=https://$SITE
```

Now add the port. `+=` means "take what is already in the variable and put this after it":

```bash
url+=:$PORT
```

Without the `+`, `url=:$PORT` would throw away everything you built so far. That is the single most common slip with this operator.

The last piece joins fixed text and the stage:

```bash
url+=/status/$STAGE
```

Print it in double quotes so the value is passed on exactly as it is:

```bash
echo "$url"
```

## Complete solution
```bash
#!/usr/bin/env bash
url=https://$SITE
url+=:$PORT
url+=/status/$STAGE
echo "$url"
```

## Try it by hand
```
SITE=anchovy.lanternfish.example PORT=8443 STAGE=live ./solution.sh
```

## Alternative
You can build the whole thing in one assignment: `url="https://$SITE:$PORT/status/$STAGE"`. It is shorter, and perfectly fine when you know all the pieces at once. `+=` earns its place when the pieces arrive over time, for example inside a loop or after some checks.
