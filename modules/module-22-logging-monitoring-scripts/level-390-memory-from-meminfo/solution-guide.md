# Walkthrough: Memory from meminfo

## The plan
`/proc/meminfo` is a text file where each line is `Name:  value kB`. Load every
line into an associative array, so that any figure is one lookup away, then do
integer arithmetic and print the report. The twist is that old kernels lack
`MemAvailable`, so the script needs a fallback.

## Step by step
1. Validate the arguments and the file. Distinct exit codes tell the caller
   what went wrong: 2 for misuse, 1 for an unreadable file, 3 for a file that
   is not in the expected format.

2. Load the file. The line `MemTotal:     8388608 kB` has a colon right after the
   name and then spaces. Setting `IFS=': '` for `read` makes both separators:

   ```bash
   declare -A mem
   while IFS=': ' read -r key value _unit; do
     [[ -n $key ]] && mem[$key]=$value
   done < "$file"
   ```

   Lines such as `HugePages_Total: 0` have no unit; the extra variable simply
   stays empty.

3. Pick the "available" figure. `${mem[MemAvailable]:-}` is empty when the key
   is absent, which makes the test easy:

   ```bash
   avail=${mem[MemAvailable]:-}
   [[ -n $avail ]] || avail=$(( ${mem[MemFree]:-0} + ${mem[Buffers]:-0} + ${mem[Cached]:-0} ))
   ```

4. Compute. Multiply before dividing: `used * 100 / total`. Divide kB by 1024
   for MiB.

5. Print the memory line, the swap line (special case for no swap) and the
   warning, with its exit status 1.

## Try it by hand
```
./solution.sh fixtures/meminfo-ok 90
./solution.sh fixtures/meminfo-tight 90; echo $?
./solution.sh fixtures/meminfo-old 80
```

## Alternative
`awk '/^MemTotal/ {print $2}' file` fetches one number per call. With four or
five numbers needed, that is five passes over the file and five commands; one
loop and one table is easier to read and extend.
