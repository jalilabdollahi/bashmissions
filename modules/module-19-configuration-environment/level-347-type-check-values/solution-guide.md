# Walkthrough: Type-Check Values

## The plan

Config files are text, but the program wants a number, a yes/no and one of a few
modes. For each setting we need a gate that either lets the value through in a
normalised form or complains about it. All gates run, so the engineer sees every
problem, and nothing is printed to stdout unless all of them pass.

## Building it

Read the file the usual way and store the raw text of the three names, starting
from the defaults. Keep the raw text: the error message must quote it exactly.

**Integers.** A regex checks the shape, arithmetic checks the range:

```bash
[[ $workers =~ ^[0-9]+$ ]] && (( 10#$workers >= 1 && 10#$workers <= 64 ))
```

Order matters: the regex runs first so the arithmetic never sees `$((2+2))` or
`lots`. Evaluating text as arithmetic is evaluating it as code, and `10#`
matters too: without it, Bash reads `08` as octal, fails, and prints an error
instead of the number 8. After the check, `workers=$(( 10#$workers ))` normalises
`08` to `8`.

**Booleans.** Lowercase first with `${debug,,}`, then let `case` map a list of
spellings onto one canonical word:

```bash
case ${debug,,} in
  true|yes|on|1)  debug=true ;;
  false|no|off|0) debug=false ;;
  *) echo "invalid debug: ..." >&2; errors=$(( errors + 1 )) ;;
esac
```

Assign only in the success branches, so the error message can still quote the
original text.

**Enums.** The same shape, with four allowed words.

**Verdict.** If `errors` is above zero, `exit 1` before any `echo`. Otherwise print
the three lines.

## Trying it by hand

```
printf 'workers=08\ndebug=Yes\n' > t.conf && ./solution.sh t.conf
```

## Alternative

A helper function per type (`is_int`, `to_bool`) removes repetition when there are
dozens of settings; for three settings, inline checks keep everything visible.
