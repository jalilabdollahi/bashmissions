# Walkthrough: Show Effective Config

## The plan

The earlier levels each computed values from layers and printed them. This one adds
two things: the list of names is no longer fixed (files and the environment can
introduce new ones), and every value must remember who set it. Use two associative
arrays, `value` and `source`. Each layer writes both; later layers overwrite earlier
ones; printing happens last.

## Building it

Layer 1 puts the four defaults in, with `source` set to `default`.

Layer 2 reads the optional file. A name only counts if it matches
`^[a-z_][a-z0-9_]*$`, which quietly drops `Colour=red`, and an empty value is
ignored, so `log=` does not blank the default. Writing `value[$key]` and
`source[$key]` every time a line qualifies gives "the last line counts" for free.

Layer 3 is the environment. You cannot loop over a list of names you do not know, so
ask Bash: `compgen -v LF_` prints the names of all variables that start with `LF_`.
Check each against `^LF_[A-Z0-9_]+$` (this rejects `LF_` alone and `LF_lower`),
skip empty ones, read the value indirectly with `${!var}`, and derive the setting
name with `${var#LF_}` followed by `${key,,}`. `LFX_PORT` never shows up because
`LF_` is a prefix of the variable name, not of the substring.

Now the table. Find the longest name with a loop over `"${!value[@]}"`. Associative
arrays have no defined order, so sort the names yourself:

```bash
printf '%s\n' "${!value[@]}" | sort
```

and format each line with `printf '%-*s = %s [%s]\n' "$width" ...`; the `*` takes
the width from the argument list.

## Trying it by hand

```
printf 'port=9000\n' > t.conf
LF_WORKERS=8 ./solution.sh t.conf
```

## Alternative

You could skip the second array and print only values, but then nobody learns which
layer to edit. The `[source]` column is the feature; the sorting is only polish.
