# Walkthrough: Walk with shift

## The plan
The first argument is special, and the rest are a uniform list. Instead of
juggling `$2 $3 $4...`, strip the special one off the front and then treat
whatever remains as "the list".

## Building it
Before shifting, copy the value you still need:

```bash
environment=$1
```

Now `shift` discards `$1`. If you called `./solution.sh staging anchovy dory`,
the arguments before and after look like this:

| | `$1` | `$2` | `$#` |
|---|---|---|---|
| before | staging | anchovy | 3 |
| after | anchovy | dory | 2 |

Since `$#` and `$*` now describe only the servers, the second report line needs
no arithmetic:

```bash
echo "targets=$# [$*]"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
environment=$1
shift
echo "environment: $environment"
echo "targets=$# [$*]"
```

## Try it by hand
```bash
./solution.sh staging anchovy barracuda
./solution.sh canary
```
With only the environment, `shift` leaves zero arguments and the output
`targets=0 []` falls out naturally. (Shifting when there are no arguments left is an error, which is why the objective promises at least one.)

## Alternative
Without `shift` you can use `${@:2}` for "everything from the second argument" and
`$(( $# - 1 ))` for the count. It works, but it keeps the awkward offset in every
line, while `shift` lets you forget the first argument ever existed.
