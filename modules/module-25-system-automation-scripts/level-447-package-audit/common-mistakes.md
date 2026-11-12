# Common Mistakes

- **Comparing versions as strings.** `[[ 3.0.9 < 3.0.13 ]]` is false, because `9` sorts after `1`.
  - Right: split on dots and compare each part with `(( ))`.
- **Letting Bash expand the format.** `-f="${Package} ${Version}\n"` is expanded by the shell (to nothing) before dpkg-query sees it.
  - Right: single quotes, `-f='${Package} ${Version}\n'`.
- **Reading the package list in a pipeline.** `dpkg-query ... | while read ...; do installed[$n]=$v; done` fills the array in a subshell, and it is empty afterwards.
  - Right: `done < <(dpkg-query ...)`
- **Treating `1.9.5p2-3` as a number.** The letters and revision break arithmetic.
  - Right: cut it to the leading digits and dots first.
- **Checking a rule that mentions an uninstalled package.** `${installed[$name]}` under `set -u` aborts with "unbound variable".
  - Right: `${installed[$name]:-}`
