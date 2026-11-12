# Common Mistakes

- **Filling the cache inside `$( )`.** Wrong: `r=$(registrar_of "$d")` with the assignment inside the function: the cache lives in a subshell and the next call misses again, so the call log shows repeats. Right: set a variable in the function and call it directly.
- **Treating "empty" as "missing".** Wrong: `[[ -n ${cache[$d]:-} ]]` re-asks forever for a domain whose answer is an empty string. Right: `[[ -z ${cache[$d]+x} ]]` tests for the key.
- **Forgetting `declare -A`.** Without it `cache[$domain]` is an indexed array and `harbourbakery.example` is evaluated as arithmetic: all keys land on index 0 and answers get mixed up. Right: `declare -A cache=()`.
- **Caching before the call succeeds.** Wrong: `cache[$d]=` set to a placeholder first. If the lookup then fails, you have cached garbage. Right: assign only from a successful `$(whois-lookup ...)`.
- **Using one global key for everything.** `cache[last]=...` remembers only one answer. The key must be the argument.
