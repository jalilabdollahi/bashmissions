# Assign a Variable

In Bash, variable assignment looks deceptively similar to other languages — but the syntax is strict:

```bash
name=value          # OK
name="value"        # OK, recommended for anything with spaces or special chars
name = "value"      # ERROR: spaces are forbidden
name= value         # ERROR: assigns empty string to name, then tries to run `value`
```

The shell uses spaces as the separator between command and arguments, so `name = value` is parsed as "run command `name` with two arguments". This is a common stumble for people coming from Python or JavaScript.

Notes:

- Variables are untyped — every value is a string. You can interpret it as a number with arithmetic operators (`$((n+1))`) but the storage is text.
- Names can contain letters, digits, and underscores, and cannot start with a digit.
- Convention: lowercase for script-local variables, ALL_CAPS for environment variables and constants.

```bash
greeting="hello"
echo "$greeting"   # hello
```
