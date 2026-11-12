# Walkthrough: Exported to Children

## The plan
Create two variables. Give one of them to the child program, keep the other private. Run the child, then check that the parent can still read both.

## Step by step
Run the tool on its own to see what it does:

```
bash fixtures/child.sh
```

It prints empty brackets, because it is a separate process that inherited nothing from your terminal.

Whenever a script starts a program, Bash gives it a copy of the **environment**: the set of *exported* variables. A normal assignment is not in that set. To put `REGION` into it:

```bash
export REGION="$SITE"
```

`SCRATCH` is only for your own use, so it gets a plain assignment. The quotes keep a site name like `old quay` in one piece:

```bash
SCRATCH="/srv/scratch/$SITE"
```

Now start the child. It can read `REGION` but not `SCRATCH`:

```bash
bash fixtures/child.sh
```

The parent, meanwhile, remembers both:

```bash
echo "parent sees: REGION=[$REGION] SCRATCH=[$SCRATCH]"
```

## Complete solution
```bash
#!/usr/bin/env bash
export REGION="$SITE"
SCRATCH="/srv/scratch/$SITE"
bash fixtures/child.sh
echo "parent sees: REGION=[$REGION] SCRATCH=[$SCRATCH]"
```

## Try it by hand
```
SITE=north-pier ./solution.sh
SITE="old quay" ./solution.sh
```

## Alternative
You can also pass a variable to a single command without exporting it for the rest of the script: `REGION=north-pier bash fixtures/child.sh`. That is neat for one-off calls, but when several commands need the value, one `export` is simpler.
