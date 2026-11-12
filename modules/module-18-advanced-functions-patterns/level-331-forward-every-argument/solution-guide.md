# Walkthrough: Forward Every Argument

## The plan

A wrapper function has one job: add something fixed, then pass everything
else through as if the caller had called the real command. The pass-through
must be exact, whatever the arguments look like.

## Step by step

Inside a function, `$@` holds the function's own arguments. Everything depends
on the quoting:

| Spelling | Result for `"disk full"  ""  "*"` |
|---|---|
| `"$@"` | three words: `disk full`, empty, `*` |
| `"$*"` | one word: `disk full  *` |
| `$@` / `$*` | split on spaces, empty one vanishes, `*` becomes file names |

So the whole function is:

```bash
ticket() {
  tracker-cli new --source=cli "$@"
}
```

and the whole script is that function followed by

```bash
ticket "$@"
```

The second `"$@"` is the script's arguments handed to the function; the first
is the function's arguments handed to `tracker-cli`. Each layer needs its
own pair of quotes.

## What the stub shows

`tracker-cli` prints `args=N` and each argument in brackets. With no
arguments it must report `args=2`: `"$@"` expands to *nothing*, not to one
empty word (the classic result of writing `"$1"` instead). A `*` must arrive
as `[*]`, not as a list of the files in the folder.

## Try it by hand

```
./solution.sh "disk full" urgent
./solution.sh "" '*'
./solution.sh
```

## Alternative

You could write `tracker-cli new --source=cli "$1" "$2" "$3"`, but that fixes the
number of arguments, and passes empty words for missing ones. `"$@"` is the
only spelling that adapts.
