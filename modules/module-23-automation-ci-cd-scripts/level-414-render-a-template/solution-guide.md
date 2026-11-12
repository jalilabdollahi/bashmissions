# Walkthrough: Render a Template

## The plan
Rendering is search and replace where the replacement comes from somewhere
else. The classic tool is `sed`, but values are then pasted into a program
(`&` and `/` and `\` all have meaning in a sed replacement), which is exactly the
bug Gull & Anchor Pub hit. In Bash we can keep the value as plain data from
start to finish.

## Steps
Process line by line and walk each line left to right with two strings:
`rendered` (done) and `rest` (not yet looked at). Whatever is moved into
`rendered` is never scanned again, so a value that happens to contain `${B}`
stays literal without any special effort.

```bash
while [[ $rest == *'${'* ]]; do
  rendered+=${rest%%'${'*}        # copy up to the next "${"
  rest='${'${rest#*'${'}          # keep "${" at the front of what remains
```

Now ask whether what is at the front is a real placeholder. One regex covers
both forms; group 2 is the whole `:-fallback` part (empty when absent) so we can
tell "no fallback" from "empty fallback":

```bash
re='^\$\{([A-Za-z_][A-Za-z0-9_]*)(:-([^}]*))?\}(.*)$'
```

The lookup rules, in order: a set, non-empty variable wins; otherwise a
fallback if the template gave one; otherwise a variable that is set but empty
renders as nothing; otherwise it is missing. `[[ -v $name ]]` tests whether a
variable is set and `${!name}` reads the variable whose *name* is in `name`:

```bash
if [[ -v $name && -n ${!name} ]]; then rendered+=${!name}
elif [[ -n $has_fallback ]]; then rendered+=$fallback
elif [[ -v $name ]]; then :
else note_missing "$name"; fi
```

When the regex fails (`${1x}`, `${open`), emit the two characters literally and
move past them so the loop makes progress.

Build the output in a variable and print it only if nothing was missing, so a
failed render never leaves a half-filled config on stdout.

## Try it by hand
```bash
printf 'port=${PORT:-80} host=${HOST}\n' > t.tpl
HOST=dory.example ./solution.sh t.tpl
./solution.sh t.tpl; echo "exit $?"
```

## Alternative
`envsubst` does the basic job but not `:-` defaults and happily renders
missing variables as empty. A `sed` loop needs escaping rules for every value.
Walking the text yourself is longer but has no surprises.
