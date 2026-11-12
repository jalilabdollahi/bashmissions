# Walkthrough: Secrets from Files

## The plan

The secrets are named on the command line, so the script has to read variables
whose names it only learns at run time. For each name there are four outcomes:
ambiguous, from a file, from the environment, missing. We process every name,
count problems, and exit with 1 at the end if there were any.

## Building it

After the usage check, loop over `"$@"`. Inside, build the file variable's name
and read both variables through indirect expansion:

```bash
file_var="${name}_FILE"
direct=${!name:-}
path=${!file_var:-}
```

`${!name}` means "the value of the variable called whatever `name` contains". The
`:-` default matters twice: it keeps `set -u` quiet for variables that do not
exist, and it makes empty and unset look the same, which is what the task asks.

Check the conflict first: if `direct` and `path` are both non-empty, the operator
asked for two things at once, and silently preferring one would hide a mistake.
Report it, count it, `continue` to the next name.

With a path, make sure it is a readable regular file, then slurp it:

```bash
secret=$(<"$path")
```

`$(<file)` is a Bash shortcut that reads the file without starting `cat`, and
command substitution removes trailing newlines, so a secret saved with an editor's
final newline has its true length. Without a path, use `direct`. With neither,
report `missing`. An empty file is a distinct problem, worth its own message.

Finally print the length with `${#secret}`; never the secret. The last line,
`(( problems == 0 )) || exit 1`, turns the counter into the exit status.

## Trying it by hand

```
mkdir -p secrets && printf 's3cr3t\n' > secrets/token
API_TOKEN_FILE=secrets/token ./solution.sh API_TOKEN
```

## Alternative

`eval "value=\$$name"` also reads a variable by name, but `eval` runs whatever the
name contains. `${!name}` does the same job with none of the risk.
