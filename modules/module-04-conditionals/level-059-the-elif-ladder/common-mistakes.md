# Common Mistakes

- **Writing `else if` instead of `elif`.** It is valid Bash, but it opens a second `if` that needs its own `fi`, so the ladder ends with a missing-`fi` error.
  - Wrong: `else if [[ $code == 404 ]]; then ... fi` (and one `fi` short)
  - Right: `elif [[ $code == 404 ]]; then`
- **Forgetting `then` after an `elif` test.**
  - Wrong: `elif [[ $code == 404 ]]` then `echo`
  - Right: `elif [[ $code == 404 ]]; then`
- **Putting the broad case first.** The first true rung wins, so a vague test above a specific one hides it.
  - Wrong: `if [[ -n $code ]]; then ... elif [[ $code == 200 ]]` (the 200 rung never runs)
  - Right: specific tests first, the catch-all `else` last
- **Giving `else` a condition.** `else` never takes a test; use `elif` for that.
  - Wrong: `else [[ $code == 503 ]]; then`
  - Right: `elif [[ $code == 503 ]]; then`
