# Debrief: The main() Pattern

Bash runs a script top to bottom as it reads it. A function only exists after the
line that defines it has been executed, so a loose script forces you to put helpers
above their callers and makes it easy to append a stray command at the bottom.
The `main` pattern separates two phases: first the file *defines* everything, then
one last line *runs* it. By the time `main "$@"` executes, every function in the
file already exists, so you can order functions by readability instead of by
dependency, with the high-level story first if you like.

`"$@"` hands the script's arguments to `main` untouched. Inside a function, `$1`
and `$#` refer to the function's own arguments, which is why `main` needs them
passed explicitly. A function ends with `return`, and the script's exit status is
simply the status of its last command: `main "$@"`.

The pattern also pays off for tools you did not write. A reader scanning a long
file jumps to the bottom, sees `main "$@"`, and knows where the story starts. It
is also the hook for level 287, where the same last line gets a guard so the file
can be sourced for testing.

Going further: the variables inside `main` are still global unless you say
otherwise. Level 281 deals with that.
