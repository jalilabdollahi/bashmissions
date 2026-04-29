# Common Mistakes for Overriding a Function

- Defining a function but forgetting to call it.
- Confusing script arguments with function arguments.
- Using `return` for strings; in Bash, functions print string results and `return` sets an exit code.
- Letting a deliberate non-zero function return abort a `set -e` script before it can be handled.
