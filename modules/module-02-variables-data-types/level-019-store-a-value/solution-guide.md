# Walkthrough: Store a Value

## The plan
You need two boxes with labels on them: `server` and `rack`. Fill the first with a fixed word, fill the second with whatever the inventory tool passes in as `RACK`, then print both.

## Step by step
Assigning is just a name, an equals sign and a value:

```bash
server=anchovy
```

There must be **no spaces** around `=`. With spaces, Bash thinks `server` is a command and tries to run it.

Copying the environment setting works the same way, only the right-hand side starts with `$`:

```bash
rack=$RACK
```

Now print both lines. Inside double quotes the `$name` is replaced by the stored value:

```bash
echo "server: $server"
echo "rack: $rack"
```

## Complete solution
```bash
#!/usr/bin/env bash
server=anchovy
rack=$RACK
echo "server: $server"
echo "rack: $rack"
```

## Try it by hand
```
RACK=A3 ./solution.sh
RACK=D-12-top ./solution.sh
```
Change the rack and watch the second line follow it, while the first line never changes.

## Alternative
You could skip `rack` and print `$RACK` directly. It works, but the exercise is about keeping your own named values; later levels build on that habit.
