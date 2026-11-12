# Walkthrough: Function Arguments

## The plan
One sentence template, two moving parts. The function holds the template; the
caller supplies the parts.

## Building it
Inside a function, `$1` and `$2` are the function's own arguments:

```bash
describe() {
  echo "$1 hosts $2 sites"
}
```

At the call site, the words after the function name become those arguments. We
pull them from the *script's* arguments, which are `$1`..`$4` out there:

```bash
describe "$1" "$2"
describe "$3" "$4"
```

The same numbers mean different things in the two places. Inside `describe`,
`$1` is the server name of that call. Outside, `$3` is the third word typed on
the script's command line. Double quotes around each value keep `dory east`
together as one argument.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
describe() {
  echo "$1 hosts $2 sites"
}
describe "$1" "$2"
describe "$3" "$4"
```

## Try it by hand
```bash
./solution.sh dory 12 marlin 7
./solution.sh "dory east" 3 eel 0
```

## Alternative
You could first copy the values into named variables inside the function
(`name=$1; count=$2`) which reads better in longer functions. For two values the
direct `$1`/`$2` is fine; the next levels will show why naming becomes useful.
