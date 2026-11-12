# Walkthrough: Commands in Arrays

## The plan
The starter glues a command together as text, then lets the shell re-read the text.
We keep the same idea, build `find`'s arguments one at a time, but store each in an
array element, so nothing is ever re-parsed.

## Why the string fails
After `cmd="find $dir -type f ( -name $p ..."`, the quotes you typed are gone: the
variable contains plain characters. Running `$cmd` splits it at spaces, so the
pattern `Q3 *` becomes `Q3` and `*`, and the `*` is globbed against the current
folder. Wrapping it in `eval` fixes some cases and opens a code-injection hole.

## Steps
1. Start the array with the fixed part:
   ```bash
   args=(find "$dir" -type f)
   ```
2. If there are patterns, open find's group with `'('`, then for every pattern add
   `-o` (except before the first) and `-name "$p"`. Close with `')'`.
   ```bash
   args+=( -name "$p" )
   ```
   `+=( ... )` appends elements; each quoted `"$p"` stays one element.
3. Run it. The quotes in `"${args[@]}"` make bash expand to one word per element:
   ```bash
   "${args[@]}" | sort
   ```

## Complete solution
See answer.sh in the level folder.

## Try it
```
mkdir logs; touch logs/a.log "logs/Q3 sales.txt"
./solution.sh logs '*.log' 'Q3 *'
```

## Alternative
You can skip the array for a single pattern with `find "$dir" -name "$1"`. The
array pays off once the number of options is not known in advance, which is the
usual case for wrappers around `find`, `tar`, `rsync` or `docker`.
