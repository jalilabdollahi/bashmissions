# Common Mistakes

- **Calling the hook while registering.** Wrong: `before_hooks+=("$(hook_lock "$site")")` stores the hook's output text, and runs it at the wrong moment. Right: append only the name, `before_hooks+=(hook_lock)`.
- **Expanding the array without quotes.** `for h in ${before_hooks[@]}` splits on spaces and globs; one day a name with a space breaks it. Right: `"${before_hooks[@]}"`.
- **Using `=` instead of `+=`.** Wrong: `before_hooks=(hook_snapshot)` replaces the list, so only the last registration survives. Right: `before_hooks+=(hook_snapshot)`.
- **Forgetting to pass the argument on.** Wrong: `"$h"` calls the hook with nothing, so it prints "locking " with no site. Right: `"$h" "$site"`.
- **Validating after the deploy ran.** If you check specs while running, a late bad spec leaves a half-finished deploy. Right: register and validate everything, then deploy.
