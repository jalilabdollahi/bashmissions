# Walkthrough: INI Sections

## The plan

In a flat file every line stands alone. In an INI file a line's meaning depends on
the header above it, so the parser is a small state machine: one variable,
`inside`, answers "am I in the section the caller asked about?". Headers change
the state, settings are examined only while it is on.

## Building it

Argument and file checks first: exactly three arguments, and a readable file,
with the exit codes from the objective.

A `trim` function keeps the loop tidy. It removes leading blanks with
`${s#"${s%%[![:space:]]*}"}` and trailing blanks with the mirror expansion.

Then the loop. Trim each line and skip empty lines and lines starting with `#` or
`;`. Next, test for a header with a regex and take the name from the capture:

```bash
if [[ $line =~ ^\[(.*)\]$ ]]; then
  if [[ ${BASH_REMATCH[1]} == "$section" ]]; then inside=1; else inside=0; fi
  continue
fi
```

Every header resets `inside`, including headers of other sections, which is how the
`port` in `[web]` stops being mistaken for the one in `[mail]`. The comparison is a
plain string comparison, so it is case-sensitive and dots or spaces in names are no
problem. Settings before the first header see `inside=0` and are ignored for free.

For a setting inside the wanted section, split at the first `=`:
`${line%%=*}` is everything before it, `${line#*=}` everything after, so a value
like `a=b&c=d` survives intact. Because the loop never stops early, a later
definition overwrites an earlier one.

After the loop: not found means the message on stderr and `exit 1`, otherwise print
the value.

## Trying it by hand

```
printf '[web]\nport=80\n[mail]\nport=25\n' > t.ini
./solution.sh t.ini mail port
```

## Alternative

An `awk` one-liner with a `section` variable does the same in fewer lines, but the
Bash loop is easier to extend (defaults, listing all keys) and has no quoting
traps from shell variables inside awk programs.
