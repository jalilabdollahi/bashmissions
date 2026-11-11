# Walkthrough: The Global Leak

## The plan
This is a detective story. The symptom is that the numbering resets; the cause is
a variable name used in two places. We find the shared name and make one side
private.

## Finding the bug
Add a debugging line to the loop, after the call:

```bash
make_bar "$site"
echo "count is now $count" >&2
```

It always prints 0. Nothing in the main loop sets `count` to 0, so something in
`make_bar` must. Reading the function, `count=${#1}` starts the countdown and
`count=$(( count - 1 ))` runs it down to zero. Functions share the caller's
variables, so this *is* the caller's `count`. On the next iteration the main loop
adds 1 to 0 and gets 1 again.

## The fix
Give the function a private counter:

```bash
make_bar() {
  local n=${#1}
  bar=""
  while (( n > 0 )); do
    bar+="#"
    n=$(( n - 1 ))
  done
}
```

`local count=${#1}` would also work, but a different name avoids confusion for
the reader. `bar` stays global on purpose: it is the function's "output".

## Try it by hand
```bash
./solution.sh dory eel marlin
```

## Alternative
Compute the bar without a loop: `printf -v bar '%*s' "${#1}" ''; bar=${bar// /#}`.
No counter, no leak. It is more cryptic than a loop, though, and the lesson here
is about scoping, not cleverness.
