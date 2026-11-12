# Walkthrough: Dependency Check

## The plan
The draft is a loop with an early `exit 1`. Early exits are right for most
errors, but here the whole point is to give the human a complete list, so the
loop must finish. It collects names; one decision after the loop reports them.

## Step by step
1. Keep the usage check. With no tool names, `$#` is 0.

2. Make an empty array before the loop:

   ```bash
   missing=()
   ```

3. Test each tool with `command -v`. It prints the path of the tool (or the name
   of a builtin) and succeeds if the tool can be found, and fails silently
   otherwise. We only want the status, so the output goes to `/dev/null`:

   ```bash
   for tool in "$@"; do
     if ! command -v "$tool" > /dev/null 2>&1; then
       missing+=("$tool")
     fi
   done
   ```
   The `if !` form also keeps `set -e` from killing the loop at the first absent
   tool.

4. Decide once. `${#missing[@]}` is the number of elements; `${missing[*]}` joins
   them with single spaces. Preserving argument order falls out of the loop:

   ```bash
   if (( ${#missing[@]} > 0 )); then
     echo "missing: ${missing[*]}" >&2
     exit 1
   fi
   echo "all $# tools found"
   ```

## Try it by hand
```bash
./solution.sh ls cat                      # all 2 tools found
./solution.sh ls octopus-cli kraken       # missing: octopus-cli kraken
```

## Alternative
`which` looks similar, but its behaviour and exit codes differ between systems
(some versions succeed for everything, some print nothing). `command -v` is
specified by POSIX, so it behaves the same everywhere.
