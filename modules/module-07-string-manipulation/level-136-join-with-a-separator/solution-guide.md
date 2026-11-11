# Walkthrough: Join with a Separator

## The plan
Take the separator off the argument list, keep the rest as an array, and build the
result one host at a time. The separator goes in front of every host except the
first.

## Arrays from arguments
`shift` removes `$1`, so `"$@"` now holds only the hosts. `hosts=("$@")` copies
them into an array, one element per argument, even if a host contains a space.
`"${hosts[@]}"` expands to all the elements, each as its own word.

## The "separator only between" trick
Start with an empty string and append. The expansion `${joined:+$sep}` means:
"if `joined` is non-empty, use `$sep`, otherwise nothing". So the first host is
appended alone, and each later host is appended with the separator in front:

```bash
joined+="${joined:+$sep}$host"
```

`+=` appends to the existing value.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
sep=$1
shift
hosts=("$@")
joined=""
for host in "${hosts[@]}"; do
  joined+="${joined:+$sep}$host"
done
echo "$joined"
```

With no hosts the loop never runs and an empty line is printed.

## Try it by hand
```bash
./solution.sh ", " anchovy barracuda dory
./solution.sh ":" eel
./solution.sh "|"
```

## Alternative
For a **single-character** separator there is a shortcut:
`IFS=,; echo "${hosts[*]}"` joins with the first character of `IFS`. It is concise,
but it cannot do `", "` (only the comma would be used), and it changes `IFS`
globally unless you wrap it in a subshell or function. The loop works for every
separator, which is why this level uses it.
