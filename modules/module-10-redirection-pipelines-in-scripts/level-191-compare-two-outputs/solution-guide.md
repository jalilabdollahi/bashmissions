# Walkthrough: Compare Two Outputs

## The plan

Get two sorted package lists, hand them to `diff` as if they were files, and
announce a match when `diff` finds nothing.

## Step by step

The data comes from `pkg-list HOST`, in unsorted order. Two lists in
different order would produce a noisy diff for no reason, so sort them:

```bash
pkg-list "$host_a" | sort
```

Without process substitution you would write both results to temp files, run
`diff`, and remember to delete the files. With `<( ... )`, the shell runs the
command in the background, connects its output to a pipe, and substitutes the
file name of that pipe into your command line. So `diff` receives two
arguments that look like `/dev/fd/63` and `/dev/fd/62`, and reads them like
files:

```bash
diff <(pkg-list "$host_a" | sort) <(pkg-list "$host_b" | sort)
```

`diff` writes its report to stdout and exits 0 if there were no differences.
An `if` branches on that status, so the "hosts match" message needs only one
line of logic:

```bash
if diff <(...) <(...); then
  echo "hosts match"
fi
```

Exit status 1 (differences) just skips the message; the script ends with 0
because the `if` statement itself succeeded.

## The complete solution

See answer.sh.

## Trying it by hand

```bash
mkdir -p hosts
printf 'a\nb\n' > hosts/x.pkgs; printf 'b\nc\n' > hosts/y.pkgs
./solution.sh x y
echo <(true)        # prints /dev/fd/63
```

## An alternative

`comm -3 <(...) <(...)` shows only the differing lines in two columns and
needs sorted input as well. `diff`'s standard format also tells you which
side each line came from, which is what we want here.
