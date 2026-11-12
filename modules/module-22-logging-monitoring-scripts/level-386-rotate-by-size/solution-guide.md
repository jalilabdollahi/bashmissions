# Walkthrough: Rotate by Size

## The plan
Rotation is a conveyor belt. Decide if the log is too big. If yes, push every
numbered copy one place up the belt (the last one drops off), move the live log
into slot 1, and give the service a fresh empty file.

## Step by step
1. Validate the call: exactly three arguments, and the log must exist.

2. Measure. `wc -c < "$log"` prints only the byte count. macOS pads it with
   spaces, so wrap it in `$(( ))` to get a clean integer:

   ```bash
   size=$(( $(wc -c < "$log") ))
   ```

3. Compare with the limit. At exactly MAXBYTES the log is still fine, which is
   why the test is `size <= max`:

   ```bash
   if (( size <= max )); then echo "$log ok ($size bytes)"; exit 0; fi
   ```

4. Make room. Delete the copy numbered KEEP, then walk downwards from KEEP-1 to
   1, moving each existing copy up by one. Going downwards matters: moving
   `.1` to `.2` first would overwrite `.2` before it had moved on:

   ```bash
   rm -f "$log.$keep"
   for (( i = keep - 1; i >= 1; i-- )); do
     [[ -e $log.$i ]] && mv "$log.$i" "$log.$((i + 1))"
   done
   ```

   Careful with `[[ ]] && mv` under `set -e`: when the test is false the loop
   body "fails". Use an `if` as in the answer.

5. Finish: `mv "$log" "$log.1"` then `: > "$log"` to create the new file.

## Try it by hand
```
printf 'x%.0s' {1..50} > shop.log
./solution.sh shop.log 20 3; ls shop.log*
./solution.sh shop.log 20 3
```

## Alternative
`cp` then truncate (`cp log log.1; : > log`) is what `copytruncate` does for
programs that cannot reopen their log. It can lose lines written between the
copy and the truncation, so renaming is preferred when the service can be told
to reopen its file.
