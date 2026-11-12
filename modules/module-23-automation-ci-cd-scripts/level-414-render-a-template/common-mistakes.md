# Common Mistakes

- **Using sed with raw values.** Wrong: `sed "s/\${TITLE}/$TITLE/"` breaks on `Gull & Anchor / Pub` because `&` and `/` are special. Right: build the output with Bash, where the value stays text.
- **Using `eval` to expand.** Wrong: `eval "echo \"$line\""` also runs `$(...)` and backticks found in the template or the values. Right: scan for `${NAME}` yourself and look the name up.
- **Expanding twice.** Wrong: a replace-all loop that restarts from the beginning expands a value containing `${B}` again. Right: move finished text out of the part you still scan.
- **Mixing up unset and empty.** Wrong: `[[ -z ${!name} ]]` calls an intentionally empty value "missing". Right: `[[ -v $name ]]` tells set from unset.
- **Printing a partial result.** Wrong: streaming output while discovering missing names leaves a half-rendered config. Right: collect, report all missing names, and print nothing when any are missing.
- **Letting templates read your script's own variables.** `${!name}` sees every shell variable, not only the environment, so a template asking for `${rest}` or `${template}` would print your internals.
  Wrong: `[[ -v $name ]] && rendered+=${!name}`
  Right: build an allow-list of exported names first (`compgen -e`) and only look up names in it.
