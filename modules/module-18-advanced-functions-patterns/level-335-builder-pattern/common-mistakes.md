# Common Mistakes

- **Comparing before checking it is a number.** Wrong: `(( $1 >= 1 ))` on `lots` aborts with an arithmetic error (or silently treats it as 0). Right: `[[ $1 =~ ^[0-9]+$ ]] && (( ... ))`.
- **Printing before the build is valid.** Wrong: `echo "vm=$name"` early, then failing on the RAM check leaves a half spec on stdout. Right: all output in `build`, after its checks.
- **Not resetting the state.** Wrong: only `declare -A spec` and no `vm_new`: defaults are missing (`spec[ram_gb]` is unbound under `set -u`). Right: one function sets every default.
- **Swallowing a setter's failure.** Wrong: `with_cpus "$value"` as a bare line under `set -e` exits with status 1, not the 2 the spec promises. Right: `with_cpus "$value" || exit 2`.
- **Putting cross-field rules in the setters.** Wrong: `with_ram_gb` checking `cpus` fails depending on argument order (`ram_gb=16 cpus=4` fine, reversed not). Right: relate fields in `build`.
