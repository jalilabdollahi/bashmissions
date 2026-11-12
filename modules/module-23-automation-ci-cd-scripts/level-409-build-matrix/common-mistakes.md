# Common Mistakes

- **One loop with paired indexes.** Wrong: `for i in "${!oses[@]}"` using `${runtimes[i]}` builds only the pairs (linux,3.11) and (macos,3.12). Right: nest the loops so each OS meets each runtime.
- **Letting the first failure end the matrix.** Wrong: a bare `build-job ...` under `set -e`. Right: `build-job ... || rc=$?` and carry on.
- **Substring exclusions.** Wrong: `[[ $excluded == *"$pair"* ]]` makes `linux/3.1` exclude `linux/3.12`. Right: pad with spaces and match `*" $pair "*`.
- **Counting skipped jobs as passes.** Wrong: printing `matrix: 4/4 passed` when two were skipped. Right: increment `ran` only for jobs that run.
- **Trusting `read -a` with empty items.** Wrong: `IFS=, read -ra v <<< "3.11,"` quietly drops the empty item and hides the typo. Right: validate the string with a regex first.
