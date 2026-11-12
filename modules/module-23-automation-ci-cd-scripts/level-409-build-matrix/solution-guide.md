# Walkthrough: Build Matrix

## The plan
A build matrix is a Cartesian product: every item of one list with every item
of another. Two nested `for` loops are the whole idea. Around them you need
input validation, an exclusion list, and bookkeeping that survives failures.

## Steps
Validate the lists with one regex that means "one or more items, none empty":

```bash
list='^[^,]+(,[^,]+)*$'
```

`linux,,macos` and `3.11,` both fail it. This matters because
`IFS=, read -ra` silently drops a trailing empty field and would make `3.11,`
look valid.

Splitting uses a one-command `IFS` change (it does not leak to the rest of
the script) and `-a` to fill an array:

```bash
IFS=, read -ra oses <<< "$1"
IFS=, read -ra runtimes <<< "$2"
shift 2
```

After `shift 2`, `"$*"` is just the exclusions. Padding it with spaces
(`excluded=" $* "`) allows a whole-word test with a glob, so `linux/3.1`
cannot accidentally match `linux/3.12`:

```bash
if [[ $excluded == *" $os/$rt "* ]]; then echo "[$os/$rt] skipped"; continue; fi
```

The job itself is `build-job --os "$os" --runtime "$rt" || rc=$?`, the same
survive-the-failure pattern as the linter level, with two counters. The last line
of the script, `(( passed == ran ))`, is a neat trick: an arithmetic test returns
status 1 when false, and that becomes the script's exit status.

## Try it by hand
```bash
FAKE_FAIL_JOBS=linux/3.12 ./solution.sh linux,macos 3.11,3.12 macos/3.11
cat .calls.log
```

## Alternative
Brace expansion (`{linux,macos}-{3.11,3.12}`) also makes a product, but only for
lists written literally in the script. The lists here arrive at run time, so the
loops are necessary.
