# Walkthrough: Optional Second Argument

## The plan
The host is mandatory and the port is a convenience. Rather than checking `$#`,
use an expansion that substitutes a default value when the argument is absent.

## Building it
Read the required argument as before:

```bash
host=$1
```

For the optional one, `${2:-22}` is a recipe: "the value of `$2`, or `22` if
`$2` is unset or empty".

```bash
port=${2:-22}
```

Because the default also covers an *empty* string, `./solution.sh barracuda ""`
(a form that shows up when another script passes along a variable that happened
to be blank) behaves like not giving a port at all. That is exactly the colon in
`:-`; without the colon, `${2-22}` would only fire for a truly missing argument
and the empty string would slip through.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
host=$1
port=${2:-22}
echo "connect $host on port $port"
```

## Try it by hand
```bash
./solution.sh anchovy
./solution.sh backup-eel 2222
./solution.sh barracuda ""
```

## Alternative
You can test `$#` with `-ge 2` and assign the port in two branches (`if` comes in
module 4). The expansion does the same in one line and also covers the empty
string case, which the count cannot see.
