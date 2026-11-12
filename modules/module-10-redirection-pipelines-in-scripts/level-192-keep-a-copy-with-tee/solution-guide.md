# Walkthrough: Keep a Copy with tee

## The plan

Merge the tool's two streams into one, send it into `tee -a`, and make sure
the exit status comes from the deploy, not from `tee`.

## Step by step

A pipe carries only stdout. The warning from `deploy-tool` is on stderr, so it
would skip the pipe and go straight to the screen, and not into the log.
Merge it first (you learned the form two levels ago):

```bash
deploy-tool "$site" 2>&1 | ...
```

`tee` is the T-fitting. It copies its stdin to every file named on the
command line and also to its own stdout. Without options it truncates the
files, like `>`. With `-a` it appends, like `>>`:

```bash
deploy-tool "$site" 2>&1 | tee -a deploy.log
```

Everything you see on screen is what tee passes along, and the same bytes sit
in deploy.log.

Last problem: a pipeline's exit status is the last command's, and `tee`
almost always succeeds. A failed deploy would look like a success. With
`set -o pipefail` the pipeline's status becomes that of the rightmost stage
that failed, which here is `deploy-tool`, and since it is the last command of
the script, that status is the script's too.

## The complete solution

```bash
#!/usr/bin/env bash
set -o pipefail
site=$1
deploy-tool "$site" 2>&1 | tee -a deploy.log
```

## Trying it by hand

```bash
DEPLOY_RC=3 ./solution.sh gull; echo "exit=$?"
cat deploy.log
```

## An alternative

`deploy-tool "$site" > >(tee -a deploy.log) 2>&1` does the same with process
substitution, but is harder to read, and the exit status handling is simpler
with the pipeline.
