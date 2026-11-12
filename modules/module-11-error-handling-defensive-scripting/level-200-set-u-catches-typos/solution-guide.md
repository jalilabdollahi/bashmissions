# Walkthrough: set -u Catches Typos

## The plan
Three small edits: switch on `set -u`, fix the misspelled variable (which `set -u`
will now point straight at), and give the optional variable a default so the
script still works when it is absent.

## Step by step
1. Without any change, run the starter with `DEPLOY_ROOT=/srv/x ./solution.sh`.
   It prints `would clear /releases/` because `$DEPLOY_RROT` is unset and bash
   expands unset variables to nothing. If the line had been an `rm -rf`, that is
   the wrong-folder accident.

2. Add `set -u` as the second line. Run again:

   ```
   solution.sh: line 10: DEPLOY_RROT: unbound variable
   ```

   Bash names the culprit and the line. Fix the spelling to `DEPLOY_ROOT`.

3. Now run without `RELEASE_TAG`. `set -u` complains about that one as well,
   although it is allowed to be missing. `${RELEASE_TAG:-latest}` means "the
   value, or `latest` when it is unset or empty", and it is always safe under
   `set -u`.

## Complete solution
```bash
#!/usr/bin/env bash
set -u
target="$DEPLOY_ROOT/releases/${RELEASE_TAG:-latest}"
echo "would clear $target"
```

## Try it by hand
```bash
DEPLOY_ROOT=/srv/a RELEASE_TAG=v2 ./solution.sh
DEPLOY_ROOT=/srv/a ./solution.sh
./solution.sh; echo "exit=$?"     # unbound variable, exit 1
```

## Alternative
`${DEPLOY_ROOT:?must be set}` stops the script with your own message when the
variable is unset or empty. It is excellent for required inputs; here we let
bash's standard message do the job so the lesson stays about `set -u`.
