# Common Mistakes

- **A missing `fi`.** Every nested `if` closes separately, and the error appears at the end of the file.
  - Wrong: three `if` openings and two `fi` lines
  - Right: count them; one `fi` per `if` (an `elif` does not need its own)
- **Checking the environment-specific rule at the wrong level.** The freeze must only block production.
  - Wrong: `if [[ -e freeze.flag ]]` placed before the staging check
  - Right: put it inside the production branch
- **Testing approvals as text.** Comparing numbers with `<` inside `[[ ]]` is alphabetical, so 10 counts as less than 2.
  - Wrong: `elif [[ $approvals < 2 ]]`
  - Right: `elif (( approvals < 2 ))`
- **Putting the broad guard last.** If the tests check comes after the production rules, a red-test deploy might report "needs approvals" first.
  - Wrong: checking approvals before tests
  - Right: follow the policy order: tests, environment, freeze, approvals
- **Forgetting the argument-count guard.** With `set -u`, a missing `$3` kills the script with "unbound variable".
  - Wrong: reading `"$3"` before checking `$#`
  - Right: `[[ $# -ne 3 ]]` first, with the usage message
