# Common Mistakes

- **Reading DEBUG without a default under `set -u`.** Wrong: `if [[ $DEBUG == 1 ]]` dies with "DEBUG: unbound variable" on a normal run. Right: `${DEBUG:-}`.
- **Ending the function with `&&`.** Wrong: `debug() { [[ ${DEBUG:-} == 1 ]] && echo "debug: $*" >&2; }` returns 1 when DEBUG is off, and `set -e` kills the script on the first `debug` call. Right: use `if ...; then ...; fi`.
- **Printing debug output on stdout.** Wrong: `echo "debug: $*"` pollutes the result that other scripts parse. Right: `echo "debug: $*" >&2`.
- **Treating any non-empty value as on.** `[[ -n ${DEBUG:-} ]]` makes `DEBUG=0` turn debugging on. Compare with `== 1` as the objective says.
- **Forgetting that the variable must be exported to children.** `DEBUG=1 ./solution.sh` is fine, but `DEBUG=1; ./solution.sh` sets a shell variable the script never sees. Put it on the same line or `export` it.
