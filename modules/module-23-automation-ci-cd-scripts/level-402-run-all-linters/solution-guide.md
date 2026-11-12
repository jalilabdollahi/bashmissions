# Walkthrough: Run All Linters

## The plan
Level 401 stopped at the first failure because later steps depended on earlier
ones. Linters are independent: knowing the shell script is wrong tells you
nothing about the YAML. So we run all of them, remember who failed, and turn
the collected list into one verdict at the end.

## Building it
Guard first, so a missing file list never reaches a linter:

```bash
if (( $# == 0 )); then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi
```

An empty array is the memory for failed linter names:

```bash
failed=()
```

The loop calls each tool through the variable. The command name is data here,
which is why the variable is quoted and why `"$@"` forwards the files unchanged:

```bash
for linter in shellcheck yamllint markdownlint; do
  rc=0
  "$linter" -q "$@" || rc=$?
```

If you wrote the call bare, `set -e` would end the script on the first red
linter and you would be back to level 401. With `|| rc=$?` the failure is
"handled", so execution continues and `rc` holds the code.

```bash
  if (( rc == 0 )); then
    echo "$linter: ok"
  else
    echo "$linter: FAILED (exit $rc)"
    failed+=("$linter")
  fi
done
```

Finally the verdict. `${failed[*]}` joins the elements with a space, and
`${#failed[@]}` is how many there are:

```bash
if (( ${#failed[@]} > 0 )); then
  echo "lint failed: ${failed[*]}" >&2
  exit 1
fi
echo "all linters passed"
```

## Try it by hand
```bash
FAKE_RC_YAMLLINT=2 ./solution.sh a.sh b.yaml; echo "exit $?"
cat .calls.log      # the stubs record each call
```

## Alternative
A running `status=0; ... status=1` flag is shorter, but an array also tells you
*which* linters failed, and that is the line people grep for in build logs.
