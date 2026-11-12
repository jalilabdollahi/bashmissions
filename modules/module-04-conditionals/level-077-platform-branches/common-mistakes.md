# Common Mistakes

- **Assuming "not Linux" means macOS.** Other systems exist, and the wrong command could run on them.
  - Wrong: `if [[ $os == Linux ]]; then ...; else sysctl -n hw.ncpu; fi`
  - Right: test for `Darwin` explicitly and add an `unsupported` branch
- **Comparing against the wrong spelling.** macOS reports `Darwin`, not `macOS` or `Mac`.
  - Wrong: `[[ $os == macOS ]]`
  - Right: `[[ $os == Darwin ]]`
- **Calling `uname` in every test.** It works but starts a new process each time and makes the logic harder to follow.
  - Wrong: `if [[ $(uname -s) == Linux ]]; elif [[ $(uname -s) == Darwin ]]`
  - Right: `os="$(uname -s)"` once, then compare `$os`
- **Matching the wrong case.** `uname -s` returns `Linux` with a capital L, and comparisons are case-sensitive.
  - Wrong: `[[ $os == linux ]]`
  - Right: `[[ $os == Linux ]]`
