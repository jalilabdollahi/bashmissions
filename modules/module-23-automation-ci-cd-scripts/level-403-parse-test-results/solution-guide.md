# Walkthrough: Parse Test Results

## The plan
TAP is easy to read for humans and just as easy for scripts, as long as you
treat it as a protocol and not as text to grep. Each line is one of: the plan
(`1..N`), a result (`ok`/`not ok`), or noise. We classify each line once, keep
four counters, and use the plan to notice a runner that died early.

## Steps
Fail early on an unreadable file, then set up the counters:

```bash
file=${1:-}
[[ -r $file && ! -d $file ]] || { echo "cannot read $file" >&2; exit 2; }
passed=0 failed=0 skipped=0 todo=0 planned=0
```

Read with `IFS= read -r` so indentation and backslashes survive. The plan line:

```bash
if [[ $line =~ ^1\.\.([0-9]+) ]]; then planned=${BASH_REMATCH[1]}; continue; fi
```

The result line needs three captures: status, number, description. The `^`
anchor is what makes `# not ok 9 ...` and indented YAML blocks invisible:

```bash
if [[ $line =~ ^(not\ ok|ok)[[:space:]]+([0-9]+)[[:space:]]*(-[[:space:]]*)?(.*)$ ]]; then
```

Inside, look for a directive in the description, remember it, and cut it off with
`${desc%% #*}`. Then a small decision table: `ok` + SKIP is skipped, `ok` is
passed, `not ok` + TODO is todo, `not ok` is a failure that prints `FAIL N: desc`.

After the loop print the summary and judge the run:

```bash
ran=$(( passed + failed + skipped + todo ))
if (( planned != ran )); then
  echo "plan mismatch: planned $planned, ran $ran" >&2; exit 3
fi
(( failed == 0 )) || exit 1
```

## Try it by hand
```bash
printf '1..2\nok 1 - a\nnot ok 2 - b\n' > t.tap
./solution.sh t.tap; echo "exit $?"
```

## Alternative
`awk` can count the same in one pass, and is fine for a quick tally. The Bash
loop wins here because the exit code, the stderr message and the per-failure
lines all need decisions that read more naturally as `if` statements.
